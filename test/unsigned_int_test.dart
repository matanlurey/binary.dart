import 'dart:math' as math;

import 'package:binary/binary.dart' show Uint8, debugCheckFixedWithInRange;
import 'package:test/test.dart';

import 'src/prelude.dart';

/// Tests [Uint8] as a proxy for every unsigned integer type.
void main() {
  setUp(() {
    debugCheckFixedWithInRange = true;
  });

  test('Uint8.min is 0', () {
    check(Uint8.min).equals(Uint8(0));
  });

  test('Uint8.max is 255', () {
    check(Uint8.max).equals(Uint8(255));
  });

  test('Uint8.width is 8', () {
    check(Uint8.width).equals(8);
  });

  group('Uint8.new', () {
    test('returns normally in range', () {
      check(Uint8(0)).equals(Uint8(0));
      check(Uint8(255)).equals(Uint8(255));
    });

    test('throws on underflow', () {
      check(() => Uint8(-1)).throws<Error>();
    });

    test('throws on overflow', () {
      check(() => Uint8(256)).throws<Error>();
    });

    test('wraps on underflow', () {
      debugCheckFixedWithInRange = false;
      check(Uint8(-1)).equals(Uint8(255));
    });

    test('wraps on overflow', () {
      debugCheckFixedWithInRange = false;
      check(Uint8(256)).equals(Uint8(0));
    });
  });

  group('Uint8.fromWrapped', () {
    test('returns normally in range', () {
      check(Uint8.fromWrapped(0)).equals(Uint8(0));
      check(Uint8.fromWrapped(255)).equals(Uint8(255));
    });

    test('wraps on underflow', () {
      check(Uint8.fromWrapped(-1)).equals(Uint8(255));
    });

    test('wraps on overflow', () {
      check(Uint8.fromWrapped(256)).equals(Uint8(0));
    });
  });

  group('Uint8.fromClamped', () {
    test('returns normally in range', () {
      check(Uint8.fromClamped(0)).equals(Uint8(0));
      check(Uint8.fromClamped(255)).equals(Uint8(255));
    });

    test('clamps on underflow', () {
      check(Uint8.fromClamped(-1)).equals(Uint8(0));
    });

    test('clamps on overflow', () {
      check(Uint8.fromClamped(256)).equals(Uint8(255));
    });
  });

  test('Uint8.fromHiLo is the inverse of .hiLo', () {
    for (var i = Uint8.min; i < Uint8.max; i += Uint8(1)) {
      final (hi, lo) = i.hiLo;
      check(Uint8.fromHiLo(hi, lo)).equals(i);
    }
  });

  test('pow that is in range', () {
    const result = _Uint8Result.all(16);
    check(Uint8(2)).checkPow(4, result);
  });

  test('pow that overflows', () {
    const result = _Uint8Result.fails(
      expectedClamp: 255,
      expectedWrap: 0,
    );
    check(Uint8(2)).checkPow(8, result);
  });

  test('sqrt', () {
    check(Uint8(16).sqrt()).equals(Uint8(4));
  });

  test('log without base', () {
    check(Uint8(16))
        .has((p) => p.log(), 'log()')
        .equals(Uint8(math.log(16).floor()));
  });

  test('log with base 6', () {
    check(Uint8(16))
        .has((p) => p.log(6), 'log(6)')
        .equals(Uint8(math.log(16) ~/ math.log(6)));
  });

  test('log with base 2', () {
    check(Uint8(16))
        .has((p) => p.log2(), 'log2()')
        .equals(Uint8(math.log(16) ~/ math.log(2)));
  });

  test('log with base 10', () {
    check(Uint8(16))
        .has((p) => p.log10(), 'log10()')
        .equals(Uint8(math.log(16) ~/ math.log(10)));
  });

  test('midpoint', () {
    check(Uint8(0).midpoint(Uint8(255))).equals(Uint8(127));
  });

  group('individual bit operations', () {
    test('msb is true numbers that are >= 128', () {
      for (var i = 0; i < 128; i++) {
        check(Uint8(i).msb).isFalse();
      }
      for (var i = 128; i < 256; i++) {
        check(Uint8(i).msb).isTrue();
      }
    });

    test('nth bit returns true for a 1 represented in binaru', () {
      // A Uint8 in binary is "00000000" to "11111111".
      for (var i = 0; i < 8; i++) {
        check(Uint8(1 << i)[i]).isTrue();
      }
      for (var i = 0; i < 8; i++) {
        check(Uint8(0)[i]).isFalse();
      }
    });

    test('setNthBit sets the nth bit to 1', () {
      for (var i = 0; i < 8; i++) {
        check(Uint8(0).setNthBit(i)).equals(Uint8(1 << i));
      }
    });

    test('toggleNthBit toggles the nth bit', () {
      for (var i = 0; i < 8; i++) {
        check(Uint8(0).toggleNthBit(i)).equals(Uint8(1 << i));
        check(Uint8(1 << i).toggleNthBit(i)).equals(Uint8(0));
      }
    });
  });

  test('nextPowerOf2 in range', () {
    check(Uint8(1)).checkNextPowerOf2(
      const _Uint8Result.all(1),
    );
    check(Uint8(2)).checkNextPowerOf2(
      const _Uint8Result.all(2),
    );
    check(Uint8(63)).checkNextPowerOf2(
      const _Uint8Result.all(64),
    );
  });

  test('nextPowerOf2 overflows', () {
    check(Uint8(245)).checkNextPowerOf2(
      const _Uint8Result.fails(
        expectedClamp: 255,
        expectedWrap: 0,
      ),
    );
  });

  test('nextMultipleOf in range', () {
    check(Uint8(1)).checkNextMultipleOf(
      const _Uint8Result.all(1),
      Uint8(1),
    );
    check(Uint8(2)).checkNextMultipleOf(
      const _Uint8Result.all(2),
      Uint8(1),
    );
    check(Uint8(63)).checkNextMultipleOf(
      const _Uint8Result.all(63),
      Uint8(1),
    );
  });

  test('nextMultipleOf overflows', () {
    check(Uint8(245)).checkNextMultipleOf(
      const _Uint8Result.fails(
        expectedClamp: 255,
        expectedWrap: 44,
      ),
      Uint8(100),
    );
  });

  test('countOnes', () {
    final i1 = int.parse('11111111', radix: 2);
    check(Uint8(i1).countOnes()).equals(8);

    final i2 = int.parse('01010101', radix: 2);
    check(Uint8(i2).countOnes()).equals(4);
  });

  test('countLeadingOnes', () {
    final i1 = int.parse('11111111', radix: 2);
    check(Uint8(i1).countLeadingOnes()).equals(8);

    final i2 = int.parse('01010101', radix: 2);
    check(Uint8(i2).countLeadingOnes()).equals(0);
  });

  test('countTrailingOnes', () {
    final i1 = int.parse('11111111', radix: 2);
    check(Uint8(i1).countTrailingOnes()).equals(8);

    final i2 = int.parse('01010101', radix: 2);
    check(Uint8(i2).countTrailingOnes()).equals(1);
  });

  test('countZeros', () {
    final i1 = int.parse('00000000', radix: 2);
    check(Uint8(i1).countZeros()).equals(8);

    final i2 = int.parse('01010101', radix: 2);
    check(Uint8(i2).countZeros()).equals(4);
  });

  test('countLeadingZeros', () {
    final i1 = int.parse('00000000', radix: 2);
    check(Uint8(i1).countLeadingZeros()).equals(8);

    final i2 = int.parse('01010101', radix: 2);
    check(Uint8(i2).countLeadingZeros()).equals(1);
  });

  test('countTrailingZeros', () {
    final i1 = int.parse('00000000', radix: 2);
    check(Uint8(i1).countTrailingZeros()).equals(8);

    final i2 = int.parse('01010101', radix: 2);
    check(Uint8(i2).countTrailingZeros()).equals(0);
  });

  group('bit slice and range operations', () {
    test('should return the last 4 bits, left-padded with 0s', () {
      final i1 = int.parse('01111111', radix: 2);
      //                    ^^^^
      final s1 = Uint8(i1).bitChunk(4).toBinaryString();
      check(s1).equals('00000111');
    });

    test('should return the first 4 bits', () {
      final i1 = int.parse('01111111', radix: 2);
      //                        ^^^^
      final s1 = Uint8(i1).bitChunk(0, 4).toBinaryString();
      check(s1).equals('00001111');
    });

    test('should return the middle 4 bits', () {
      final i1 = int.parse('01111111', radix: 2);
      //                      ^^^^
      final s1 = Uint8(i1).bitChunk(2, 4).toBinaryString();
      check(s1).equals('00001111');
    });

    test('should use slice to get the last 4 bits', () {
      final i1 = int.parse('01111111', radix: 2);
      //                    ^^^^
      final s1 = Uint8(i1).bitSlice(4).toBinaryString();
      check(s1).equals('00000111');
    });

    test('should use slice to get the first 4 bits', () {
      final i1 = int.parse('01111111', radix: 2);
      //                        ^^^^
      final s1 = Uint8(i1).bitSlice(0, 3).toBinaryString();
      check(s1).equals('00001111');
    });

    test('should use slice to get the middle 4 bits', () {
      final i1 = int.parse('01111111', radix: 2);
      //                      ^^^^
      final s1 = Uint8(i1).bitSlice(2, 5).toBinaryString();
      check(s1).equals('00001111');
    });

    test('should replace the first 4 bits with 1010', () {
      final i1 = int.parse('01111111', radix: 2);
      //                        ^^^^
      final i2 = int.parse('1010', radix: 2);
      final s1 = Uint8(i1).bitReplace(0, 3, i2).toBinaryString();
      check(s1).equals('01111010');
    });

    test('should replace the last 4 bits with 1010', () {
      final i1 = int.parse('11111111', radix: 2);
      //                    ^^^^
      final i2 = int.parse('1010', radix: 2);
      final s1 = Uint8(i1).bitReplace(4, null, i2).toBinaryString();
      check(s1).equals('10101111');
    });

    test('rotate bits to the right by 1', () {
      final i1 = int.parse('01111111', radix: 2);
      //                    ^0111111
      final s1 = Uint8(i1).rotateRight(1).toBinaryString();
      check(s1).equals('10111111');
    });

    test('rotate bits to the right by 4', () {
      final i1 = int.parse('01111111', radix: 2);
      //                    ^0111
      final s1 = Uint8(i1).rotateRight(4).toBinaryString();
      check(s1).equals('11110111');
    });

    test('rotate bits to the left by 1', () {
      final i1 = int.parse('01111111', radix: 2);
      //                    0111111^
      final s1 = Uint8(i1).rotateLeft(1).toBinaryString();
      check(s1).equals('11111110');
    });

    test('rotate bits to the left by 4', () {
      final i1 = int.parse('01111111', radix: 2);
      //                    0111^111
      final s1 = Uint8(i1).rotateLeft(4).toBinaryString();
      check(s1).equals('11110111');
    });
  });

  test('isMin', () {
    check(Uint8(0).isMin).isTrue();
    check(Uint8(1).isMin).isFalse();
  });

  test('isMax', () {
    check(Uint8(255).isMax).isTrue();
    check(Uint8(254).isMax).isFalse();
  });

  test('bitLength', () {
    check(Uint8(0).bitLength).equals(0);
    check(Uint8(1).bitLength).equals(1);
    check(Uint8(255).bitLength).equals(8);
  });

  test('isEven', () {
    check(Uint8(0).isEven).isTrue();
    check(Uint8(1).isEven).isFalse();
    check(Uint8(2).isEven).isTrue();
  });

  test('isOdd', () {
    check(Uint8(0).isOdd).isFalse();
    check(Uint8(1).isOdd).isTrue();
    check(Uint8(2).isOdd).isFalse();
  });

  test('isZero', () {
    check(Uint8(0).isZero).isTrue();
    check(Uint8(1).isZero).isFalse();
  });

  test('isPositive', () {
    check(Uint8(0).isPositive).isFalse();
    check(Uint8(1).isPositive).isTrue();
  });
  test('clamp', () {
    check(Uint8(0).clamp(Uint8(1), Uint8(3))).equals(Uint8(1));
    check(Uint8(2).clamp(Uint8(1), Uint8(3))).equals(Uint8(2));
    check(Uint8(4).clamp(Uint8(1), Uint8(3))).equals(Uint8(3));
  });

  test('remainder', () {
    check(Uint8(5).remainder(Uint8(3))).equals(Uint8(2));
    check(Uint8(5).remainder(Uint8(5))).equals(Uint8(0));
    check(Uint8(5).remainder(Uint8(6))).equals(Uint8(5));
  });

  test('toDouble', () {
    check(Uint8(0).toDouble()).equals(0.0);
    check(Uint8(1).toDouble()).equals(1.0);
    check(Uint8(255).toDouble()).equals(255.0);
  });

  test('operator %', () {
    check(Uint8(5) % Uint8(3)).equals(Uint8(2));
    check(Uint8(5) % Uint8(5)).equals(Uint8(0));
    check(Uint8(5) % Uint8(6)).equals(Uint8(5));
  });
}

