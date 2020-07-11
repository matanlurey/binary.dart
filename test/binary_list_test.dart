import 'dart:typed_data';

import 'package:binary/binary.dart';
import 'package:test/test.dart';

/// Tests the [BinaryUint8List] extension methods.
void main() {
  group('Uint8List', () {
    Uint8List from(String s) => Uint8List.fromList([s.bits]);

    test('getBoxed should return an appropriate boxed type', () {
      final list = from('1');
      expect(list.getBoxed(0), TypeMatcher<Uint8>());
    });

    test('shiftRight should infer length', () {
      final list = from('0111' '1111');
      expect(list.shiftRight(0, 5).toBinaryPadded(8), '0000' '0011');
    });

    test('countSetBits should infer length', () {
      final list = from('0110' '0000');
      expect(list.countSetBits(0), 2);
    });

    test('msb should infer length', () {
      final a = from('0110' '0000');
      expect(a.msb(0), isFalse);

      final b = from('1010' '0000');
      expect(b.msb(0), isTrue);
    });
  });

  group('Int8List', () {
    Int8List from(String s) => Int8List.fromList([s.bits]);

    test('getBoxed should return an appropriate boxed type', () {
      final list = from('1');
      expect(list.getBoxed(0), TypeMatcher<Int8>());
    });

    test('shiftRight should infer length', () {
      final list = from('0111' '1111');
      expect(list.shiftRight(0, 5).toBinaryPadded(8), '0000' '0011');
    });

    test('countSetBits should infer length', () {
      final list = from('0110' '0000');
      expect(list.countSetBits(0), 2);
    });

    test('msb should infer length', () {
      final a = from('0110' '0000');
      expect(a.msb(0), isFalse);

      final b = from('1010' '0000');
      expect(b.msb(0), isTrue);
    });
  });

  group('Uint16List', () {
    Uint16List from(String s) => Uint16List.fromList([s.bits]);

    test('getBoxed should return an appropriate boxed type', () {
      final list = from('1');
      expect(list.getBoxed(0), TypeMatcher<Uint16>());
    });

    test('shiftRight should infer length', () {
      final list = from('0111' '1111' '0000' '0000');
      expect(
        list.shiftRight(0, 5).toBinaryPadded(16),
        '0000' '0011' '1111' '1000',
      );
    });

    test('countSetBits should infer length', () {
      final list = from('0110' '0000' '0000' '0000');
      expect(list.countSetBits(0), 2);
    });

    test('msb should infer length', () {
      final a = from('0110' '0000' '0000' '0000');
      expect(a.msb(0), isFalse);

      final b = from('1010' '0000' '0000' '0000');
      expect(b.msb(0), isTrue);
    });
  });

  group('Int16List', () {
    Int16List from(String s) => Int16List.fromList([s.bits]);

    test('getBoxed should return an appropriate boxed type', () {
      final list = from('1');
      expect(list.getBoxed(0), TypeMatcher<Int16>());
    });

    test('shiftRight should infer length', () {
      final list = from('0111' '1111' '0000' '0000');
      expect(
        list.shiftRight(0, 5).toBinaryPadded(16),
        '0000' '0011' '1111' '1000',
      );
    });

    test('countSetBits should infer length', () {
      final list = from('0110' '0000' '0000' '0000');
      expect(list.countSetBits(0), 2);
    });

    test('msb should infer length', () {
      final a = from('0110' '0000' '0000' '0000');
      expect(a.msb(0), isFalse);

      final b = from('1010' '0000' '0000' '0000');
      expect(b.msb(0), isTrue);
    });
  });

  group('Uint32List', () {
    Uint32List from(String s) => Uint32List.fromList([s.bits]);

    test('getBoxed should return an appropriate boxed type', () {
      final list = from('1');
      expect(list.getBoxed(0), TypeMatcher<Uint32>());
    });

    test('shiftRight should infer length', () {
      final list = from(
        '0111' '1111' '0000' '0000' '0000' '0000' '0000' '0000',
      );
      expect(
        list.shiftRight(0, 5).toBinaryPadded(32),
        '0000' '0011' '1111' '1000' '0000' '0000' '0000' '0000',
      );
    });

    test('countSetBits should infer length', () {
      final list = from(
        '0110' '0000' '0000' '0000' '0000' '0000' '0000' '0000',
      );
      expect(list.countSetBits(0), 2);
    });

    test('msb should infer length', () {
      final a = from('0110' '0000' '0000' '0000' '0000' '0000' '0000' '0000');
      expect(a.msb(0), isFalse);

      final b = from('1010' '0000' '0000' '0000' '0000' '0000' '0000' '0000');
      expect(b.msb(0), isTrue);
    });
  });

  group('Int32List', () {
    Int32List from(String s) => Int32List.fromList([s.bits]);

    test('getBoxed should return an appropriate boxed type', () {
      final list = from('1');
      expect(list.getBoxed(0), TypeMatcher<Int32>());
    });

    test('shiftRight should infer length', () {
      final list = from(
        '0111' '1111' '0000' '0000' '0000' '0000' '0000' '0000',
      );
      expect(
        list.shiftRight(0, 5).toBinaryPadded(32),
        '0000' '0011' '1111' '1000' '0000' '0000' '0000' '0000',
      );
    });

    test('countSetBits should infer length', () {
      final list = from(
        '0110' '0000' '0000' '0000' '0000' '0000' '0000' '0000',
      );
      expect(list.countSetBits(0), 2);
    });

    test('msb should infer length', () {
      final a = from('0110' '0000' '0000' '0000' '0000' '0000' '0000' '0000');
      expect(a.msb(0), isFalse);

      final b = from('1010' '0000' '0000' '0000' '0000' '0000' '0000' '0000');
      expect(b.msb(0), isTrue);
    });
  });

  group('BinaryList', () {
    test('parseBits should parse a list of 0s and 1s', () {
      expect(
        [0, 1, 1, 0, 0, 0, 0, 0].toBits().toBinaryPadded(8),
        '0  1  1  0  0  0  0  0'.replaceAll(' ', ''),
      );
    });

    test('parseBits should refuse on an empty string', () {
      expect(() => ''.bits, throwsFormatException);
    });

    test('signExtend should work similarly to int.signExtend', () {
      final list = ['110'.bits];
      expect(list.signExtend(0, 3, 5).toBinary(), '11110');
    });

    test('rotateRight should work similarly to int.rotateRight', () {
      final list = ['0110' '0000'.bits];
      expect(
        list.rotateRight(0, 1).toBinaryPadded(8),
        '0011' '0000',
      );
    });

    test('countSetBits should work similarly to int.countSetBits', () {
      final list = ['0110'.bits];
      expect(list.countSetBits(0, 4), 2);
    });

    test('get/set/clearBit should work similarly to int.*', () {
      final list = ['0110'.bits];
      expect(list[0].toBinaryPadded(4), '0110');
      expect(list.getBit(0, 0), 0);
      expect(list.getBit(0, 1), 1);
      expect(list.setBit(0, 0).toBinaryPadded(4), '0111');
      expect(list.isSet(0, 0), isTrue);
      expect(list.clearBit(0, 1).toBinaryPadded(4), '0101');
      expect(list.isClear(0, 1), isTrue);
      expect(list.toggleBit(0, 0).toBinaryPadded(4), '0100');
    });

    test('bitChunk/bitRange work similarly to int.*', () {
      //       3210                           3->1               321
      expect(['1010'.bits].bitChunk(0, 3, 3).toBinary(), '101');
      //       32                             3->2               32
      expect(['1010'.bits].bitRange(0, 3, 2).toBinary(), '10');
    });

    test('replaceBitRange works similar to int.*', () {
      expect(
        //2-0
        ['1010'.bits].replaceBitRange(0, 2, 0, '111'.bits).toBinary(),
        '1111',
      );
    });
  });
}
