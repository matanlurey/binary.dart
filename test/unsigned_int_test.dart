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
      if (assertionsEnabled) {
        check(() => Uint8(-1)).throws<Error>();
      } else {
        check(Uint8(-1)).equals(Uint8(255));
      }
    });

    test('throws on overflow', () {
      if (assertionsEnabled) {
        check(() => Uint8(256)).throws<Error>();
      } else {
        check(Uint8(256)).equals(Uint8(0));
      }
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
    final $2 = Uint8(2);
    check($2.pow(4)).equals(Uint8(16));
    check($2.tryPow(4)).equals(Uint8(16));
    check($2.clampedPow(4)).equals(Uint8(16));
    check($2.wrappedPow(4)).equals(Uint8(16));
  });

  test('pow that overflows', () {
    final $2 = Uint8(2);

    if (assertionsEnabled) {
      check(() => $2.pow(12)).throws<Error>();
    } else {
      check($2.pow(12)).equals(Uint8(0));
    }

    check($2.tryPow(12)).isNull();
    check($2.clampedPow(12)).equals(Uint8(255));
    check($2.wrappedPow(12)).equals(Uint8(0));
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
    final $1 = Uint8(1);
    final $2 = Uint8(2);
    final $63 = Uint8(63);

    check($1.nextPowerOf2()).equals($1);
    check($2.nextPowerOf2()).equals($2);
    check($63.nextPowerOf2()).equals(Uint8(64));
  });

  test('nextPowerOf2 overflows', () {
    final $245 = Uint8(245);

    if (assertionsEnabled) {
      check($245.nextPowerOf2).throws<Error>();
    } else {
      check($245.nextPowerOf2()).equals(Uint8(0));
    }

    check($245.tryNextPowerOf2()).isNull();
    check($245.clampedNextPowerOf2()).equals(Uint8(255));
    check($245.wrappedNextPowerOf2()).equals(Uint8(0));
  });

  test('nextMultipleOf in range', () {
    final $5 = Uint8(5);
    final $10 = Uint8(10);

    check($5.nextMultipleOf($10)).equals($10);
    check($5.tryNextMultipleOf($10)).equals($10);
    check($5.clampedNextMultipleOf($10)).equals($10);
    check($5.wrappedNextMultipleOf($10)).equals($10);

    final $7 = Uint8(7);
    final $3 = Uint8(3);

    check($7.nextMultipleOf($3)).equals(Uint8(9));
    check($7.tryNextMultipleOf($3)).equals(Uint8(9));
    check($7.clampedNextMultipleOf($3)).equals(Uint8(9));
    check($7.wrappedNextMultipleOf($3)).equals(Uint8(9));
  });

  test('nextMultipleOf overflows', () {
    if (assertionsEnabled) {
      check(() => Uint8.max.nextMultipleOf(Uint8(2))).throws<Error>();
    } else {
      check(Uint8.max.nextMultipleOf(Uint8(2))).equals(Uint8(0));
    }

    check(Uint8.max.tryNextMultipleOf(Uint8(2))).isNull();
    check(Uint8.max.clampedNextMultipleOf(Uint8(2))).equals(Uint8.max);
    check(Uint8.max.wrappedNextMultipleOf(Uint8(2))).equals(Uint8(0));
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

  group('operator *', () {
    test('in range', () {
      final $5 = Uint8(5);
      final $20 = Uint8(20);
      check($5 * $20).equals(Uint8(100));
      check($5.tryMultiply($20)).equals(Uint8(100));
      check($5.clampedMultiply($20)).equals(Uint8(100));
      check($5.wrappedMultiply($20)).equals(Uint8(100));
    });

    test('overflows', () {
      final $200 = Uint8(200);
      final $3 = Uint8(3);

      if (assertionsEnabled) {
        check(() => $200 * $3).throws<Error>();
      } else {
        check($200 * $3).equals(Uint8(88));
      }

      check($200.tryMultiply($3)).isNull();
      check($200.clampedMultiply($3)).equals(Uint8(255));
      check($200.wrappedMultiply($3)).equals(Uint8(88));
    });
  });
}
