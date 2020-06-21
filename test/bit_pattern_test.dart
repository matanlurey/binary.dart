import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  BitPattern<List<int>> build(List<BitPart> parts, [String name]) {
    return BitPatternBuilder(parts).build(name);
  }

  group('_InterpretedBitPattern', () {
    test('0b1111 should match 0b1111', () {
      final pattern = build(const [
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
      final pattern = build(const [
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
      final pattern = build(const [
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
      final pattern = build(const [
        BitPart(1),
        BitPart(0),
        BitPart(1),
        BitPart.v(1),
      ]);
      expect(pattern.matches('1010'.parseBits()), isTrue);
      expect(pattern.matches('1011'.parseBits()), isTrue);
    });

    test('0b01VV should match 0b01**', () {
      final pattern = build(const [
        BitPart(0),
        BitPart(1),
        BitPart.v(2, 'VV'),
      ], '01VV');
      expect(
        pattern.matches('0110'.parseBits()),
        isTrue,
        reason: 'Did not match $pattern',
      );
    });

    test('should capture a set of variables/names', () {
      // 10FFFFTT
      final pattern = build(const [
        BitPart(1),
        BitPart(0),
        BitPart.v(4, 'FOUR'),
        BitPart.v(2, 'TWO'),
      ]);
      // 10FFFFTT
      // 10111010
      final captured = pattern.capture('1011' '1010'.parseBits());
      expect(
        Map.fromIterables(pattern.names, captured),
        {'FOUR': '1110'.parseBits(), 'TWO': '10'.parseBits()},
      );
    });

    test('should be sortable by specificity', () {
      final v0 = build(const [
        BitPart(1),
        BitPart(1),
      ]);
      final v1 = build(const [
        BitPart(0),
        BitPart(0),
        BitPart.v(1),
      ]);
      final v2 = build(const [
        BitPart(0),
        BitPart(1),
        BitPart.v(1),
        BitPart.v(1),
      ]);
      final v3 = build(const [
        BitPart(1),
        BitPart.v(1),
        BitPart.v(1),
        BitPart.v(1),
      ]);
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
      expect(() => build(List.filled(33, const BitPart(0))), throwsStateError);
    });
  });

  group('BitPatternBuilder.parse', () {
    test('should fail on null', () {
      expect(() => BitPatternBuilder.parse(null).build(), throwsArgumentError);
    });

    test('should fail on an empty string', () {
      expect(() => BitPatternBuilder.parse('').build(), throwsArgumentError);
    });

    test('should fail on an unexpected character', () {
      expect(() => BitPatternBuilder.parse(' ').build(), throwsFormatException);
    });

    test('should fail on multiple _s', () {
      expect(
        () => BitPatternBuilder.parse('1__0').build(),
        throwsFormatException,
      );
    });

    test('should fail on duplicate variables', () {
      expect(
        () => BitPatternBuilder.parse('0101_AABA').build(),
        throwsFormatException,
      );
    });

    test('should parse a simple set of flags', () {
      expect(
        BitPatternBuilder.parse('0101_1010').build(),
        BitPatternBuilder(const [
          BitPart(0),
          BitPart(1),
          BitPart(0),
          BitPart(1),
          BitPart(1),
          BitPart(0),
          BitPart(1),
          BitPart(0),
        ]).build(),
      );
    });

    test('should parse a set of flags and variables', () {
      expect(
        BitPatternBuilder.parse('0101_AAAB').build(),
        BitPatternBuilder(const [
          BitPart(0),
          BitPart(1),
          BitPart(0),
          BitPart(1),
          BitPart.v(3, 'A'),
          BitPart.v(1, 'B'),
        ]).build(),
      );
    });
  });

  group('BitPatternGroup', () {
    test('should fail on null', () {
      List<BitPattern<void>> patterns;
      expect(() => patterns.toGroup(), throwsArgumentError);
    });

    test('should fail on empty', () {
      final patterns = <BitPattern<void>>[];
      expect(() => patterns.toGroup(), throwsArgumentError);
    });

    test('should match a pattern', () {
      final match$01VV = build(const [
        BitPart(0),
        BitPart(1),
        BitPart.v(2),
      ], '01VV');
      final match$11VV = build(const [
        BitPart(1),
        BitPart(1),
        BitPart.v(2),
      ], '11VV');
      final matchGroup = [match$01VV, match$11VV].toGroup();

      expect(matchGroup.match('0000'.parseBits()), isNull);
      expect(matchGroup.match('0100'.parseBits()), same(match$01VV));
    });
  });

  group('<newList>', () {
    test('<=8-bit', () {
      final p8 = BitPatternBuilder(const [BitPart.v(8)]).build();
      expect(p8.capture(0xFF), [0xFF]);
    });

    test('<=16-bit', () {
      final p16 = BitPatternBuilder(const [BitPart.v(16)]).build();
      expect(p16.capture(0xFFFF), [0xFFFF]);
    });

    test('<=32-bit', () {
      final p32 = BitPatternBuilder(const [BitPart.v(32)]).build();
      expect(p32.capture(0xFFFFFFFF), [0xFFFFFFFF]);
    });
  });

  test('<toString>', () {
    var enabled = false;
    assert(enabled = true);
    if (enabled) {
      expect(const BitPart(0).toString(), 'Bit { 0 }');
      expect(const BitPart.v(1).toString(), 'Segment { 1-bits }');
      expect(const BitPart.v(1, 'A').toString(), 'Segment { A: 1-bits }');
      expect(
        BitPatternBuilder(const [BitPart.v(1, 'A')]).build().toString(),
        contains('CaptureBits { A, 0 :: 1 }'),
      );
    } else {
      expect(const BitPart(0).toString(), isNot('Bit { 0 }'));
      expect(const BitPart.v(1).toString(), isNot('Segment { 1-bits }'));
      expect(
        BitPatternBuilder(const [BitPart.v(1, 'A')]).build().toString(),
        isNot(contains('CaptureBits { A, 0 :: 1 }')),
      );
    }
  });
}
