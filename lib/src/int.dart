import 'dart:math' as math;
import 'dart:typed_data';

import '_long.dart';
import '_utils.dart';
import 'boxed_int.dart';

/// A collection of unchecked binary methods to be applied to a 32-bit [int].
///
/// There are a small subset of methods that support integers > 32-bits:
///
/// - [msb]
/// - [getBit]
/// - [setBit] and [isSet]
/// - [clearBit] and [iCleared]
/// - [toggleBit]
/// - [countSetBits]
/// - [bitRange] and [bitChunk]
/// - [hiLo]
/// - [toBinary] and [toBinaryPadded]
///
/// Other methods (as documented) have _undefined behavior_ when operating on
/// larger integers. It is instead recommended to
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
///
/// ## Warnings for Dart2JS
///
/// When running compiled to JavaScript, an alternative set of operations are
/// used for integers or operations that exceed 32-bits, which may be noticeably
/// slower. In addition, integers or operations that exceed 52-bits may throw
/// an [UnsupportedError] instead of undefined behavior.
extension BinaryInt on int {
  static const _usingJSNum = identical(1, 1.0);
  static const _maxSmiBits = 31;

  /// Represents `math.pow(2, 32)`, precomputed.
  static const _2p32 = 0x100000000;

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
    if (isClear(startSize)) {
      return this.bitRange(startSize, 0);
    } else {
      final mask = endSize == 32 ? 0xffffffff : (1 << endSize) - 1;
      final bits = this | (mask & ~((1 << startSize) - 1));
      return bits < 0 ? bits + 0x100000000 : bits;
    }
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
  int toggleBit(int n, [bool? v]) {
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
    if (_usingJSNum && left > _maxSmiBits) {
      return bitChunkLong(left, size);
    } else {
      return (this >> (left + 1 - size)) & ~(~0 << size);
    }
  }

  /// Returns an [int] containining bits _inclusive_ of the last bit.
  ///
  /// The result is left-padded with 0's.
  int bitRange(int left, int right) => bitChunk(left, left - right + 1);

  /// Returns an [int] replacing the bits from [left] to [right] with [bits].
  int replaceBitRange(int left, int right, int bits) {
    final size = left - right;
    // Elongate bits so that "1b" becoms "1000b", for example, where L = 4.
    var stretch = left - bits.bitLength;
    if (bits.isSet(size)) {
      stretch++;
    }
    bits = bits << math.max(0, stretch);
    // Create a mask of 1s for the bits to be replaced.
    final mask = (~(~0 << (size + 1))) << right;
    return (this & ~mask) | (bits & mask);
  }

  /// Returns [this] as a binary string representation.
  String toBinary() => toRadixString(2);

  /// Returns [this] as a binary string representation, padded with `0`'s.
  String toBinaryPadded(int bitWidth) {
    return toUnsigned(bitWidth).toBinary().padLeft(bitWidth, '0');
  }

  /// Returns the current [int] split into an array of two elements where:
  ///
  /// - `list[0] = Hi Bits`
  /// - `list[1] = Lo Bits`
  Uint32List hiLo() {
    final hiBits = (this / _2p32).floor() | 0;
    final loBits = (this % _2p32) | 0;
    return Uint32List(2)
      ..[0] = hiBits
      ..[1] = loBits;
  }
}
