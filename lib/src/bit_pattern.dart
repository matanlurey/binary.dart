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
  ///
  /// The result of [BitPattern.capture] returns a `List<int>`, which is a list
  /// encapsulating the bits that matched a [BitPart.v], if any, indexed by
  /// their occurrence (left-to-right) when matched:
  /// ```
  /// final pattern = BitPatternBuilder([
  ///   BitPart(1),
  ///   BitPart(0),
  ///   BitPart(1),
  ///   BitPart.v(1)
  /// ]).build();
  ///
  /// print(pattern.match(0xD /* 0b1101 */)); // [1]
  /// ```
  BitPattern<List<int>> build([String name]) {
    var capture = 0;
    var length = 0;
    for (final part in _parts) {
      length += part._length;
      if (part._isVar) {
        capture++;
      }
    }
    if (length > 32) {
      throw StateError('Cannot build a pattern for > 32-bits, got $length');
    }
    return _InterpretedBitPattern(
      length,
      _parts.length - capture,
      _isSetMask(length),
      _nonVarMask(length),
      _buildCapture(length, capture),
      name,
    );
  }

  List<_CaptureBits> _buildCapture(int totalLength, int totalCaptures) {
    if (totalCaptures == 0) return const [];

    final result = List<_CaptureBits>();
    var iterated = 0;

    for (final part in _parts) {
      if (part._isVar) {
        final sPart = part.unsafeCast<_Segment>();
        final left = totalLength - iterated;
        result.add(_CaptureBits(sPart._name, left - 1, sPart._length));
      }
      iterated += part._length;
    }

    return result;
  }

  /// Returns a "is-set" masking [int] for the current pattern.
  ///
  /// The k'th bit == 1 iff bit k of [this] == 1:
  /// - `{1, 1, 1, 1} == 0xF == 0b1111`
  /// - `{1, 1, V, 1} == 0xD == 0b1101`
  /// - `{0, 0, 0, 0} == 0x0 == 0b0000`
  /// - `{1, 0, 1, V} == 0xA == 0b1010`
  int _isSetMask(int length) {
    var mask = 0;
    for (final part in _parts) {
      if (part._is1) {
        mask = mask.setBit(length - 1);
      }
      length -= part._length;
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
  int _nonVarMask(int length) {
    var mask = 0;
    for (final part in _parts) {
      if (!part._isVar) {
        mask = mask.setBit(length - 1);
      }
      length -= part._length;
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

  /// Whether the value represents `1`.
  bool get _is1;

  /// Whether the value represents a variable.
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
///   for (final pattern in patterns..sort()) {
///     if (pattern.matches(bits)) {
///       // ...
///     }
///   }
/// }
/// ```
///
/// > NOTE: You can only compare [ComputedBitPattern]s of the same type!
abstract class BitPattern<T> implements Comparable<BitPattern<T>> {
  /// A list of named variables (to use in conjunction with [capture]).
  List<String> get names;

  /// Returns an element [T] iff it [matches], otherwise `null`.
  T capture(int input);

  /// Returns true iff [input] bits matches this pattern.
  bool matches(int input);
}

class _CaptureBits {
  /// Name of the variable capturing bits.
  final String name;

  /// Left-most bit.
  final int left;

  /// Size of capture.
  final int size;

  const _CaptureBits(this.name, this.left, this.size);

  /// Returns bits from [bits] from [left] of [size].
  int capture(int bits) => bits.bitChunk(left, size);

  @override
  String toString() {
    if (_assertionsEnabled) {
      return 'CaptureBits { $name, $left :: $size }';
    } else {
      return super.toString();
    }
  }
}

/// A pre-computed [BitPattern] that relies on generic (programmatic) execution.
class _InterpretedBitPattern implements BitPattern<List<int>> {
  final int _length;
  final int _nonVarBits;
  final int _isSetMask;
  final int _nonVarMask;
  final List<_CaptureBits> _capture;
  final String _name;

  const _InterpretedBitPattern(
    this._length,
    this._nonVarBits,
    this._isSetMask,
    this._nonVarMask,
    this._capture,
    this._name,
  );

  List<int> _newList(int size) {
    if (size <= 8) return Uint8List(size);
    if (size <= 16) return Uint16List(size);
    if (size <= 32) return Uint32List(size);
    throw StateError('Cannot match a pattern of > 32-bits, got $size.');
  }

  @override
  int compareTo(covariant _InterpretedBitPattern other) {
    return _nonVarBits.compareTo(other._nonVarBits);
  }

  @override
  List<String> get names => _capture.map((b) => b.name).toList();

  @override
  List<int> capture(int input) {
    if (matches(input)) {
      // Short-circuit when there are no variables.
      if (_capture.isEmpty) return const [];

      // Return a variable for each capturing name.
      final result = _newList(_capture.length);
      for (var i = 0; i < _capture.length; i++) {
        result[i] = _capture[i].capture(input);
      }

      return result;
    } else {
      return null;
    }
  }

  /// Returns whether [input] matches this pattern.
  ///
  /// - First, bits are computed by XOR-ing (`^`) [input] and [_isSetMask],
  ///   producing bits where the k-th byte is `1` iff either but not both the
  ///   k-th bytes of [input] or [_isSetMask] is `1`.
  ///
  /// - Next, negate (`~`) the bits, flipping `0` and `1`s.
  ///
  /// - Next, bits are computed by AND-ing (`&`) bits with [_nonVarMask],
  ///   producing bits where the k-th byte is `1` iff _both_ the k-th bytes of
  ///   bits and [_nonVarMask] is `1`.
  ///
  /// - Finally, returns if the computed bits are identical to [_nonVarMask].
  @override
  bool matches(int input) => ~(input ^ _isSetMask) & _nonVarMask == _nonVarMask;

  @override
  String toString() {
    if (_assertionsEnabled) {
      return (StringBuffer()
            ..writeln('InterpretedBitPattern: $_length-bits {')
            ..writeln('  name:       ${_name ?? '<Unnamed>'}')
            ..writeln('  capture:    ${names.join(', ')}')
            ..writeln('  isSetMask:  ${_isSetMask.toBinaryPadded(_length)}')
            ..writeln('  nonVarMask: ${_nonVarMask.toBinaryPadded(_length)}')
            ..writeln('}'))
          .toString();
    } else {
      return super.toString();
    }
  }
}

/// Provides the capabilityto create a [BitPatternGroup] from multiple patterns.
///
/// See [BitPatternGroup] and [toGroup] for details.
extension BitPatternsX<T> on List<BitPattern<T>> {
  /// Returns a `List<BitPattern<?>>` as a computed group of [BitPatternGroup].
  BitPatternGroup<T, V> toGroup<V extends BitPattern<T>>() {
    ArgumentError.checkNotNull(this, 'this');
    if (isEmpty) {
      throw ArgumentError.value(this, 'this', 'Cannot be an empty list');
    }
    return BitPatternGroup._(toList()..sort());
  }
}

/// Allows matching integer values against a collection of [BitPattern]s.
///
/// A [BitPatternGroup] is a collection of [BitPattern]s which may match a given
/// set of bits (represented as an [int]). Unlike a [BitPattern], a
/// [BitPatternGroup] _matches_ a [BitPattern], which in turn can then capture
/// bits:
/// ```
/// void example(List<BitPattern<List<int>> patterns, int value) {
///   final group = patterns.toGroup();
///   final match = group.match(value);
///
///   // Prints out the captured bits.
///   print(match.capture(value));
/// }
/// ```
///
/// This utility is useful for creating decoders (for example, for emulators).
@sealed
class BitPatternGroup<T, V extends BitPattern<T>> {
  final List<BitPattern<T>> _sortedPatterns;

  const BitPatternGroup._(this._sortedPatterns);

  /// Returns which [BitPattern] is capable of decoding the provided [bits].
  ///
  /// Returns `null` if no match found.
  BitPattern<T> match(int bits) {
    for (final pattern in _sortedPatterns) {
      if (pattern.matches(bits)) {
        return pattern;
      }
    }

    return null;
  }

  @override
  String toString() {
    if (_assertionsEnabled) {
      return 'BitPatternGroup { $_sortedPatterns }';
    } else {
      return super.toString();
    }
  }
}
