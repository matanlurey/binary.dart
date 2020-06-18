import 'package:binary/binary.dart';
import 'package:test/test.dart';

/// Tests the [Integral] implementations.
void main() {
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

    test('should return signed/unsigned', () {
      expect(Int4.zero.signed, isTrue);
      expect(Int4.zero.unsigned, isFalse);
    });

    group('getBit', () {
      test('should return', () {
        final int = Int4('101'.parseBits());
        expect(int.getBit(0), 1);
        expect(int.getBit(1), 0);
      });

      test('should enforce range', () {
        expect(() => Int4.zero.getBit(4), throwsRangeError);
      });
    });

    group('setBit', () {
      test('should return', () {
        final int = Int4('101'.parseBits());
        expect(int.setBit(0), Int4('101'.parseBits()));
        expect(int.setBit(1), Int4('111'.parseBits()));
      });

      test('should enforce range', () {
        expect(() => Int4.zero.setBit(4), throwsRangeError);
      });
    });

    group('isSet', () {
      test('should return', () {
        final int = Int4('101'.parseBits());
        expect(int.isSet(0), isTrue);
        expect(int.isSet(1), isFalse);
      });

      test('should enforce range', () {
        expect(() => Int4.zero.isSet(4), throwsRangeError);
      });
    });
    group('isClear', () {
      test('should return', () {
        final int = Int4('101'.parseBits());
        expect(int.isClear(0), isFalse);
        expect(int.isClear(1), isTrue);
      });

      test('should enforce range', () {
        expect(() => Int4.zero.isClear(4), throwsRangeError);
      });
    });

    group('bitChunk/bitRange', () {
      test('should return', () {
        final int = Int4('101'.parseBits());
        expect(int.bitChunk(2, 2), Int4('10'.parseBits()));
        expect(int.bitRange(2, 1), Int4('10'.parseBits()));
      });

      test('should enforce range', () {
        expect(() => Int4.zero.bitChunk(4, 4), throwsRangeError);
        expect(() => Int4.zero.bitRange(4, 1), throwsRangeError);
      });
    });

    test('shiftRight should infer size', () {
      expect(
        Uint8('0111' '1111'.parseBits()).shiftRight(5),
        Uint8('0000' '0011'.parseBits()),
      );
    });

    test('signExtend should work similar to int.rotateRight', () {
      expect(
        Uint8('0110' '0000'.parseBits()).rotateRight(1),
        Uint8('0011' '0000'.parseBits()),
      );
    });

    test('setBits should infer size', () {
      expect(Uint8('0110' '0000'.parseBits()).setBits, 2);
    });

    test('msb should infer size', () {
      expect(Uint8('0110' '0000'.parseBits()).msb, isFalse);
      expect(Uint8('1010' '0000'.parseBits()).msb, isTrue);
    });

    test('toBinary should return as a binary string', () {
      expect(Uint8('0110' '0000'.parseBits()).toBinary(), '110' '0000');
    });

    test('toBinaryPadded should infer size', () {
      expect(Uint8('0110' '0000'.parseBits()).toBinaryPadded(), '0110' '0000');
    });
  });

  group('Sign Checks [isPositive/isNegative]', () {
    test('is always positive if unsigned', () {
      expect(Uint4('1010'.parseBits()).isPositive, isTrue);
      expect(Uint4('1010'.parseBits()).isNegative, isFalse);
    });

    test('is negative if the left-most bit is 1', () {
      expect(Int4(-1).isNegative, isTrue);
      expect(Int4('-101'.parseBits()).isNegative, isTrue);
    });
  });

  group('Other', () {
    test('Bit should be setup correctly', () {
      expect(Bit.zero.value, 0);
      expect(Bit.one.value, 1);
      expect(Bit.one.signed, isFalse);
      expect(Bit.one.size, 1);
      expect(
        () => Bit('1'.padRight(1 + 1, '0').parseBits()),
        throwsRangeError,
      );
    });

    test('Int4 should be setup correctly', () {
      expect(Int4.zero.value, 0);
      expect(Int4.zero.signed, isTrue);
      expect(Int4.zero.size, 4);
      expect(
        () => Int4('1'.padRight(4 + 1, '0').parseBits()),
        throwsRangeError,
      );
    });

    test('Uint4 should be setup correctly', () {
      expect(Uint4.zero.value, 0);
      expect(Uint4.zero.signed, isFalse);
      expect(Uint4.zero.size, 4);
      expect(
        () => Uint4('1'.padRight(4 + 1, '0').parseBits()),
        throwsRangeError,
      );
    });

    test('Int8 should be setup correctly', () {
      expect(Int8.zero.value, 0);
      expect(Int8.zero.signed, isTrue);
      expect(Int8.zero.size, 8);
      expect(
        () => Int8('1'.padRight(8 + 1, '0').parseBits()),
        throwsRangeError,
      );
    });

    test('Uint8 should be setup correctly', () {
      expect(Uint8.zero.value, 0);
      expect(Uint8.zero.signed, isFalse);
      expect(Uint8.zero.size, 8);
      expect(
        () => Uint8('1'.padRight(8 + 1, '0').parseBits()),
        throwsRangeError,
      );
    });

    test('Int16 should be setup correctly', () {
      expect(Int16.zero.value, 0);
      expect(Int16.zero.signed, isTrue);
      expect(Int16.zero.size, 16);
      expect(
        () => Int16('1'.padRight(16 + 1, '0').parseBits()),
        throwsRangeError,
      );
    });

    test('Uint16 should be setup correctly', () {
      expect(Uint16.zero.value, 0);
      expect(Uint16.zero.signed, isFalse);
      expect(Uint16.zero.size, 16);
      expect(
        () => Uint16('1'.padRight(16 + 1, '0').parseBits()),
        throwsRangeError,
      );
    });

    test('Int32 should be setup correctly', () {
      expect(Int32.zero.value, 0);
      expect(Int32.zero.signed, isTrue);
      expect(Int32.zero.size, 32);
      expect(
        () => Int32('1'.padRight(32 + 1, '0').parseBits()),
        throwsRangeError,
      );
    });

    test('Uint32 should be setup correctly', () {
      expect(Uint32.zero.value, 0);
      expect(Uint32.zero.signed, isFalse);
      expect(Uint32.zero.size, 32);
      expect(
        () => Uint32('1'.padRight(32 + 1, '0').parseBits()),
        throwsRangeError,
      );
    });
  });
}
