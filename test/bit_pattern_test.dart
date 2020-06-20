import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  BitPattern<List<int>> build(List<BitPart> parts) {
    return BitPatternBuilder(parts).build();
  }

  group('_InterpretedBitPattern', () {
    test('0b1111 should match 0b1111', () {
      final pattern = build([
        BitPart(1),
        BitPart(1),
        BitPart(1),
        BitPart(1),
      ]);
      expect(pattern.matches('1111'.parseBits()), isTrue);
      expect(pattern.matches('1010'.parseBits()), isFalse);
      expect(pattern.matches('0000'.parseBits()), isFalse);
    });

    test('0b0000 should match 0b000', () {
      final pattern = build([
        BitPart(0),
        BitPart(0),
        BitPart(0),
        BitPart(0),
      ]);
      expect(pattern.matches('0000'.parseBits()), isTrue);
      expect(pattern.matches('1010'.parseBits()), isFalse);
      expect(pattern.matches('1111'.parseBits()), isFalse);
    });

    test('0b11V1 should match 0b1101, 0b1111', () {
      final pattern = build([
        BitPart(1),
        BitPart(1),
        BitPart.v(1),
        BitPart(1),
      ]);
      expect(pattern.matches('1101'.parseBits()), isTrue);
      expect(pattern.matches('1111'.parseBits()), isTrue);
    });

    test('0b101V should match 0b1010, 0b1011', () {
      final pattern = build([
        BitPart(1),
        BitPart(0),
        BitPart(1),
        BitPart.v(1),
      ]);
      expect(pattern.matches('1010'.parseBits()), isTrue);
      expect(pattern.matches('1011'.parseBits()), isTrue);
    });
  });
}
