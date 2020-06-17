import 'dart:math' as math;

import 'package:meta/meta.dart';

bool get _assertionsEnabled {
  var enabled = false;
  assert(enabled = true);
  return enabled;
}

extension on Object {
  /// Casts the current object to type [T].
  ///
  /// In some production compilers, this cast is skipped.
  T unsafeCast<T>() => this; // ignore: return_of_invalid_type
}

/// A collection of unchecked binary methods to be applied to an [int].
///
/// NOTE: There is no range checking in this function. To verify accessing a
/// valid bit (in _development_ mode) you can use one of the [Integral.get]
/// implementations.
///
/// For example:
/// ```
/// // Unchecked.
/// bits.getBit(1);
///
/// // Checked
/// bits.int8.getBit(1);
/// ```
extension BinaryInt on int {
  /// Returns `1` if [n]th is bit set, else `0`.
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  int getBit(int n) {
    assert(n >= 0);
    return this >> n & 1;
  }

  /// Returns a new [int] with the [n]th bit set.
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  int setBit(int n) {
    assert(n >= 0);
    return this | (1 << n);
  }

  /// Returns a new [int] with the [n]th bit cleared.
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  int clearBit(int n) {
    assert(n >= 0);
    return this & ~(1 << n);
  }

  /// Returns whether bit [n] is set (i.e. `1`).
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  bool isSet(int n) => getBit(n) == 1;

  /// Returns whether bit [n] is cleared (i.e. `0`).
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  bool isClear(int n) => getBit(n) == 0;

  /// Returns an [int] containining bits _exclusive_ of the last bit.
  ///
  /// The result is left-padded with 0's.
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  int bitChunk(int left, int size) {
    assert(() {
      if (left < 0) {
        throw RangeError.value(left, 'left', 'Out of range. Must be > 0.');
      } else if (size < 1) {
        throw RangeError.value(size, 'size', 'Out of range. Must be >= 1.');
      } else {
        return true;
      }
    }());
    return (this >> (left + 1 - size)) & ~(~0 << size);
  }

  /// Returns an [int] containining bits _inclusive_ of the last bit.
  ///
  /// The result is left-padded with 0's.
  int bitRange(int left, int right) => bitChunk(left, left - right + 1);
}

extension ByteList on List<int> {
  /// Converts a list of individual bytes to bits represented as an [int].
  ///
  /// Bytes are represented in order to right-most to left-most.
  int toBits() {
    assert(() {
      if (this == null) {
        throw ArgumentError.notNull('this');
      }
      if (isEmpty) {
        throw ArgumentError.value('Must be non-empty', 'bits');
      }
    }());
    var result = 0;
    for (var n = 0; n < length; n++) {
      if (this[n] == 1) {
        result += math.pow(2, length - n - 1).unsafeCast<int>();
      } else {
        assert(this[n] == 0);
      }
    }
    return result;
  }
}

extension BitString on String {
  /// Parses a binary number made entirely of `0`'s and `1`'s.
  int parseBits() {
    const $0 = 48;
    const $1 = 49;
    return codeUnits
        .map((codeUnit) {
          switch (codeUnit) {
            case $0:
              return 0;
            case $1:
              return 1;
            default:
              final char = String.fromCharCode(codeUnit);
              throw FormatException(
                'Invalid character: $char.',
                this,
                indexOf(char),
              );
          }
        })
        .toList()
        .toBits();
  }
}

/// Encapsulates a common integral data type.
@sealed
class Integral implements Comparable<Integral> {
  /// Numbers of bits in this data type.
  final int length;

  /// Whether this data type supports negative numbers.
  final bool isSigned;

  const Integral._({
    @required this.length,
    @required this.isSigned,
  })  : assert(length != null),
        assert(isSigned != null);

  /// Returns whether [value] falls in the range of representable by this type.
  bool inRange(int value) => value >= min && value <= max;

  /// Minimum value representable by this type.
  int get min {
    if (isSigned) {
      return (-math.pow(2, length - 1)).unsafeCast();
    } else {
      return 0;
    }
  }

  /// Maximum value representable by this type.
  int get max {
    if (isSigned) {
      return (math.pow(2, length - 1) - 1).unsafeCast();
    } else {
      return (math.pow(2, length) - 1).unsafeCast();
    }
  }

  void _assertInRange(int value, [String name]) {
    if (_assertionsEnabled) {
      if (!inRange(value)) {
        throw _rangeError(value, name);
      }
    }
  }

  Error _rangeError(int value, [String name]) {
    return RangeError.range(value, min, max, name);
  }

  /// Where this data type is not signed (0 or positive integers only).
  bool get isUnsigned => !isSigned;

  /// Returns the [n]th from [bits].
  ///
  /// In _development mode_, throws if [bits] or [n] is not [inRange].
  int get(int bits, int n) {
    _assertInRange(bits, 'bits');
    _assertInRange(n, 'n');
  }
}
