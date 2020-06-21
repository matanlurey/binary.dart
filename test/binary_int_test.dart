import 'package:binary/binary.dart';
import 'package:expect/expect.dart';

/// Tests the [BinaryInt] extension methods.

// should box as an appropriate Integral:

void testAsBit() {
  expect(0.asBit(), Bit(0));
  expect(1.asBit(), Bit(1));
}

void testAsInt4() {
  expect(0.asInt4(), Int4(0));
}

void testAsUint4() {
  expect(0.asUint4(), Uint4(0));
}

void testAsInt8() {
  expect(0.asInt8(), Int8(0));
}

void testAsUint8() {
  expect(0.asUint8(), Uint8(0));
}

void testAsInt16() {
  expect(0.asInt16(), Int16(0));
}

void testAsUint16() {
  expect(0.asUint16(), Uint16(0));
}

void testAsInt32() {
  expect(0.asInt32(), Int32(0));
}

void testAsUint32() {
  expect(0.asUint32(), Uint32(0));
}

/// shiftRight should work identical to >>> in JavaScript.
void testShiftRight() {
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
}

/// Should extend a number with sign-bit 1,
void testSignExtendSign0() {
  final input = '110'.parseBits();
  final output = '11110'.parseBits();
  expect(input.signExtend(3, 5), output);
}

/// Should extend a number with sign-bit 0,
void testSignExtendSign1() {
  final input = '011'.parseBits();
  expect(input.signExtend(3, 5), input);
}

/// should throw if endSize <= startSize,
void testSignExtendThrow() {
  final input = '110'.parseBits();
  throws(() => input.signExtend(5, 3), isA<RangeError>());
}

/// rotateRight should rotate bits to the right.
void testRotateRight() {
  final input = '0110' '0000'.parseBits();
  final output = '0011' '0000'.parseBits();
  expect(input.rotateRight(1), output);
}

/// countSetBits should return the number of set bits.
void testCountSetBits() {
  expect('0110'.parseBits().countSetBits(4), 2);
  expect('0110'.parseBits().countSetBits(4), 2);
}

/// msb should return if the most significant bit is set.
void testMsb() {
  expect('0000'.parseBits().msb(4), isFalse);
  expect('0110'.parseBits().msb(4), isFalse);
  expect('1000'.parseBits().msb(4), isTrue);
}

/// should return 0 or 1.
void testGetBit() {
  throws(() => '1010'.parseBits().getBit(-1), isA<RangeError>());
  expect('1010'.parseBits().getBit(0), 0);
  expect('1010'.parseBits().getBit(1), 1);
  expect('1010'.parseBits().getBit(2), 0);
  expect('1010'.parseBits().getBit(3), 1);
  expect('1010'.parseBits().getBit(4), 0);
}

/// setBit should return a new number.
void testSetBit() {
  throws(() => '1010'.parseBits().setBit(-1), isA<RangeError>());
  expect('1010'.parseBits().setBit(0).toBinary(), '1011');
  expect('1010'.parseBits().setBit(1).toBinary(), '1010');
}

/// clearBit should return a new number.
void testClearBit() {
  throws(() => '1010'.parseBits().clearBit(-1), isA<RangeError>());
  expect('1010'.parseBits().clearBit(0).toBinary(), '1010');
  expect('1010'.parseBits().clearBit(1).toBinary(), '1000');
}

// isSet/isClear should check for 1.
void testBitCheck() {
  throws(() => '1010'.parseBits().isClear(-1), isA<RangeError>());
  throws(() => '1010'.parseBits().isSet(-1), isA<RangeError>());
  expect('1010'.parseBits().isClear(0), isTrue);
  expect('1010'.parseBits().isClear(1), isFalse);
  expect('1010'.parseBits().isSet(0), isFalse);
  expect('1010'.parseBits().isSet(1), isTrue);
}

/// bitChunk should return a partial chunk of a number.
void testBitChunk() {
  throws(() => '1010'.parseBits().bitChunk(-1, 1), isA<RangeError>());
  throws(() => '1010'.parseBits().bitChunk(0, 0), isA<RangeError>());
  throws(() => '1010'.parseBits().bitChunk(2, 4), isA<RangeError>());
  //      3210                       3->1               321
  expect('1010'.parseBits().bitChunk(3, 3).toBinary(), '101');
}

/// bitRange should return a partial chunk of a number.
void testBitRange() {
  //      32                         3->2               32
  expect('1010'.parseBits().bitRange(3, 2).toBinary(), '10');
  expect(0x01020304.toBinary(), '1000000100000001100000100');
  expect(0x01020304.bitRange(31, 24), 0x01);
  expect(0x01020304.bitRange(4, 0), 4, reason: '${0x01020304.toBinary()}');
}

/// replaceBitRange should replace a range of bits
void testReplaceBitRange() {
  expect(
    //2-0
    '1010'.parseBits().replaceBitRange(2, 0, '111'.parseBits()).toBinary(),
    '1111',
  );
}

/// toBinary should return a string representation
void testToBinary() {
  expect(0xFF.toBinary(), '1111' '1111');
  expect(1.toBinaryPadded(8), '0000' '0001');
}
