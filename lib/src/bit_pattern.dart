// ignore_for_file: prefer_is_empty

import 'dart:typed_data';

import 'package:meta/meta.dart';

import '_utils.dart';
import 'int.dart';

/// Builds a sequence of binary digits.
///
/// The pattern may only contain 0s, 1s, and variable-length dynamic segments.
///
/// ## Usage
/// ```
/// final pattern = BitPattern([
///   BitPart.one,
///   BitPart.zero,
///   BitPart.one,
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
abstract class BitPatternBuilder {
  /// Creates a new builder of the provided parts.
  const factory BitPatternBuilder(List<BitPart> parts) = _BitPatternBuilder;

  /// Creates a new builder that will parse [bits].
  ///
  /// Supported characters are `0`, `1`, `A-Za-z`, and `_`, where `0` and `1`
  /// are parsed as a `BitPart`, and `A-Za-z` are parsed as a `BitPart.v`, and
  /// `_` is ignored (can be used to help separate bits for readability).
  ///
  /// It is considered invalid to have the same variable more than once within
  /// a pattern (e.g. `01AA01AA`), to have more than one `_` in a row (e.g.
  /// `0101__0101`), or to have an empty or `null` string.
  const factory BitPatternBuilder.parse(String? bits) = _BitPatternParser;

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
  ///   BitPart.one,
  ///   BitPart.zero,
  ///   BitPart.one,
  ///   BitPart.v(1)
  /// ]).build();
  ///
  /// print(pattern.match(0xD /* 0b1101 */)); // [1]
  /// ```
  BitPattern<List<int>?> build([String? name]);
}

class _BitPatternBuilder implements BitPatternBuilder {
  final List<BitPart> _parts;

  const _BitPatternBuilder(this._parts) : assert(_parts.length > 0);

  @override
  BitPattern<List<int>?> build([String? name]) {
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

    final result = <_CaptureBits>[];
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

class _BitPatternParser implements BitPatternBuilder {
  static bool _isAlphabetic(int c) {
    const $a = 97;
    const $z = 122;
    const $A = 65;
    const $Z = 90;
    return c >= $a && c <= $z || c >= $A && c <= $Z;
  }

  final String? _bits;

  const _BitPatternParser(this._bits);

  @override
  BitPattern<List<int>?> build([String? name]) {
    ArgumentError.checkNotNull(_bits);
    if (_bits!.isEmpty) {
      throw ArgumentError.value(_bits, 'bits', 'Must be non-empty');
    }

    final used = Set<String?>();
    final parts = <BitPart>[];

    String? variable;
    var variableLength = 0;
    var parsedUnderscore = false;

    void completeVariable() {
      assert(variable!.isNotEmpty);
      assert(variableLength > 0);
      parts.add(BitPart.v(variableLength, variable));
      used.add(variable);
      variableLength = 0;
      variable = null;
    }

    for (var i = 0; i < _bits!.length; i++) {
      final character = _bits![i];
      switch (character) {
        case '0':
          if (variable != null) {
            completeVariable();
          }
          parts.add(BitPart.zero);
          break;
        case '1':
          if (variable != null) {
            completeVariable();
          }
          parts.add(BitPart.one);
          break;
        case '_':
          if (parsedUnderscore) {
            throw FormatException('Cannot have mulitple _\'s', _bits, i);
          } else {
            parsedUnderscore = true;
            continue;
          }
          break;
        default:
          final code = character.codeUnitAt(0);
          if (_isAlphabetic(code)) {
            if (variable == character) {
              variableLength++;
            } else {
              if (variable != null) {
                completeVariable();
              }
              if (used.contains(character)) {
                throw FormatException(
                  'Already used variable $character',
                  _bits,
                  i,
                );
              }
              variable = character;
              variableLength = 1;
            }
          } else {
            throw FormatException(
              'Not a valid character: $character',
              _bits,
              i,
            );
          }
          break;
      }
      parsedUnderscore = false;
    }
    if (variable != null) {
      completeVariable();
    }
    return _BitPatternBuilder(parts).build(name);
  }
}

/// Part of a [BitPattern] that will be used to match.
abstract class BitPart {
  /// A static `0` within a [BitPattern].
  static const BitPart zero = _Bit(0);

  /// A static `1` within a [BitPattern].
  static const BitPart one = _Bit(1);

  /// A dynamic variable (segment) of a pattern of [length] bytes.
  ///
  /// Optionally has a [name] (for debug purposes).
  @literal
  const factory BitPart.v(int length, [String? name]) = _Segment;

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
    if (assertionsEnabled) {
      return 'Bit { $_bit }';
    } else {
      return super.toString();
    }
  }
}

class _Segment implements BitPart {
  final String? _name;

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
    if (assertionsEnabled) {
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
  List<String?> get names;

  /// Returns an element [T] iff it [matches], otherwise `null`.
  T capture(int input);

  /// Returns true iff [input] bits matches this pattern.
  bool matches(int input);
}

class _CaptureBits {
  /// Name of the variable capturing bits.
  final String? name;

