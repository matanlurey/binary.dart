import 'package:binary/binary.dart';
import 'package:test/test.dart';

/// Tests the [BinaryString] extension methods.
void main() {
  group('parseBits', () {
    test('should fail on an empty string', () {
      expect(() => ''.bits, throwsFormatException);
    });

    test('should fail on invalid characters', () {
      expect(() => '1020'.bits, throwsFormatException);
    });

    test('should parse with leading 0s', () {
      expect('0110'.bits.toBinaryPadded(4), '0110');
    });

    test('should parse without leading 0s', () {
      expect('1010'.bits.toBinaryPadded(4), '1010');
    });
  });

  group('toBitList', () {
    test('should fail on an empty string', () {
      expect(() => ''.toBitList(), throwsFormatException);
    });

    test('should fail on an invalid string', () {
      expect(() => '1020'.toBitList(), throwsFormatException);
    });

    test('should parse', () {
      expect('1010'.toBitList(), [1, 0, 1, 0]);
    });
  });
}
