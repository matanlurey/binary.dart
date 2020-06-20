// ignore_for_file: prefer_is_empty

part of '../binary.dart';

/// Builds a sequence of binary digits.
///
/// The pattern may only contain 0s, 1s, and variable-length dynamic segments.
///
/// ## Usage
/// ```
/// final pattern = BitPattern([
///   BitPart(1),
///   BitPart(0),
///   BitPart(1),
///   BitPart.v(1, 'FLAG'),
/// ])
/// 0x3.matches(pattern); // == true
/// 0xB.matches(pattern); // == true
/// 0xF.matches(pattern); // == false
/// ```
///
/// > NOTE: To be able to compile a [BitPattern] into ahead-of-time generated
/// > code in the future, ensure that the resulting type is a compile-time
/// > constant (`const`).
@sealed
class BitPatternBuilder {
  final List<BitPart> _parts;

  /// Creates a new builder of the provided parts.
  const BitPatternBuilder(this._parts) : assert(_parts.length > 0);

  /// Compiles and returns a [BitPattern] capable of matching.
  ///
  /// This relies on the default implementation [CompiledBitPattern], which is
  /// a programmatic execution based on some pre-computed values from the
  /// provided `List<BitPart>`.
  BitPattern<List<int>> build() {
    var length = 0;
    for (final part in _parts) {
      length += part._length;
    }
    if (length > 32) {
      throw StateError('Cannot build a pattern for > 32-bits, got $length');
    }
    return _InterpretedBitPattern(
      length,
      _isSetMask,
      _nonVarMask,
    );
  }

  /// Returns a "is-set" masking [int] for the current pattern.
  ///
  /// The k'th bit == 1 iff bit k of [this] == 1:
  /// - `{1, 1, 1, 1} == 0xF == 0b1111`
  /// - `{1, 1, V, 1} == 0xD == 0b1101`
  /// - `{0, 0, 0, 0} == 0x0 == 0b0000`
  /// - `{1, 0, 1, V} == 0xA == 0b1010`
  int get _isSetMask {
    final length = _parts.length;
    var mask = 0;
    for (var i = 0; i < length; i++) {
      if (_parts[i]._is1) {
        mask = mask.setBit(length - i - 1);
      }
    }
    return mask;
  }

  /// Returns a "not-a-var" masking [int] for the current pattern.
  ///
  /// The k'th bit == 1 iff bit k of [this] is _not_ a variable:
  /// - `{1, 1, 1, 1} == 0xF == 0b1111`
  /// - `{1, 1, V, 1} == 0xD == 0b1101`
  /// - `{0, 0, 0, 0} == 0x0 == 0b0000`
  /// - `{1, 0, 1, V} == 0xE == 0b1110`
  int get _nonVarMask {
    final length = _parts.length;
    var mask = 0;
    for (var i = 0; i < length; i++) {
      if (!_parts[i]._isVar) {
        mask = mask.setBit(length - i - 1);
      }
    }
    return mask;
  }
}

/// Part of a [BitPattern] that will be used to match.
abstract class BitPart {
  /// A static part of a pattern, e.g. either `0` or `1`, that _must_ match.
  const factory BitPart(int bit) = _Bit;

  /// A dynamic variable (segment) of a pattern of [length] bytes.
  ///
  /// Optionally has a [name] (for debug purposes).
  const factory BitPart.v(int length, [String name]) = _Segment;

  /// Length of the part.
  int get _length;

  bool get _is1;
  bool get _isVar;
}

class _Bit implements BitPart {
  final int _bit;

  const _Bit(this._bit) : assert(_bit == 0 || _bit == 1, 'Invalid: $_bit');

  @override
  bool operator ==(Object o) => o is _Bit && _bit == o._bit;

  @override
  int get hashCode => _bit.hashCode;

  @override
  int get _length => 1;

  @override
  bool get _is1 => _bit == 1;

  @override
  bool get _isVar => false;

  @override
  String toString() {
    if (_assertionsEnabled) {
      return 'Bit { $_bit }';
    } else {
      return super.toString();
    }
  }
}

class _Segment implements BitPart {
  final String _name;

  const _Segment(this._length, [this._name]) : assert(_length >= 1);

  @override
  bool operator ==(Object o) => o is _Segment && _length == o._length;

  @override
  int get hashCode => _length.hashCode;

  @override
  final int _length;

  @override
  bool get _is1 => false;

  @override
  bool get _isVar => true;

  @override
  String toString() {
    if (_assertionsEnabled) {
      return _name != null
          ? 'Segment { $_name: $_length-bits }'
          : 'Segment { $_length-bits }';
    } else {
      return super.toString();
    }
  }
}

/// Represents the result of calling [BitPattern.compile].
///
/// A [implementation] (typically) has all of the information available to
/// start matching and extracting variables from inputs, and various different
/// implementations are possible.
///
/// The default implementation is a pre-computed interpreter.
///
/// A [ComputedBitPattern] is [Comparable], e.g. it can be sorted in terms of
/// specificity (greatest to least), in order to make it easier to iterate
/// through a `List<ComputedBitPattern>` and check for matches:
/// ```
/// void example(List<ComputedBitPattern> patterns, int bits) {
///   for (final pattern in patterns.sort()) {
///     if (pattern.matches(bits)) {
///       // ...
///     }
///   }
/// }
/// ```
///
/// > NOTE: You can only compare [ComputedBitPattern]s of the same type!
abstract class BitPattern<T> implements Comparable<BitPattern<T>> {
  /// Returns true iff [input] bits matches this pattern.
  bool matches(int input);
}

/// A pre-computed [BitPattern] that relies on generic (programmatic) execution.
class _InterpretedBitPattern implements BitPattern<List<int>> {
  final int _length;
  final int _isSetMask;
  final int _nonVarMask;

  const _InterpretedBitPattern(
    this._length,
    this._isSetMask,
    this._nonVarMask,
  );

  @override
  int compareTo(covariant _InterpretedBitPattern other) {
    throw UnimplementedError();
  }

  @override
  bool matches(int input) => ~(input ^ _isSetMask) & _nonVarMask == _nonVarMask;

  @override
  String toString() {
    if (_assertionsEnabled) {
      return (StringBuffer()
            ..writeln('InterpretedBitPattern: $_length-bits {\n')
            ..writeln('')
            ..writeln('}'))
          .toString();
    } else {
      return super.toString();
    }
  }
}