final class _Uint8Result {
  const _Uint8Result.fails({
    required this.expectedClamp,
    required this.expectedWrap,
  })  : expected = null,
        expectedTry = null;

  const _Uint8Result.all(int expected)
      // ignore: prefer_initializing_formals
      : expected = expected,
        expectedTry = expected,
        expectedClamp = expected,
        expectedWrap = expected;

  final int? expected;
  final int? expectedTry;
  final int expectedClamp;
  final int expectedWrap;
}

extension on Subject<Uint8> {
  void checkPow(int exponent, _Uint8Result result) {
    if (result.expected case final int expected) {
      has((p) => p.pow(exponent), 'pow($exponent)').equals(
        expected as Uint8,
      );
    } else {
      has((p) => () => p.pow(exponent), 'pow($exponent)').throws<Error>();
    }

    has((p) => p.tryPow(exponent), 'tryPow($exponent)').equals(
      result.expectedTry as Uint8?,
    );

    has((p) => p.clampedPow(exponent), 'clampedPow($exponent)').equals(
      result.expectedClamp as Uint8,
    );

    has((p) => p.wrappedPow(exponent), 'wrappedPow($exponent)').equals(
      result.expectedWrap as Uint8,
    );
  }

  void checkNextPowerOf2(_Uint8Result result) {
    if (result.expected != null) {
      has((p) => p.nextPowerOf2(), 'nextPowerOf2()').equals(
        result.expected as Uint8,
      );
    } else {
      has((p) => () => p.nextPowerOf2(), 'nextPowerOf2()').throws<Error>();
    }

    has((p) => p.tryNextPowerOf2(), 'tryNextPowerOf2()').equals(
      result.expectedTry as Uint8?,
    );

    has((p) => p.clampedNextPowerOf2(), 'clampedNextPowerOf2()').equals(
      result.expectedClamp as Uint8,
    );

    has((p) => p.wrappedNextPowerOf2(), 'wrappedNextPowerOf2()').equals(
      result.expectedWrap as Uint8,
    );
  }

  void checkNextMultipleOf(_Uint8Result result, Uint8 multiple) {
    if (result.expected != null) {
      has(
        (p) => p.nextMultipleOf(multiple),
        'nextMultipleOf($multiple)',
      ).equals(result.expected as Uint8);
    } else {
      has(
        (p) => () => p.nextMultipleOf(multiple),
        'nextMultipleOf($multiple)',
      ).throws<Error>();
    }

    has(
      (p) => p.tryNextMultipleOf(multiple),
      'tryNextMultipleOf($multiple)',
    ).equals(result.expectedTry as Uint8?);

    has(
      (p) => p.clampedNextMultipleOf(multiple),
      'clampedNextMultipleOf($multiple)',
    ).equals(result.expectedClamp as Uint8);

    has(
      (p) => p.wrappedNextMultipleOf(multiple),
      'wrappedNextMultipleOf($multiple)',
    ).equals(result.expectedWrap as Uint8);
  }
}