  /// Left-most bit.
  final int left;

  /// Size of capture.
  final int size;

  const _CaptureBits(this.name, this.left, this.size);

  @override
  int get hashCode => name.hashCode ^ left.hashCode ^ size.hashCode;

  @override
  bool operator ==(Object o) {
    if (o is _CaptureBits) {
      return name == o.name && left == o.left && size == o.size;
    }
    return false;
  }

  /// Returns bits from [bits] from [left] of [size].
  int capture(int bits) => bits.bitChunk(left, size);

  @override
  String toString() {
    if (assertionsEnabled) {
      return 'CaptureBits { $name, $left :: $size }';
    } else {
      return super.toString();
    }
  }
}

/// A pre-computed [BitPattern] that relies on generic (programmatic) execution.
class _InterpretedBitPattern implements BitPattern<List<int>?> {
  static bool _listEquals(List<Object> a, List<Object> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  final int _length;
  final int _nonVarBits;
  final int _isSetMask;
  final int _nonVarMask;
  final List<_CaptureBits> _capture;
  final String? _name;

  const _InterpretedBitPattern(
    this._length,
    this._nonVarBits,
    this._isSetMask,
    this._nonVarMask,
    this._capture,
    this._name,
  );

  List<int> _newList(int size) {
    if (_length <= 8) return Uint8List(size);
    if (_length <= 16) return Uint16List(size);
    // It's not possible for the size to be >= 32 at this point.
    return Uint32List(size);
  }

  @override
  bool operator ==(Object o) {
    if (o is _InterpretedBitPattern) {
      return _length == o._length &&
          _nonVarMask == o._nonVarMask &&
          _isSetMask == o._isSetMask &&
          _listEquals(_capture, o._capture) &&
          _name == o._name;
    }
    return false;
  }

  @override
  int get hashCode =>
      _length.hashCode ^
      _nonVarBits.hashCode ^
      _isSetMask.hashCode ^
      _nonVarMask.hashCode ^
      (_capture.isEmpty
          ? 0
          : _capture.map((c) => c.hashCode).reduce((a, b) => a ^ b));

  @override
  int compareTo(covariant _InterpretedBitPattern other) {
    return other._nonVarBits.compareTo(_nonVarBits);
  }

  @override
  List<String?> get names => _capture.map((b) => b.name).toList();

  @override
  List<int>? capture(int input) {
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
    if (assertionsEnabled) {
      return (StringBuffer()
            ..writeln('InterpretedBitPattern: $_length-bits {')
            ..writeln('  name:       ${_name ?? '<Unnamed>'}')
            ..writeln('  capture:    ${_capture.join(', ')}')
            ..writeln('  isSetMask:  ${_isSetMask.toBinaryPadded(_length)}')
            ..writeln('  nonVarMask: ${_nonVarMask.toBinaryPadded(_length)}')
            ..writeln('}'))
          .toString();
    } else {
      return super.toString();
    }
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
///   final group = BitPatternGroup.from(patterns);
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

  /// Creates a [BitPatternGroup] `<T, V>` from the provided [patterns].
  ///
  /// ```
  /// final group = BitPatternGroup([pattern1, pattern2]);
  /// ```
  factory BitPatternGroup(List<BitPattern<T>> patterns) {
    ArgumentError.checkNotNull(patterns, 'patterns');
    if (patterns.isEmpty) {
      throw ArgumentError.value(
        patterns,
        'patterns',
        'Cannot be an empty list',
      );
    }
    return BitPatternGroup._(patterns.toList()..sort());
  }

  const BitPatternGroup._(this._sortedPatterns);

  /// Returns which [BitPattern] is capable of decoding the provided [bits].
  ///
  /// Returns `null` if no match found.
  BitPattern<T>? match(int bits) {
    for (final pattern in _sortedPatterns) {
      if (pattern.matches(bits)) {
        return pattern;
      }
    }

    return null;
  }

  @override
  String toString() {
    if (assertionsEnabled) {
      return 'BitPatternGroup { $_sortedPatterns }';
    } else {
      return super.toString();
    }
  }
}
