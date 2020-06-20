// ignore_for_file: prefer_is_empty

import 'package:meta/meta.dart';

/// Builds a sequence of binary digits.
///
/// The pattern may only contain 0s, 1s, and variable-length dynamic segments.
///
/// ## Usage
/// ```
/// final pattern = BitPattern([
///   BitDynamic(1),
///   BitStatic(0),
///   BitStatic(1),
///   BitStatic(1),
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
      length += part.length;
    }
    return _InterpretedBitPattern(
      length,
      _isSetMask(),
      _nonVarMask(),
      [],
      [],
    );
  }

  /// Returns a "is-set" masking [int] for the current pattern.
  ///
  /// The k'th bit == 1 iff bit k of [this] == 1:
  /// - `{1, 1, 1, 1} == 0xF == 0b1111`
  /// - `{1, 1, V, 1} == 0xD == 0b1101`
  /// - `{0, 0, 0, 0} == 0x0 == 0b0000`
  /// - `{1, 0, 1, V} == 0xA == 0b1010`
  int _isSetMask() {
    return 0;
  }

  int _nonVarMask() {
    return 0;
  }
}

/// Part of a [BitPattern] that will be used to match.
abstract class BitPart {
  /// Length of the part.
  int get length;
}

/// A static part of a [BitPattern], e.g. either `0` or `1`, that _must_ match.
@sealed
class BitStatic implements BitPart {
  final int _bit;

  const BitStatic(this._bit) : assert(_bit == 0 || _bit == 1, 'Invalid: $_bit');

  @override
  bool operator ==(Object o) => o is BitStatic && _bit == o._bit;

  @override
  int get hashCode => _bit.hashCode;

  @override
  int get length => 1;
}

/// A dynamic variable (segment) of a [BitPattern] of [length] bytes.
///
/// Optionally has a [name] (for debug purposes).
@sealed
class BitDynamic implements BitPart {
  final String name;

  const BitDynamic(this.length, [this.name]) : assert(length >= 1);

  @override
  bool operator ==(Object o) => o is BitDynamic && length == o.length;

  @override
  int get hashCode => length.hashCode;

  @override
  final int length;
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
  final int _isSetMask;
  final int _nonVarMask;
  final List<BitStatic> _staticParts;
  final List<BitDynamic> _dynamicParts;

  const _InterpretedBitPattern(
    this._length,
    this._isSetMask,
    this._nonVarMask,
    this._staticParts,
    this._dynamicParts,
  );

  @override
  int compareTo(covariant _InterpretedBitPattern other) {
    if (_listEquals(_dynamicParts, other._dynamicParts)) {
      return 0;
    }
    return _dynamicParts.length > other._dynamicParts.length ? 1 : -1;
  }

  @override
  bool matches(int input) => ~(input ^ _isSetMask) & _nonVarMask == _nonVarMask;
}
