import 'dart:math' show pow;

import 'package:binary/binary.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

void main() {
  test('bitRange', () {
    expect(bitRange(0x01020304, 31, 24), 0x01);
  });

  test('fromBits', () {
    expect(
      fromBits(const [
        1,
        0,
        0,
        0,
        0,
      ]),
      0x10,
    );
  });

  test('fromBits should operate from left to right', () {
    expect(
      uint4.toBinaryPadded(fromBits([1, 0, 0, 0])),
      '1000',
    );
  });

  test('$Integral#toIterable', () {
    expect(
      uint32.toIterable(2),
      [
        0,
        1,
      ]..addAll(new Iterable.generate(30, (_) => 0)),
    );
  });

  group('$Integral#', () {
    test('hasCarryBit if operations produce a carry', () {
      expect(int32.hasCarryBit(int32.max + int32.max), isTrue);
      expect(int32.hasCarryBit(0 + int32.max), isFalse);
      expect(int32.hasCarryBit(1 + int32.max), isTrue);
      expect(int32.hasCarryBit(1 + 2), isFalse);
    });

    test('mask', () {
      int maxTimes16 = int32.max << 4;
      expect(int32.mask(maxTimes16), 0xFFFFFFF0);
    });

    test('doesAddOverflow if two additions produce an overflow', () {
      expect(int32.doesAddOverflow(int32.max, 0, int32.max), isFalse);
      expect(int32.doesAddOverflow(int32.max, 1, int32.max + 1), isTrue);
      expect(int32.doesAddOverflow(-1, 2, -1 + 2), isFalse);
      expect(
          int32.doesAddOverflow(0, 2 * int32.max, 0 + 2 * int32.max), isFalse);
    });

    test('doesSubOverflow if two subtractions produce an overflow', () {
      expect(int32.doesSubOverflow(int32.min, 0, int32.min - 0), isFalse);
      expect(int32.doesSubOverflow(int32.min, 1, int32.min - 1), isTrue);
      expect(int32.doesSubOverflow(1, 2, 1 - 2), isFalse);
      expect(
          int32.doesSubOverflow(0, 2 * int32.max, 0 - 2 * int32.max), isFalse);
    });
  });

  group('bit', () {
    test('should have a length of 1 and be unsigned', () {
      expect(bit.isSigned, isFalse);
      expect(bit.isUnsigned, isTrue);
      expect(bit.length, 1);
    });

    test('should be able to be 0 or 1', () {
      expect(bit.min, 0);
      expect(bit.max, 1);
      expect(bit.inRange(-1), isFalse);
      expect(bit.inRange(0), isTrue);
      expect(bit.inRange(1), isTrue);
      expect(bit.inRange(2), isFalse);
    });
  });

  test('pack should correctly pack a list of bytes', () {
    expect(pack([]), 0);
    expect(pack([0xA]), 0xA);
    expect(pack([0xAB, 0xCD]), 0xABCD);
  });

  group('signExtend', () {
    test('should extend a number with sign-bit 1', () {
      int startBits = 6; // 0b110
      int endBits = 30; // 0b11110
      expect(signExtend(startBits, 3, 5), endBits);
    });
    test('should extend a number with sign-bit 0', () {
      int startBits = 3; // 0b011
      expect(signExtend(startBits, 3, 5), startBits);
    });
  });

  group('rotateRight', () {
    test('should work on a uint8', () {
      expect(
        uint8.toBinaryPadded(
          uint8.rotateRight(uint8.fromBits([0, 1, 1, 0, 0, 0, 0, 0]), 1),
        ),
        '00110000',
      );
    });
  });

  test('areSet should return the number of set bits', () {
    expect(
      uint8.areSet(uint8.fromBits([0, 1, 1, 0, 0, 0, 0, 0])),
      2,
    );
  });

  group('msb should', () {
    test('return true if the most-sigificant-bit is set', () {
      expect(uint4.msb(uint4.fromBits([1, 1, 1, 0])), isTrue);
    });

    test('return false if the most-significant-bit is not set', () {
      expect(uint4.msb(uint4.fromBits([0, 1, 1, 0])), isFalse);
    });
  });

  const {
    int4: 4,
    int8: 8,
    int16: 16,
    int32: 32,
    int64: 64,
    int128: 128,
  }.forEach((type, length) {
    _runIntegralTests(type, length: length, signed: true);
  });

  const {
    uint4: 4,
    uint8: 8,
    uint16: 16,
    uint32: 32,
    uint64: 64,
    uint128: 128,
  }.forEach((type, length) {
    _runIntegralTests(type, length: length, signed: false);
  });
}

void _runIntegralTests(
  Integral type, {
  @required int length,
  @required bool signed,
}) {
  group('$type', () {
    test('should have a length of $length', () {
      expect(type, hasLength(length));
    });

    if (signed) {
      test('should be signed', () {
        expect(type.isSigned, isTrue);
        expect(type.isUnsigned, isFalse);
      });

      var expectedMin = -pow(2, length - 1);
      test('should have a minimum value of $expectedMin', () {
        expect(type.min, expectedMin);
      });

      var expectedMax = pow(2, length - 1) - 1;
      test('should have a maximum value of $expectedMax', () {
        expect(type.max, expectedMax);
      });
    } else {
      test('should be unsigned', () {
        expect(type.isSigned, isFalse);
        expect(type.isUnsigned, isTrue);
      });

      test('should have a minimum value of 0', () {
        expect(type.min, 0);
      });

      var expectedMax = pow(2, length) - 1;
      test('should have a maximum value of $expectedMax', () {
        expect(type.max, expectedMax);
      });
    }

    test('should be able to mask values', () {});
  });
}
