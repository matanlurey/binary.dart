import 'dart:math' as math;

import '_long.dart';
import '_utils.dart';
import 'boxed_int.dart';

/// A collection of unchecked binary methods to be applied to an [int].
///
/// > NOTE: There is limited range checking in this function. To verify
/// > accessing a valid bit use one of the [Integral.getBit] implementations,
/// > which knows both the minimum and maximum number of bits.
///
/// For example:
/// ```
/// // Unchecked. We assume 'bits' is meant to represent at least 7 bits.
/// void example1(int bits) {
///   print(bits.getBit(7));
/// }
///
/// // Checked. Will throw a RangeError because Int4 cannot have 7 bits.
/// void example2(Int4 bits) {
///   print(bits.getBit(7));
/// }
/// ```
extension BinaryInt on int {
  static const _usingJSNum = identical(1, 1.0);
  static const _maxSmiBits = 31;

  /// Returns boxed as a [Bit] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  @Deprecated('Use Bit(int) instead')
  Bit asBit() => Bit(this);

  /// Returns boxed as an [Int4] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  @Deprecated('Use Int4(int) instead')
  Int4 asInt4() => Int4(this);

  /// Returns boxed as an [Uint4] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  @Deprecated('Use Uint4(int) instead')
  Uint4 asUint4() => Uint4(this);

  /// Returns boxed as an [Int8] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  @Deprecated('Use Int8(int) instead')
  Int8 asInt8() => Int8(this);

  /// Returns boxed as an [Uint8] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  @Deprecated('Use Uint8(int) instead')
  Uint8 asUint8() => Uint8(this);

  /// Returns boxed as an [Int16] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  @Deprecated('Use Int16(int) instead')
  Int16 asInt16() => Int16(this);

  /// Returns boxed as an [Uint16] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  @Deprecated('Use Uint16(int) instead')
  Uint16 asUint16() => Uint16(this);

  /// Returns boxed as an [Int32] instance.
  ///
  /// This is a Int32 and should be avoided for perf-sensitive code.
  @Deprecated('Use Int8(int) instead')
  Int32 asInt32() => Int32(this);

  /// Returns boxed as an [Uint32] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  @Deprecated('Use Uint32(int) instead')
  Uint32 asUint32() => Uint32(this);

  /// Returns [this] to the power of the provided [expontent].
  ///
  /// Unlike [math.pow], this is statically guaranteed to be the result of two
  /// [int]s, so we know the result is also an [int], and a cast is not needed.
  int pow(int expontent) => math.pow(this, expontent).unsafeCast();

  /// Returns [this] arithetically right-shifted by [n] bytes assuming [length].
  ///
  /// This is intended to be roughly equivalent to JavaScript's `>>` operator.
  ///
  /// > NOTE: [bitWidth] is _not_ validated. See [Integral.signedRightShift].
  @Deprecated('Use signedRightShift')
  int shiftRight(int n, int bitWidth) => signedRightShift(n, bitWidth);

  /// Returns [this] arithetically right-shifted by [n] bytes assuming [length].
  ///
  /// This is intended to be roughly equivalent to JavaScript's `>>` operator.
  ///
  /// > NOTE: [bitWidth] is _not_ validated. See [Integral.signedRightShift].
  int signedRightShift(int n, int bitWidth) {
    final padding = msb(bitWidth) ? 2.pow(n) - 1 : 0;
    return (padding << (bitWidth - n)) | (this >> n);
  }

  /// Returns [this] sign-extended to [endSize] bits.
  ///
  /// Sign extension is the operation of increasing the number of bits of a
  /// binary number while preserving the number's sign. This is done by
  /// appending digits to the most significant side of the number, i.e. if 6
  /// bits are used to represent the value `00 1010` (decimal +10) and the sign
  /// extend operation increases the word length to 16 bits, the new
  /// representation is `0b0000 0000 0000 1010`.
  ///
  /// Simiarily, the 10 bit value `11 1111 0001` can be sign extended to 16-bits
  /// as `1111 1111 1111 0001`. This method is provided as a convenience when
  /// converting between ints of smaller sizes to larger sizes.
  int signExtend(int startSize, int endSize) {
    if (endSize <= startSize) {
      throw RangeError.value(
        endSize,
        'endSize',
        'Expected endSize ($endSize) <= startSize ($startSize).',
      );
    }
    final extendBit = getBit(startSize - 1);
    if (extendBit == 1) {
      final highBits = 2.pow(endSize - startSize) - 1;
      return (highBits << startSize) | this;
    } else {
      return this;
    }
  }

