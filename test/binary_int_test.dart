import 'package:binary/binary.dart';
import 'package:test/test.dart';

/// Tests the [BinaryInt] extension methods.
void main() {
  group('should box as an appropriate Integral:', () {
    test('asBit', () {
      expect(0.asBit(), Bit(0));
      expect(1.asBit(), Bit(1));
    });

    test('asInt4', () {
      expect(0.asInt4(), Int4(0));
    });

    test('asUint4', () {
      expect(0.asUint4(), Uint4(0));
    });

    test('asInt8', () {
      expect(0.asInt8(), Int8(0));
    });

    test('asUint8', () {
      expect(0.asUint8(), Uint8(0));
    });

    test('asInt16', () {
      expect(0.asInt16(), Int16(0));
    });

    test('asUint16', () {
      expect(0.asUint16(), Uint16(0));
    });

    test('asInt32', () {
      expect(0.asInt32(), Int32(0));
    });

    test('asUint32', () {
      expect(0.asUint32(), Uint32(0));
    });
  });

  test('shiftRight should work identical to >>> in JavaScript', () {
    const length = 8; // Assume 8-bit integer.

    // 1111 1111 -> 1111 1111
    expect(
      '1111' '1111'.parseBits().shiftRight(5, length),
      '1111' '1111'.parseBits(),
    );

    // 0111 1111 -> 0000 0011
    expect(
      '0111' '1111'.parseBits().shiftRight(5, length),
      '0000' '0011'.parseBits(),
    );
  });

  group('signExtend', () {
    test('should extend a number with sign-bit 1', () {
      final input = '110'.parseBits();
      final output = '11110'.parseBits();
      expect(input.signExtend(3, 5), output);
    });

    test('should extend a number with sign-bit 0', () {
      final input = '011'.parseBits();
      expect(input.signExtend(3, 5), input);
    });

    test('should throw if endSize <= startSize', () {
      final input = '110'.parseBits();
      expect(() => input.signExtend(5, 3), throwsRangeError);
    });
  });

  test('rotateRight should rotate bits to the right', () {
    final input = '0110' '0000'.parseBits();
    final output = '0011' '0000'.parseBits();
    expect(input.rotateRight(1), output);
  });

  test('countSetBits should return the number of set bits', () {
    expect('0110'.parseBits().countSetBits(4), 2);
    expect('0110'.parseBits().countSetBits(4), 2);
  });

  test('msb should return if the most significant bit is set', () {
    expect('0000'.parseBits().msb(4), isFalse);
    expect('0110'.parseBits().msb(4), isFalse);
    expect('1000'.parseBits().msb(4), isTrue);
  });

  test('getBit should return 0 or 1', () {
    expect(() => '1010'.parseBits().getBit(-1), throwsRangeError);
    expect('1010'.parseBits().getBit(0), 0);
    expect('1010'.parseBits().getBit(1), 1);
    expect('1010'.parseBits().getBit(2), 0);
    expect('1010'.parseBits().getBit(3), 1);
    expect('1010'.parseBits().getBit(4), 0);
  });

  test('setBit should return a new number', () {
    expect(() => '1010'.parseBits().setBit(-1), throwsRangeError);
    expect('1010'.parseBits().setBit(0).toBinary(), '1011');
    expect('1010'.parseBits().setBit(1).toBinary(), '1010');
  });

  test('clearBit should return a new number', () {
    expect(() => '1010'.parseBits().clearBit(-1), throwsRangeError);
    expect('1010'.parseBits().clearBit(0).toBinary(), '1010');
    expect('1010'.parseBits().clearBit(1).toBinary(), '1000');
  });

  test('isSet/isClear should check for 1', () {
    expect(() => '1010'.parseBits().isClear(-1), throwsRangeError);
    expect(() => '1010'.parseBits().isSet(-1), throwsRangeError);
    expect('1010'.parseBits().isClear(0), isTrue);
    expect('1010'.parseBits().isClear(1), isFalse);
    expect('1010'.parseBits().isSet(0), isFalse);
    expect('1010'.parseBits().isSet(1), isTrue);
  });

  test('bitChunk should return a partial chunk of a number', () {
    expect(() => '1010'.parseBits().bitChunk(-1, 1), throwsRangeError);
    expect(() => '1010'.parseBits().bitChunk(0, 0), throwsRangeError);
    expect(() => '1010'.parseBits().bitChunk(2, 4), throwsRangeError);
    //      3210                       3->1               321
    expect('1010'.parseBits().bitChunk(3, 3).toBinary(), '101');
  });

  test('bitRange should return a partial chunk of a number', () {
    //      32                         3->2               32
    expect('1010'.parseBits().bitRange(3, 2).toBinary(), '10');
    expect(0x01020304.toBinary(), '1000000100000001100000100');
    expect(0x01020304.bitRange(31, 24), 0x01);
    expect(0x01020304.bitRange(4, 0), 4, reason: '${0x01020304.toBinary()}');
  });

  test('replaceBitRange should replace a range of bits', () {
    expect(
      //2-0
      '1010'.parseBits().replaceBitRange(2, 0, '111'.parseBits()).toBinary(),
      '1111',
    );
  });

  test('toBinary should return a string representation', () {
    expect(0xFF.toBinary(), '1111' '1111');
    expect(1.toBinaryPadded(8), '0000' '0001');
  });
}
