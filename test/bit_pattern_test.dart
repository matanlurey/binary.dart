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
      expect(pattern.capture('1101'.parseBits()), [0]);
      expect(pattern.capture('1111'.parseBits()), [1]);
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

    test('should capture a set of variables/names', () {
      final pattern = build([
        BitPart(1),
        BitPart(0),
        BitPart.v(4, 'FOUR'),
        BitPart.v(2, 'TWO'),
      ]);
      final captured = pattern.capture('1011' '1010'.parseBits());
      expect(
        Map.fromIterables(pattern.names, captured),
        {
          'FOUR': '1110'.parseBits(),
          'TWO': '10'.parseBits(),
        },
      );
    });

    test('should be sortable by specificity', () {
      final v0 = build([BitPart(1), BitPart(1)]);
      final v1 = build([BitPart(0), BitPart(0), BitPart.v(1)]);
      final v2 = build([BitPart(0), BitPart(1), BitPart.v(1), BitPart.v(1)]);
      final v3 = build([BitPart(1), BitPart.v(1), BitPart.v(1), BitPart.v(1)]);
      final input = [v2, v1, v3, v0];
      expect(
        input..sort(),
        orderedEquals(
          <Object>[
            v3,
            v2,
            v1,
            v0,
          ],
        ),
      );
    });

    test('should fail on a pattern > 32-bits', () {
      expect(() => build(List.filled(33, BitPart(0))), throwsStateError);
    });
  });
}
