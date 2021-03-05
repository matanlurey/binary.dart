import 'package:binary/binary.dart';
import 'package:test/test.dart';

/// Tests the [Integral] implementations.
void main() {
  // This test does not make sense now that the null-safety is activated

  // test('should, in debug mode, refuse null values', () {
  //   var enabled = false;
  //   assert(enabled = true);
  //   if (enabled) {
  //     expect(
  //       () => Int4(null),
  //       throwsA(
  //         anyOf(
  //           // VM.
  //           TypeMatcher<AssertionError>(),

  //           // Dart2JS.
  //           TypeMatcher<NoSuchMethodError>(),
  //         ),
  //       ),
  //     );
  //   }
  // });

  // It would be a lot of work to test every variant, so instead we test one
  // variant of both signed and unsigned (Int4, Uint4), and then just assert
  // that the rest of the variants are configured properly.
  group('Int4', () {
    test('should be comparable', () {
      expect(
        [
          Int4(3),
          Int4(1),
          Int4(2),
        ]..sort(),
        [
          Int4(1),
          Int4(2),
          Int4(3),
        ],
      );
    });

    test('should be hashable', () {
      expect({Int4(1): 1, Int4(1): 1}, hasLength(1));
    });

    group('Bitwise operators', () {
      test('&', () {
        expect(Int4(1) & Int4(2), Int4(1 & 2));
      });

      test('|', () {
        expect(Int4(1) | Int4(2), Int4(1 | 2));
      });

      test('^', () {
        expect(Int4(1) ^ Int4(2), Int4(1 ^ 2));
      });

      test('~', () {
        expect((~Int4('0101'.bits)).toBinaryPadded(), '1010');
      });

      test('<<', () {
        expect(Int4(1) << Int4(2), Int4(1 << 2));
      });

      test('>>', () {
        expect(Int4(1) >> Int4(2), Int4(1 >> 2));
      });

      test('>', () {
        expect(Int4(2) > Int4(1), isTrue);
        expect(Int4(1) > Int4(2), isFalse);
        expect(Int4(2) > Int4(2), isFalse);
      });

      test('>=', () {
        expect(Int4(2) >= Int4(1), isTrue);
        expect(Int4(1) >= Int4(2), isFalse);
        expect(Int4(2) >= Int4(2), isTrue);
      });

      test('<', () {
        expect(Int4(2) < Int4(1), isFalse);
        expect(Int4(1) < Int4(2), isTrue);
        expect(Int4(2) < Int4(2), isFalse);
      });

      test('<=', () {
        expect(Int4(2) <= Int4(1), isFalse);
        expect(Int4(1) <= Int4(2), isTrue);
        expect(Int4(2) <= Int4(2), isTrue);
      });
    });

    group('getBit', () {
      test('should return', () {
        final int = Int4('101'.bits);
        expect(int.getBit(0), 1);
        expect(int.getBit(1), 0);
      });

      test('should enforce range', () {
        expect(() => Int4.zero.getBit(4), throwsRangeError);
      });
    });

    group('setBit', () {
      test('should return', () {
        final int = Int4('101'.bits);
        expect(int.setBit(0), Int4('101'.bits));
        expect(int.setBit(1), Int4('111'.bits));
      });

      test('should enforce range', () {
        expect(() => Int4.zero.setBit(4), throwsRangeError);
      });
    });

    test('toggleBit should return', () {
      final int = Int4('101'.bits);
      expect(int.toggleBit(0), Int4('100'.bits));
      expect(int.toggleBit(1), Int4('111'.bits));
      expect(int.toggleBit(2, true), int);
    });

    group('isSet', () {
      test('should return', () {
        final int = Int4('101'.bits);
        expect(int.isSet(0), isTrue);
        expect(int.isSet(1), isFalse);
      });

      test('should enforce range', () {
        expect(() => Int4.zero.isSet(4), throwsRangeError);
      });
    });

    group('clearBit', () {
      test('should return', () {
        final int = Int4('101'.bits);
        expect(int.clearBit(0), Int4('100'.bits));
        expect(int.clearBit(1), Int4('101'.bits));
      });

      test('should enforce range', () {
        expect(() => Int4.zero.clearBit(4), throwsRangeError);
      });
    });

    group('isClear', () {
      test('should return', () {
        final int = Int4('101'.bits);
        expect(int.isClear(0), isFalse);
        expect(int.isClear(1), isTrue);
      });

      test('should enforce range', () {
        expect(() => Int4.zero.isClear(4), throwsRangeError);
      });
    });

    group('bitChunk/bitRange', () {
      test('should return', () {
        final int = Int4('101'.bits);
        expect(int.bitChunk(2, 2), Int4('10'.bits));
        expect(int.bitRange(2, 1), Int4('10'.bits));
      });

      test('should enforce range', () {
        expect(() => Int4.zero.bitChunk(4, 4), throwsRangeError);
        expect(() => Int4.zero.bitRange(4, 1), throwsRangeError);
      });
    });

    test('replaceBitRange', () {
      expect(
        //2-0
        Uint4('1010'.bits).replaceBitRange(2, 0, '111'.bits).toBinary(),
        '1111',
      );
    });

    test('shiftRight should infer size', () {
      expect(
        Uint8('0111' '1111'.bits).signedRightShift(5),
        Uint8('0000' '0011'.bits),
      );
    });

    test('rotateRightShift', () {
      expect(
        Uint8('0110' '0000'.bits).rotateRightShift(1),
        Uint8('0011' '0000'.bits),
      );
    });

    test('bitsSet should infer size', () {
      expect(Uint8('0110' '0000'.bits).bitsSet, 2);
    });

    test('msb should infer size', () {
      expect(Uint8('0110' '0000'.bits).msb, isFalse);
      expect(Uint8('1010' '0000'.bits).msb, isTrue);
    });

    test('toBinary should return as a binary string', () {
      expect(Uint8('0110' '0000'.bits).toBinary(), '110' '0000');
    });

    test('toBinaryPadded should infer size', () {
      expect(Uint8('0110' '0000'.bits).toBinaryPadded(), '0110' '0000');
    });
  });

  group('Uint4.signExtend', () {
    test('MSB = 0', () {
      final int = Uint4('0101'.bits);
      expect(int.signExtend(1), Uint4('0001'.bits));
    });

    test('MSB = 1', () {
      final int = Uint4('0010'.bits);
      expect(int.signExtend(1), Uint4('1110'.bits));
    });
  });

  test('Uint4 with ~ should work as expected', () {
    expect((~Uint4('0101'.bits)).toBinaryPadded(), '1010');
  });

  group('Sign Checks [isPositive/isNegative]', () {
    test('is always positive if unsigned', () {
      expect(Uint4('1010'.bits).isPositive, isTrue);
      expect(Uint4('1010'.bits).isNegative, isFalse);
    });

    test('is negative if the left-most bit is 1', () {
      expect(Int4(-1).isNegative, isTrue);
      expect(Int4('-101'.bits).isNegative, isTrue);
    });
  });

  group('Other', () {
    test('Bit should be setup correctly', () {
      expect(Bit.zero.value, 0);
      expect(Bit.one.value, 1);
      expect(Bit.one.size, 1);
      expect(
        () => Bit('1'.padRight(1 + 1, '0').bits),
        throwsRangeError,
      );
    });

    test('Int4 should be setup correctly', () {
      expect(Int4.zero.value, 0);
      expect(Int4.zero.size, 4);
      expect(
        () => Int4('1'.padRight(4 + 1, '0').bits),
        throwsRangeError,
      );
    });

    test('Uint4 should be setup correctly', () {
      expect(Uint4.zero.value, 0);
      expect(Uint4.zero.size, 4);
      expect(
        () => Uint4('1'.padRight(4 + 1, '0').bits),
        throwsRangeError,
      );
    });

    test('Int8 should be setup correctly', () {
      expect(Int8.zero.value, 0);
      expect(Int8.zero.size, 8);
      expect(
        () => Int8('1'.padRight(8 + 1, '0').bits),
        throwsRangeError,
      );
    });

    test('Uint8 should be setup correctly', () {
      expect(Uint8.zero.value, 0);
      expect(Uint8.zero.size, 8);
      expect(
        () => Uint8('1'.padRight(8 + 1, '0').bits),
        throwsRangeError,
      );
    });

    test('Int16 should be setup correctly', () {
      expect(Int16.zero.value, 0);
      expect(Int16.zero.size, 16);
      expect(
        () => Int16('1'.padRight(16 + 1, '0').bits),
        throwsRangeError,
      );
    });

    test('Uint16 should be setup correctly', () {
      expect(Uint16.zero.value, 0);
      expect(Uint16.zero.size, 16);
      expect(
        () => Uint16('1'.padRight(16 + 1, '0').bits),
        throwsRangeError,
      );
    });

    test('Int32 should be setup correctly', () {
      expect(Int32.zero.value, 0);
      expect(Int32.zero.size, 32);
      expect(
        () => Int32('1'.padRight(32 + 1, '0').bits),
        throwsRangeError,
      );
    });

    test('Uint32 should be setup correctly', () {
      expect(Uint32.zero.value, 0);
      expect(Uint32.zero.size, 32);
      expect(
        () => Uint32('1'.padRight(32 + 1, '0').bits),
        throwsRangeError,
      );
    });
  });

  test('<toDebugString>', () {
    var enabled = false;
    assert(enabled = true);
    [
      Bit.zero,
      Uint4.zero,
      Int4.zero,
      Uint8.zero,
      Int8.zero,
      Uint16.zero,
      Int16.zero,
      Uint32.zero,
      Int32.zero,
    ].forEach((i) {
      if (enabled) {
        expect(Bit.zero.toString(), endsWith('{0}'));
      } else {
        expect(Bit.zero.toString(), isNot(endsWith('{0}')));
      }
    });
  });

  test('<wrappedOperators>', () {
    <Integral>[
      Bit.zero,
      Uint4.zero,
      Int4.zero,
      Uint8.zero,
      Int8.zero,
      Uint16.zero,
      Int16.zero,
      Uint32.zero,
      Int32.zero,
    ].forEach((i) {
      expect(i | i, i);
    });
  });

  test('<checkRange>', () {
    [
      Bit.checkRange,
      Uint4.checkRange,
      Int4.checkRange,
      Uint8.checkRange,
      Int8.checkRange,
      Uint16.checkRange,
      Int16.checkRange,
      Uint32.checkRange,
      Int32.checkRange,
    ].forEach((c) {
      expect(c(0), 0);
    });
  });

  test('<assertRange>', () {
    [
      Bit.assertRange,
      Uint4.assertRange,
      Int4.assertRange,
      Uint8.assertRange,
      Int8.assertRange,
      Uint16.assertRange,
      Int16.assertRange,
      Uint32.assertRange,
      Int32.assertRange,
    ].forEach((c) {
      expect(c(0), 0);
    });
  });
}
