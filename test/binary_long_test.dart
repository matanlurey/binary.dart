import 'package:binary/binary.dart' show BinaryInt, BinaryString;
import 'package:test/test.dart';

/// Indirectly tests the `BinaryLong` implementation via `BinaryInt`.
void main() {
  /// The largest possible unsigned 32-bit integer.
  ///
  /// In both VMs: `1111_1111_1111_1111_1111_1111_1111_1111`
  const maxUint32 = 0xffffffff;

  /// The smallest possible unsigned integer that is bigger than 32-bits.
  ///
  /// In both VMs: `01_1111_1111_1111_1111_1111_1111_1111_1110`
  const minUint33 = maxUint32 + 1;

  /// The sum of [maxUint32] + [maxUint32], including overflow behavior.
  ///
  /// In JS VMs: This is `0x1fffffffe`.
  const maxUint32x2 = maxUint32 + maxUint32;

  /// A 34-bit unsigned integer that starts with `1` and `0` in bits 33 and 32.
  ///
  /// In both VMs: `10_1111_1111_1111_1111_1111_1111_1111_1110`
  const b10Uint34 = 0x2fffffffe;

  /// The largest possbile unsigned integer that is valid in JavaScript.
  const maxJsUint = 0x1fffffffffffff;

  const msbLo = 31;
  const lsbHi = 32;
  const msbHi = 52;

  group('hiLo should return split bits of', () {
    test('maxUint32 [0xffffffff]', () {
      expect(maxUint32.hiLo(), [0, maxUint32]);
    });

    test('minUint33 [0x80000000]', () {
      expect(minUint33.hiLo(), [1, 0]);
    });

    test('maxUint32x2 [0x1fffffffe]', () {
      expect(maxUint32x2.hiLo(), [1, 0xfffffffe]);
    });

    test('b10Uint34 [0x2fffffffe]', () {
      expect(b10Uint34.hiLo(), [2, 0xfffffffe]);
    });

    test('maxJsUint [0x1fffffffffffff]', () {
      expect(maxJsUint.hiLo(), [0x1fffff, maxUint32]);
    });
  });

  group('getBit', () {
    test('should get the MSLo and MsHi of maxUint32', () {
      // 1111_1111_1111_1111_1111_1111_1111_1111
      expect(maxUint32.getBit(msbLo), 1);
      expect(maxUint32.getBit(lsbHi), 0);
      expect(maxUint32.getBit(msbHi), 0);
    });

    test('should get the MSLo and MsHi of minUint33', () {
      // lsbHi
      // v
      // 1_0000_0000_0000_0000_0000_0000_0000_0000
      //   ^
      //   msbLo
      expect(minUint33.getBit(msbLo), 0);
      expect(minUint33.getBit(lsbHi), 1);
      expect(minUint33.getBit(msbHi), 0);
    });

    test('should get the MSLo and MsHi of maxUint32x2', () {
      // 1_1111_1111_1111_1111_1111_1111_1111_1110
      expect(maxUint32x2.getBit(msbLo), 1);
      expect(maxUint32x2.getBit(lsbHi), 1);
      expect(maxUint32x2.getBit(msbHi), 0);
    });

    test('should get the MSLo and MsHi of b10Uint34', () {
      // 10_1111_1111_1111_1111_1111_1111_1111_1110
      expect(b10Uint34.getBit(msbLo), 1);
      expect(b10Uint34.getBit(lsbHi), 0);
      expect(b10Uint34.getBit(lsbHi + 1), 1);
      expect(b10Uint34.getBit(msbHi), 0);
    });

    test('should get the MSLo and MsHi of maxJsUint', () {
      // 1_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111
      expect(maxJsUint.getBit(msbLo), 1);
      expect(maxJsUint.getBit(lsbHi), 1);
      expect(maxJsUint.getBit(msbHi), 1);
    });
  });

  group('setBit', () {
    test('should set the MSLo and MsHi of maxUint32', () {
      // 1111_1111_1111_1111_1111_1111_1111_1111
      // ^
      // msbLo
      expect(maxUint32.setBit(msbLo), maxUint32);
      expect(maxUint32.setBit(lsbHi), 0x1ffffffff);
      expect(maxUint32.setBit(msbHi), 0x100000ffffffff);
    });

    test('should set the MSLo and MsHi of minUint33', () {
      // lsbHi
      // v
      // 1_0000_0000_0000_0000_0000_0000_0000_0000
      //   ^
      //   msbLo
      expect(minUint33.setBit(msbLo), 0x180000000);
      expect(minUint33.setBit(lsbHi), minUint33);
      expect(minUint33.setBit(msbHi), 0x10000100000000);
    });

    test('should set the MSLo and MsHi of maxUint32x2', () {
      // lsbHi
      // v
      // 1_1111_1111_1111_1111_1111_1111_1111_1110
      //   ^
      //   msbLo
      expect(maxUint32x2.setBit(msbLo), maxUint32x2);
      expect(maxUint32x2.setBit(lsbHi), maxUint32x2);
      expect(maxUint32x2.setBit(msbHi), 0x100001fffffffe);
    });

    test('should set the MSLo and MsHi of b10Uint34', () {
      //  lsbHi
      //  v
      // 10_1111_1111_1111_1111_1111_1111_1111_1110
      //    ^
      //    msbLo
      expect(b10Uint34.setBit(msbLo), b10Uint34);
      expect(b10Uint34.setBit(lsbHi), 0x3fffffffe);
      expect(b10Uint34.setBit(lsbHi + 1), b10Uint34);
      expect(b10Uint34.setBit(msbHi), 0x100002fffffffe);
    });

    test('should set the MSLo and MsHi of maxJsUint', () {
      // msbHi                    lsbHi
      // v                        v
      // 1_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111
      //                            ^
      //                            msbLo
      expect(maxJsUint.setBit(msbLo), maxJsUint);
      expect(maxJsUint.setBit(lsbHi), maxJsUint);
      expect(maxJsUint.setBit(msbHi), maxJsUint);
    });
  });

  group('clearBit', () {
    test('should clear the MSLo and MsHi of maxUint32', () {
      // 1111_1111_1111_1111_1111_1111_1111_1111
      // ^
      // msbLo
      expect(maxUint32.clearBit(msbLo), 0x7fffffff);
      expect(maxUint32.clearBit(lsbHi), maxUint32);
      expect(maxUint32.clearBit(msbHi), maxUint32);
    });

    test('should clear the MSLo and MsHi of minUint33', () {
      // lsbHi
      // v
      // 1_0000_0000_0000_0000_0000_0000_0000_0000
      //   ^
      //   msbLo
      expect(minUint33.clearBit(msbLo), minUint33);
      // 0_1000_0000_0000_0000_0000_0000_0000_0000
      //   ^
      //   nMask
      expect(minUint33.clearBit(lsbHi), 0);
      expect(minUint33.clearBit(msbHi), minUint33);
    });

    test('should clear the MSLo and MsHi of maxUint32x2', () {
      // lsbHi
      // v
      // 1_1111_1111_1111_1111_1111_1111_1111_1110
      //   ^
      //   msbLo
      // 0_1000_0000_0000_0000_0000_0000_0000_0000
      //   ^
      //   nMask
      expect(maxUint32x2.clearBit(msbLo), 0x17ffffffe);
      // 1_0000_0000_0000_0000_0000_0000_0000_0000
      // ^
      // nMask
      expect(maxUint32x2.clearBit(lsbHi), maxUint32 - 1);
      expect(maxUint32x2.clearBit(msbHi), maxUint32x2);
    });

    test('should clear the MSLo and MsHi of b10Uint34', () {
      //  lsbHi
      //  v
      // 10_1111_1111_1111_1111_1111_1111_1111_1110
      //    ^
      //    msbLo
      expect(b10Uint34.clearBit(msbLo), 0x27ffffffe);
      expect(b10Uint34.clearBit(lsbHi), b10Uint34);
      expect(b10Uint34.clearBit(lsbHi + 1), maxUint32 - 1);
      expect(b10Uint34.clearBit(msbHi), b10Uint34);
    });

    test('should clear the MSLo and MsHi of maxJsUint', () {
      // msbHi                    lsbHi
      // v                        v
      // 1_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111
      //                            ^
      //                            msbLo
      expect(maxJsUint.clearBit(msbLo), 0x1fffff7fffffff);
      expect(maxJsUint.clearBit(lsbHi), 0x1ffffeffffffff);
      expect(maxJsUint.clearBit(msbHi), 0xfffffffffffff);
    });
  });

  group('bitChunk', () {
    test('should read ranges in maxUint32', () {
      // 1111_1111_1111_1111_1111_1111_1111_1111
      // ^
      // msbLo
      expect(maxUint32.bitChunk(msbLo, 4), '1111'.bits);
      expect(maxUint32.bitChunk(lsbHi, 2), '01'.bits);
      expect(maxUint32.bitChunk(msbHi, 22), '1'.bits);
    });

    test('should read ranges in minUint33', () {
      // lsbHi
      // v
      // 1_0000_0000_0000_0000_0000_0000_0000_0000
      //   ^
      //   msbLo
      expect(minUint33.bitChunk(msbLo, 4), 0);
      expect(minUint33.bitChunk(lsbHi, 2), '10'.bits);
      expect(minUint33.bitChunk(msbHi, 22), '10'.bits);
    });

    test('should read ranges in maxUint32x2', () {
      // lsbHi
      // v
      // 1_1111_1111_1111_1111_1111_1111_1111_1110
      //   ^
      //   msbLo
      expect(maxUint32x2.bitChunk(msbLo, 4), '1111'.bits);
      expect(maxUint32x2.bitChunk(lsbHi, 5), '11111'.bits);
      expect(maxUint32x2.bitChunk(msbHi, 40), 0xfffff);
    });

    test('should read ranges in b10Uint34', () {
      //  lsbHi
      //  v
      // 10_1111_1111_1111_1111_1111_1111_1111_1110
      //    ^
      //    msbLo
      expect(b10Uint34.bitChunk(msbLo, 4), '1111'.bits);
      expect(b10Uint34.bitChunk(lsbHi, 5), '1111'.bits);
      expect(b10Uint34.bitChunk(msbHi, 40), 0x17ffff);
    });

    test('should read ranges in maxJsUint', () {
      // msbHi                    lsbHi
      // v                        v
      // 1_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111
      //                            ^
      //                            msbLo
      expect(maxJsUint.bitChunk(msbLo, 4), '1111'.bits);
      expect(maxJsUint.bitChunk(lsbHi, 5), '11111'.bits);
      expect(maxJsUint.bitChunk(msbHi, 50), 0x3ffffffffffff);
    });
  });
}
