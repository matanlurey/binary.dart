import 'package:binary/binary.dart';
import 'package:test/test.dart';

/// Tests the [BinaryString] extension methods.
void main() {
  group('parseBits', () {
    test('should fail on an empty string', () {
      expect(() => ''.parseBits(), throwsFormatException);
    });

    test('should fail on invalid characters', () {
      expect(() => '1020'.parseBits(), throwsFormatException);
    });

    test('should parse with leading 0s', () {
      expect('0110'.parseBits().toBinaryPadded(4), '0110');
    });

    test('should parse without leading 0s', () {
      expect('1010'.parseBits().toBinaryPadded(4), '1010');
    });
  });

  group('toBitList', () {
    test('should fail on an empty string', () {
      expect(() => ''.toBitList(), throwsFormatException);
    });

    test('should parse', () {
      expect('1010'.toBitList(), [1, 0, 1, 0]);
    });
  });
}
