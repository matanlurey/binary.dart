// ignore_for_file: deprecated_member_use_from_same_package
import 'dart:math' as math;

import 'package:binary/binary.dart';
import 'package:test/test.dart';

/// Tests the [BinaryInt] extension methods.
void main() {
  test('pow should work identical to math.pow', () {
    expect(2.pow(10), math.pow(2, 10));
  });

  test('signedRightShift should work identical to >> in JavaScript', () {
    const length = 8; // Assume 8-bit integer.

    // 1111 1111 -> 1111 1111
    expect(
      '1111' '1111'.bits.signedRightShift(5, length),
      '1111' '1111'.bits,
    );

    // 0111 1111 -> 0000 0011
    expect(
      '0111' '1111'.bits.signedRightShift(5, length),
      '0000' '0011'.bits,
    );
  });

  group('signExtend', () {
    test('should extend a number with sign-bit 1', () {
      final input = '110'.bits;
      final output = '11110'.bits;
      expect(input.signExtend(3, 5), output);
    });

    test('should extend a number with sign-bit 0', () {
      final input = '011'.bits;
      expect(input.signExtend(3, 5), input);
    });

    test('should throw if endSize <= startSize', () {
      final input = '110'.bits;
      expect(() => input.signExtend(5, 3), throwsRangeError);
    });
  });

  group('rotateRightShift should rotate bits to the right', () {
    test('LSB -> MSB [1 Bit]', () {
      final input = '0000' '0001'.bits;
      final output = '1000' '0000'.bits;
      final result = input.rotateRightShift(1, 8);
      expect(
        result,
        output,
        reason: ''
            '${output.toBinaryPadded(8)} !=\n'
            '${result.toBinaryPadded(8)}',
      );
    });

    test('LSB -> MSB [2 Bits]', () {
      final input = '0000' '0011'.bits;
      final output = '1100' '0000'.bits;
      final result = input.rotateRightShift(2, 8);
      expect(
        result,
        output,
        reason: ''
            '${output.toBinaryPadded(8)} !=\n'
            '${result.toBinaryPadded(8)}',
      );
    });

    test('Unchanged MSB', () {
      final input = '0001' '1000'.bits;
      final output = '0000' '0110'.bits;
      final result = input.rotateRightShift(2, 8);
      expect(
        result,
        output,
        reason: ''
            '${output.toBinaryPadded(8)} !=\n'
            '${result.toBinaryPadded(8)}',
      );
    });
  });

  test('countSetBits should return the number of set bits', () {
    expect('0110'.bits.countSetBits(4), 2);
    expect('0110'.bits.countSetBits(4), 2);
  });

  test('msb should return if the most significant bit is set', () {
    expect('0000'.bits.msb(4), isFalse);
    expect('0110'.bits.msb(4), isFalse);
    expect('1000'.bits.msb(4), isTrue);
  });

  test('getBit should return 0 or 1', () {
    expect(() => '1010'.bits.getBit(-1), throwsRangeError);
    expect('1010'.bits.getBit(0), 0);
    expect('1010'.bits.getBit(1), 1);
    expect('1010'.bits.getBit(2), 0);
    expect('1010'.bits.getBit(3), 1);
    expect('1010'.bits.getBit(4), 0);
  });

  test('setBit should return a new number', () {
    expect(() => '1010'.bits.setBit(-1), throwsRangeError);
    expect('1010'.bits.setBit(0).toBinary(), '1011');
    expect('1010'.bits.setBit(1).toBinary(), '1010');
  });

  test('clearBit should return a new number', () {
    expect(() => '1010'.bits.clearBit(-1), throwsRangeError);
    expect('1010'.bits.clearBit(0).toBinary(), '1010');
    expect('1010'.bits.clearBit(1).toBinary(), '1000');
  });

  test('toggleBit should return a new number', () {
    expect('1010'.bits.toggleBit(0).toBinaryPadded(4), '1011');
    expect('1010'.bits.toggleBit(3, false).toBinaryPadded(4), '0010');
    expect('1010'.bits.toggleBit(2, true).toBinaryPadded(4), '1110');
  });

  test('isSet/isClear should check for 1', () {
    expect(() => '1010'.bits.isClear(-1), throwsRangeError);
    expect(() => '1010'.bits.isSet(-1), throwsRangeError);
    expect('1010'.bits.isClear(0), isTrue);
    expect('1010'.bits.isClear(1), isFalse);
    expect('1010'.bits.isSet(0), isFalse);
    expect('1010'.bits.isSet(1), isTrue);
  });

  test('bitChunk should return a partial chunk of a number', () {
    expect(() => '1010'.bits.bitChunk(-1, 1), throwsRangeError);
    expect(() => '1010'.bits.bitChunk(0, 0), throwsRangeError);
    expect(() => '1010'.bits.bitChunk(2, 4), throwsRangeError);
    //      3210                       3->1               321
    expect('1010'.bits.bitChunk(3, 3).toBinary(), '101');
  });

  test('bitRange should return a partial chunk of a number', () {
    //      32                         3->2               32
    expect('1010'.bits.bitRange(3, 2).toBinary(), '10');
    expect(0x01020304.toBinary(), '1000000100000001100000100');
    expect(0x01020304.bitRange(31, 24), 0x01);
    expect(0x01020304.bitRange(4, 0), 4, reason: '${0x01020304.toBinary()}');
  });

  test('replaceBitRange should replace a range of bits', () {
    expect(
      //2-0
      '1010'.bits.replaceBitRange(2, 0, '111'.bits).toBinary(),
      '1111',
    );
  });

  test('toBinary should return a string representation', () {
    expect(0xFF.toBinary(), '1111' '1111');
    expect(1.toBinaryPadded(8), '0000' '0001');
  });
}