  /// Returns a bit-wise right-rotation on [this] by an [amount] of bits.
  ///
  /// > NOTE: [length] is _not_ validated. See [Integral.signedRightShift].
  @Deprecated('This implementation is incorrect. Use rotateRightShift instead')
  int rotateRight(int amount) {
    var bits = this;
    for (var i = 0; i < amount; i++) {
      bits = bits >> 1 | bits & 0x01 << 31;
    }
    return bits;
  }

  static int _maskedRotation(int rotation, int bitWidth) {
    return rotation & (bitWidth - 1);
  }

  /// Returns a bit-wise right-rotation on [this] by an [r] of bits.
  ///
  /// > NOTE: [bitWidth] is _not_ validated. See [Integral.rotateRightShift].
  int rotateRightShift(int r, int bitWidth) {
    final value = this;
    final bitMask = 2.pow(bitWidth) - 1;
    final rotation = _maskedRotation(r, bitWidth);
    final left = value >> rotation;
    final right = (value << (bitWidth - rotation)) & bitMask;
    return left | right;
  }

  /// Returns the number of set bits in [this], assuming a [length]-bit [this].
  ///
  /// > NOTE: [bitWidth] is _not_ validated. See [Integral.bitsSet].
  int countSetBits(int bitWidth) {
    var count = 0;
    for (var i = 0; i < bitWidth; i++) {
      if (this & (1 << i) != 0) {
        count++;
      }
    }
    return count;
  }

  /// Returns whether the most-significant-bit in [this] (of [length]) is set.
  ///
  /// > NOTE: [bitWidth] is _not_ validated. See [Integral.msb].
  bool msb(int bitWidth) {
    return isSet(bitWidth - 1);
  }

  /// Throws [RangeError] if [n] is not at least `0`.
  void _mustBeAtLeast0(int n) {
    RangeError.checkNotNegative(n);
  }

  int _getBit(int n) {
    if (_usingJSNum && n > _maxSmiBits) {
      return getBitLong(n);
    } else {
      return this >> n & 1;
    }
  }

  /// Returns `1` if [n]th is bit set, else `0`.
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  int getBit(int n) {
    _mustBeAtLeast0(n);
    return _getBit(n);
  }

  int _setBit(int n) {
    if (_usingJSNum && n > _maxSmiBits - 1) {
      return setBitLong(n);
    } else {
      return this | (1 << n);
    }
  }

  /// Returns a new [int] with the [n]th bit set.
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  int setBit(int n) {
    _mustBeAtLeast0(n);
    return _setBit(n);
  }

  int _clearBit(int n) {
    if (_usingJSNum && n > _maxSmiBits - 1) {
      return clearBitLong(n);
    } else {
      return this & ~(1 << n);
    }
  }

  /// Returns a new [int] with the [n]th bit cleared.
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  int clearBit(int n) {
    _mustBeAtLeast0(n);
    return _clearBit(n);
  }

  /// Returns a new [int] with the [n]th bit toggled.
  ///
  /// If [v] is provided, it is used as the new value. Otherwise the opposite
  /// value (of the current value) is used - i.e. `1` becomes `0` and `0`
  /// becomes `1` (logical not).
  int toggleBit(int n, [bool v]) {
    v ??= !isSet(n);
    return v ? setBit(n) : clearBit(n);
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
    if (left < 0) {
      throw RangeError.value(left, 'left', 'Out of range. Must be > 0.');
    } else if (size < 1) {
      throw RangeError.value(size, 'size', 'Out of range. Must be >= 1.');
    } else if (left - size < -1) {
      throw RangeError.value(left - size, 'left - size', 'Expected >= -1');
    }
    return (this >> (left + 1 - size)) & ~(~0 << size);
  }

  /// Returns an [int] containining bits _inclusive_ of the last bit.
  ///
  /// The result is left-padded with 0's.
  int bitRange(int left, int right) => bitChunk(left, left - right + 1);

  /// Returns an [int] replacing the bits from [left] to [right] with [bits].
  int replaceBitRange(int left, int right, int bits) {
    final orig = this;
    final mask = ~(~0 << (left - right + 1));
    return (orig & ~mask) | (bits & mask);
  }

  /// Returns [this] as a binary string representation.
  String toBinary() => toRadixString(2);

  /// Returns [this] as a binary string representation, padded with `0`'s.
  String toBinaryPadded(int bitWidth) {
    return toUnsigned(bitWidth).toBinary().padLeft(bitWidth, '0');
  }
}
