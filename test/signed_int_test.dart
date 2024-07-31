import 'dart:math' as math;

import 'package:binary/binary.dart' show Int8, debugCheckFixedWithInRange;
import 'package:test/test.dart';

import 'src/prelude.dart';

/// Tests [Int8] as a proxy for every unsigned integer type.
void main() {
  setUp(() {
    debugCheckFixedWithInRange = true;
  });

  test('Int8.min is -128', () {
    check(Int8.min).equals(Int8(-128));
  });

  test('Int8.max is 127', () {
    check(Int8.max).equals(Int8(127));
  });

  test('Int8.width is 8', () {
    check(Int8.width).equals(8);
  });

  group('Int8.new', () {
    test('returns normally in range', () {
      for (var i = Int8.min.toInt(); i <= Int8.max.toInt(); i++) {
        check(() => Int8(i), because: '$i is in range')
            .returnsNormally()
            .has((a) => a.toInt(), 'toInt()')
            .equals(i);
      }
    });

    test('throws on underflow', () {
      if (assertionsEnabled) {
        check(() => Int8(-129)).throws<Error>();
      } else {
        check(() => Int8(-129)).returnsNormally().equals(Int8(127));
      }
    });

    test('throws on overflow', () {
      if (assertionsEnabled) {
        check(() => Int8(128)).throws<Error>();
      } else {
        check(() => Int8(128)).returnsNormally().equals(Int8(-128));
      }
    });

    test('wraps on underflow', () {
      debugCheckFixedWithInRange = false;
      check(Int8(-129)).equals(Int8(127));
    });

    test('wraps on overflow', () {
      debugCheckFixedWithInRange = false;
      check(Int8(128)).equals(Int8(-128));
    });
  });

  group('Int8.fromWrapped', () {
    test('returns normally in range', () {
      check(Int8.fromWrapped(-128)).equals(Int8(-128));
      check(Int8.fromWrapped(127)).equals(Int8(127));
    });

    test('wraps on underflow', () {
      check(Int8.fromWrapped(-129)).equals(Int8(127));
    });

    test('wraps on overflow', () {
      check(Int8.fromWrapped(128)).equals(Int8(-128));
    });
  });

  group('Int8.fromClamped', () {
    test('returns normally in range', () {
      check(Int8.fromClamped(-128)).equals(Int8(-128));
      check(Int8.fromClamped(127)).equals(Int8(127));
    });

    test('clamps on underflow', () {
      check(Int8.fromClamped(-129)).equals(Int8(-128));
    });

    test('clamps on overflow', () {
      check(Int8.fromClamped(128)).equals(Int8(127));
    });
  });

  test('Int8.fromHiLo is the inverse of .hiLo', () {
    for (var i = Int8.min; i < Int8.max; i += Int8(1)) {
      final (hi, lo) = i.hiLo;
      check(Int8.fromHiLo(hi, lo)).equals(i);
    }
  });

  test('pow that is in range', () {
    final $n2 = Int8(-2);

    check($n2.pow(4)).equals(Int8(16));
    check($n2.tryPow(4)).equals(Int8(16));
    check($n2.clampedPow(4)).equals(Int8(16));
    check($n2.wrappedPow(4)).equals(Int8(16));
  });

  test('pow that overflows', () {
    final $n2 = Int8(-2);

    if (assertionsEnabled) {
      check(() => $n2.pow(8)).throws<Error>();
    } else {
      check(() => $n2.pow(8)).returnsNormally().equals(Int8(0));
    }

    check($n2.tryPow(8)).isNull();
    check($n2.clampedPow(8)).equals(Int8(127));
    check($n2.wrappedPow(8)).equals(Int8(0));
  });

  test('sqrt', () {
    check(Int8(16)).has((p) => p.sqrt(), 'sqrt()').equals(Int8(4));
  });

  test('log without base', () {
    check(Int8(16))
        .has((p) => p.log(), 'log()')
        .equals(Int8(math.log(16).floor()));
  });

  test('log with base 6', () {
    check(Int8(16))
        .has((p) => p.log(6), 'log(6)')
        .equals(Int8(math.log(16) ~/ math.log(6)));
  });

  test('log with base 2', () {
    check(Int8(16))
        .has((p) => p.log2(), 'log2()')
        .equals(Int8(math.log(16) ~/ math.log(2)));
  });

  test('log with base 10', () {
    check(Int8(16))
        .has((p) => p.log10(), 'log10()')
        .equals(Int8(math.log(16) ~/ math.log(10)));
  });

  test('midpoint with two positive integers', () {
    check(Int8(1).midpoint(Int8(3))).equals(Int8(2));
  });

  test('midpoint with two negative integers', () {
    check(Int8(-1).midpoint(Int8(-3))).equals(Int8(-2));
  });

  test('midpoint with one positive and one negative integer', () {
    check(Int8(-1).midpoint(Int8(3))).equals(Int8(1));
  });

  group('individual bit operations', () {
    test('msb is true for negative numbers', () {
      for (var i = Int8.min; i < Int8(0); i += Int8(1)) {
        check(i).has((p) => p.msb, 'msb').isTrue();
      }
    });

    test('msb is false for non-negative numbers', () {
      for (var i = Int8(0); i < Int8.max; i += Int8(1)) {
        check(i).has((p) => p.msb, 'msb').isFalse();
      }
    });

    test('nth bit returns true for a 1 represented in binary', () {
      // An Int8 in binary is "10000000" for -128 and "01111111" for 127.
      for (var i = 0; i < 8; i++) {
        check(Int8(-128)[i]).equals(i == 7);
        check(Int8(127)[i]).equals(i != 7);
      }
    });

    test('setNthBit sets the nth bit to 1', () {
      check(Int8(0).setNthBit(0)).equals(Int8(1));
      check(Int8(0).setNthBit(1)).equals(Int8(2));
      check(Int8(0).setNthBit(2)).equals(Int8(4));
      check(Int8(0).setNthBit(3)).equals(Int8(8));
      check(Int8(0).setNthBit(4)).equals(Int8(16));
      check(Int8(0).setNthBit(5)).equals(Int8(32));
      check(Int8(0).setNthBit(6)).equals(Int8(64));
      check(Int8(0).setNthBit(7)).equals(Int8(-128));
    });

    test('toggleNthBit toggles the nth bit', () {
      check(Int8(0).toggleNthBit(0)).equals(Int8(1));
      check(Int8(1).toggleNthBit(0)).equals(Int8(0));
      check(Int8(0).toggleNthBit(1)).equals(Int8(2));
      check(Int8(2).toggleNthBit(1)).equals(Int8(0));
      check(Int8(0).toggleNthBit(2)).equals(Int8(4));
      check(Int8(4).toggleNthBit(2)).equals(Int8(0));
      check(Int8(0).toggleNthBit(3)).equals(Int8(8));
      check(Int8(8).toggleNthBit(3)).equals(Int8(0));
      check(Int8(0).toggleNthBit(4)).equals(Int8(16));
      check(Int8(16).toggleNthBit(4)).equals(Int8(0));
      check(Int8(0).toggleNthBit(5)).equals(Int8(32));
      check(Int8(32).toggleNthBit(5)).equals(Int8(0));
      check(Int8(0).toggleNthBit(6)).equals(Int8(64));
      check(Int8(64).toggleNthBit(6)).equals(Int8(0));
      check(Int8(0).toggleNthBit(7)).equals(Int8(-128));
    });
  });

  test('nextPowerOf2 in range', () {
    final $1 = Int8(1);
    final $2 = Int8(2);
    final $63 = Int8(63);
    final $64 = Int8(64);

    check($1).has((p) => p.nextPowerOf2(), 'nextPowerOf2').equals($1);
    check($2).has((p) => p.nextPowerOf2(), 'nextPowerOf2').equals($2);
    check($63).has((p) => p.nextPowerOf2(), 'nextPowerOf2').equals($64);

    check($1).has((p) => p.tryNextPowerOf2(), 'nextPowerOf2').equals($1);
    check($2).has((p) => p.tryNextPowerOf2(), 'nextPowerOf2').equals($2);
    check($63).has((p) => p.tryNextPowerOf2(), 'nextPowerOf2').equals($64);

    check($1).has((p) => p.clampedNextPowerOf2(), 'nextPowerOf2').equals($1);
    check($2).has((p) => p.clampedNextPowerOf2(), 'nextPowerOf2').equals($2);
    check($63).has((p) => p.clampedNextPowerOf2(), 'nextPowerOf2').equals($64);

    check($1).has((p) => p.wrappedNextPowerOf2(), 'nextPowerOf2').equals($1);
    check($2).has((p) => p.wrappedNextPowerOf2(), 'nextPowerOf2').equals($2);
    check($63).has((p) => p.wrappedNextPowerOf2(), 'nextPowerOf2').equals($64);
  });

  test('nextPowerOf2 overflows', () {
    final $127 = Int8(127);

    if (assertionsEnabled) {
      check($127).has((p) => p.nextPowerOf2, 'nextPowerOf2').throws<Error>();
    } else {
      check($127)
          .has((p) => p.nextPowerOf2(), 'nextPowerOf2')
          .equals(Int8(-128));
    }

    check($127).has((p) => p.tryNextPowerOf2(), 'nextPowerOf2').isNull();
    check($127)
        .has((p) => p.clampedNextPowerOf2(), 'nextPowerOf2')
        .equals($127);
    check($127)
        .has((p) => p.wrappedNextPowerOf2(), 'nextPowerOf2')
        .equals(Int8(-128));
  });

  test('nextMultipleOf in range', () {
    final $1 = Int8(1);
    final $2 = Int8(2);
    final $63 = Int8(63);
    final $64 = Int8(64);

    check($1).has((p) => p.nextMultipleOf($1), 'nextMultipleOf').equals($1);
    check($2).has((p) => p.nextMultipleOf($2), 'nextMultipleOf').equals($2);
    check($63).has((p) => p.nextMultipleOf($64), 'nextMultipleOf').equals($64);

    check($1).has((p) => p.tryNextMultipleOf($1), 'nextMultipleOf').equals($1);
    check($2).has((p) => p.tryNextMultipleOf($2), 'nextMultipleOf').equals($2);
    check($63)
        .has((p) => p.tryNextMultipleOf($64), 'nextMultipleOf')
        .equals($64);

    check($1)
        .has((p) => p.clampedNextMultipleOf($1), 'nextMultipleOf')
        .equals($1);
    check($2)
        .has((p) => p.clampedNextMultipleOf($2), 'nextMultipleOf')
        .equals($2);
    check($63)
        .has((p) => p.clampedNextMultipleOf($64), 'nextMultipleOf')
        .equals($64);

    check($1)
        .has((p) => p.wrappedNextMultipleOf($1), 'nextMultipleOf')
        .equals($1);
    check($2)
        .has((p) => p.wrappedNextMultipleOf($2), 'nextMultipleOf')
        .equals($2);
    check($63)
        .has((p) => p.wrappedNextMultipleOf($64), 'nextMultipleOf')
        .equals($64);
  });

  test('nextMultipleOf overflows', () {
    if (assertionsEnabled) {
      check(() => Int8.max.nextMultipleOf(Int8(2))).throws<Error>();
    } else {
      check(() => Int8.max.nextMultipleOf(Int8(2)))
          .returnsNormally()
          .equals(Int8(-128));
    }

    check(Int8.max.tryNextMultipleOf(Int8(2))).isNull();
    check(Int8.max.clampedNextMultipleOf(Int8(2))).equals(Int8(127));
    check(Int8.max.wrappedNextMultipleOf(Int8(2))).equals(Int8(-128));
  });

  test('countOnes', () {
    final i1 = int.parse('01111111', radix: 2);
    check(Int8(i1).countOnes()).equals(7);

    final i2 = int.parse('01010101', radix: 2);
    check(Int8(i2).countOnes()).equals(4);

    final i3 = int.parse('10000000', radix: 2).toSigned(8);
    check(Int8(i3).countOnes()).equals(1);
  });

  test('countTrailingOnes', () {
    final i1 = int.parse('00001111', radix: 2);
    check(Int8(i1).countTrailingOnes()).equals(4);

    final i2 = int.parse('01111101', radix: 2);
    check(Int8(i2).countTrailingOnes()).equals(1);
  });

  test('countZeros', () {
    final i1 = int.parse('01000000', radix: 2);
    check(Int8(i1).countZeros()).equals(7);

    final i2 = int.parse('01010101', radix: 2);
    check(Int8(i2).countZeros()).equals(4);
  });

  test('countLeadingZeros', () {
    final i1 = int.parse('00000001', radix: 2);
    check(Int8(i1).countLeadingZeros()).equals(7);

    final i2 = int.parse('01010101', radix: 2);
    check(Int8(i2).countLeadingZeros()).equals(1);
  });

  test('countTrailingZeros', () {
    final i1 = int.parse('00000001', radix: 2);
    check(Int8(i1).countTrailingZeros()).equals(0);

    final i2 = int.parse('01010100', radix: 2);
    check(Int8(i2).countTrailingZeros()).equals(2);
  });

  group('bit slice and range operations', () {
    test('should return the last 4 bits, left-padded with 0s', () {
      final i1 = int.parse('01111111', radix: 2);
      //                    ^^^^
      final s1 = Int8(i1).bitChunk(4).toBinaryString();
      check(s1).equals('00000111');
    });

    test('should return the first 4 bits', () {
      final i1 = int.parse('01111111', radix: 2);
      //                        ^^^^
      final s1 = Int8(i1).bitChunk(0, 4).toBinaryString();
      check(s1).equals('00001111');
    });

    test('should return the middle 4 bits', () {
      final i1 = int.parse('01111111', radix: 2);
      //                      ^^^^
      final s1 = Int8(i1).bitChunk(2, 4).toBinaryString();
      check(s1).equals('00001111');
    });

    test('should use slice to get the last 4 bits', () {
      final i1 = int.parse('01111111', radix: 2);
      //                    ^^^^
      final s1 = Int8(i1).bitSlice(4).toBinaryString();
      check(s1).equals('00000111');
    });

    test('should use slice to get the first 4 bits', () {
      final i1 = int.parse('01111111', radix: 2);
      //                        ^^^^
      final s1 = Int8(i1).bitSlice(0, 3).toBinaryString();
      check(s1).equals('00001111');
    });

    test('should use slice to get the middle 4 bits', () {
      final i1 = int.parse('01111111', radix: 2);
      //                      ^^^^
      final s1 = Int8(i1).bitSlice(2, 5).toBinaryString();
      check(s1).equals('00001111');
    });

    test('should replace the first 4 bits with 1010', () {
      final i1 = int.parse('01111111', radix: 2);
      //                        ^^^^
      final i2 = int.parse('1010', radix: 2);
      final s1 = Int8(i1).bitReplace(0, 3, i2).toBinaryString();
      check(s1).equals('01111010');
    });

    test('should replace the 3 of the last 4 bits with 101', () {
      final i1 = int.parse('01111111', radix: 2);
      //                     ^^^
      final i2 = int.parse('101', radix: 2);
      final s1 = Int8(i1).bitReplace(4, 7, i2).toBinaryString();
      check(s1).equals('01011111');
    });

    test('rotate bits to the right by 1', () {
      final i1 = int.parse('01111111', radix: 2);
      //                    ^0111111
      final s1 = Int8(i1).rotateRight(1).toBinaryString();
      check(s1).equals('10111111');
    });

    test('rotate bits to the right by 4', () {
      final i1 = int.parse('01111111', radix: 2);
      //                    ^0111
      final s1 = Int8(i1).rotateRight(4).toBinaryString();
      check(s1).equals('11110111');
    });

    test('rotate bits to the left by 1', () {
      final i1 = int.parse('01111111', radix: 2);
      //                    0111111^
      final s1 = Int8(i1).rotateLeft(1).toBinaryString();
      check(s1).equals('11111110');
    });

    test('rotate bits to the left by 4', () {
      final i1 = int.parse('01111111', radix: 2);
      //                    0111^111
      final s1 = Int8(i1).rotateLeft(4).toBinaryString();
      check(s1).equals('11110111');
    });
  });

  group('abs', () {
    test('should return the absolute value', () {
      check(Int8(-1).abs()).equals(Int8(1));
      check(Int8(1).abs()).equals(Int8(1));
    });

    test('should catch overflows', () {
      if (assertionsEnabled) {
        check(() => Int8.min.abs()).throws<Error>();
      } else {
        check(() => Int8.min.abs()).returnsNormally().equals(Int8.min);
      }
    });
  });

  test('isMin', () {
    check(Int8.min).has((p) => p.isMin, 'isMin').isTrue();
    check(Int8.max).has((p) => p.isMin, 'isMin').isFalse();
  });

  test('isMax', () {
    check(Int8.min).has((p) => p.isMax, 'isMax').isFalse();
    check(Int8.max).has((p) => p.isMax, 'isMax').isTrue();
  });

  test('bitLength', () {
    check(Int8(0)).has((p) => p.bitLength, 'bitLength').equals(0);
    check(Int8(1)).has((p) => p.bitLength, 'bitLength').equals(1);
    check(Int8(2)).has((p) => p.bitLength, 'bitLength').equals(2);
    check(Int8.max).has((p) => p.bitLength, 'bitLength').equals(7);
    check(Int8.min).has((p) => p.bitLength, 'bitLength').equals(7);
  });

  test('isEven', () {
    check(Int8(0)).has((p) => p.isEven, 'isEven').isTrue();
    check(Int8(1)).has((p) => p.isEven, 'isEven').isFalse();
    check(Int8(2)).has((p) => p.isEven, 'isEven').isTrue();
    check(Int8(-1)).has((p) => p.isEven, 'isEven').isFalse();
    check(Int8(-2)).has((p) => p.isEven, 'isEven').isTrue();
  });

  test('isOdd', () {
    check(Int8(0)).has((p) => p.isOdd, 'isOdd').isFalse();
    check(Int8(1)).has((p) => p.isOdd, 'isOdd').isTrue();
    check(Int8(2)).has((p) => p.isOdd, 'isOdd').isFalse();
    check(Int8(-1)).has((p) => p.isOdd, 'isOdd').isTrue();
    check(Int8(-2)).has((p) => p.isOdd, 'isOdd').isFalse();
  });

  test('sign', () {
    check(Int8(0)).has((p) => p.sign, 'sign').equals(Int8(0));
    check(Int8(1)).has((p) => p.sign, 'sign').equals(Int8(1));
    check(Int8(-1)).has((p) => p.sign, 'sign').equals(Int8(-1));
  });

  test('isZero', () {
    check(Int8(0)).has((p) => p.isZero, 'isZero').isTrue();
    check(Int8(1)).has((p) => p.isZero, 'isZero').isFalse();
    check(Int8(-1)).has((p) => p.isZero, 'isZero').isFalse();
  });

  test('isNegative', () {
    check(Int8(0)).has((p) => p.isNegative, 'isNegative').isFalse();
    check(Int8(1)).has((p) => p.isNegative, 'isNegative').isFalse();
    check(Int8(-1)).has((p) => p.isNegative, 'isNegative').isTrue();
  });

  test('isPositive', () {
    check(Int8(0)).has((p) => p.isPositive, 'isPositive').isFalse();
    check(Int8(1)).has((p) => p.isPositive, 'isPositive').isTrue();
    check(Int8(-1)).has((p) => p.isPositive, 'isPositive').isFalse();
  });

  test('clamp', () {
    check(Int8(0))
        .has((p) => p.clamp(Int8(1), Int8(2)), 'clamp')
        .equals(Int8(1));
    check(Int8(1))
        .has((p) => p.clamp(Int8(1), Int8(2)), 'clamp')
        .equals(Int8(1));
    check(Int8(2))
        .has((p) => p.clamp(Int8(1), Int8(2)), 'clamp')
        .equals(Int8(2));
    check(Int8(3))
        .has((p) => p.clamp(Int8(1), Int8(2)), 'clamp')
        .equals(Int8(2));
  });

  test('remainder', () {
    check(Int8(0))
        .has((p) => p.remainder(Int8(1)), 'remainder')
        .equals(Int8(0));
    check(Int8(1))
        .has((p) => p.remainder(Int8(1)), 'remainder')
        .equals(Int8(0));
    check(Int8(2))
        .has((p) => p.remainder(Int8(1)), 'remainder')
        .equals(Int8(0));
    check(Int8(3))
        .has((p) => p.remainder(Int8(1)), 'remainder')
        .equals(Int8(0));

    // Try some negative numbers.
    check(Int8(-1))
        .has((p) => p.remainder(Int8(1)), 'remainder')
        .equals(Int8(0));
    check(Int8(-2))
        .has((p) => p.remainder(Int8(1)), 'remainder')
        .equals(Int8(0));
  });

  test('toDouble', () {
    check(Int8(0)).has((p) => p.toDouble(), 'toDouble').equals(0.0);
    check(Int8(1)).has((p) => p.toDouble(), 'toDouble').equals(1.0);
    check(Int8(-1)).has((p) => p.toDouble(), 'toDouble').equals(-1.0);
  });

  test('operator %', () {
    check(Int8(0)).has((p) => p % Int8(1), 'operator %').equals(Int8(0));
    check(Int8(1)).has((p) => p % Int8(1), 'operator %').equals(Int8(0));
    check(Int8(2)).has((p) => p % Int8(1), 'operator %').equals(Int8(0));
    check(Int8(3)).has((p) => p % Int8(1), 'operator %').equals(Int8(0));

    // Try some negative numbers.
    check(Int8(-1)).has((p) => p % Int8(1), 'operator %').equals(Int8(0));
    check(Int8(-2)).has((p) => p % Int8(1), 'operator %').equals(Int8(0));
  });

  group('operator *', () {
    test('in range, two positive numbers', () {
      final $2 = Int8(2);
      final $3 = Int8(3);
      check($2 * $3).equals(Int8(6));
      check($2.tryMultiply($3)).equals(Int8(6));
      check($2.clampedMultiply($3)).equals(Int8(6));
      check($2.wrappedMultiply($3)).equals(Int8(6));
    });

    test('in range, two negative numbers', () {
      final $2 = Int8(-2);
      final $3 = Int8(-3);
      check($2 * $3).equals(Int8(6));
      check($2.tryMultiply($3)).equals(Int8(6));
      check($2.clampedMultiply($3)).equals(Int8(6));
      check($2.wrappedMultiply($3)).equals(Int8(6));
    });

    test('in range, one positive and one negative number', () {
      final $2 = Int8(2);
      final $3 = Int8(-3);
      check($2 * $3).equals(Int8(-6));
      check($2.tryMultiply($3)).equals(Int8(-6));
      check($2.clampedMultiply($3)).equals(Int8(-6));
      check($2.wrappedMultiply($3)).equals(Int8(-6));
    });

    test('overflows, two positive numbers', () {
      final $64 = Int8(64);
      final $2 = Int8(2);

      if (assertionsEnabled) {
        check(() => $64 * $2).throws<Error>();
      } else {
        check(() => $64 * $2).returnsNormally().equals(Int8(-128));
      }

      check($64.tryMultiply($2)).isNull();
      check($64.clampedMultiply($2)).equals(Int8(127));
      check($64.wrappedMultiply($2)).equals(Int8(-128));
    });

    test('overflows, two negative numbers', () {
      final $64 = Int8(-64);
      final $2 = Int8(-2);

      if (assertionsEnabled) {
        check(() => $64 * $2).throws<Error>();
      } else {
        check(() => $64 * $2).returnsNormally().equals(Int8(-128));
      }

      check($64.tryMultiply($2)).isNull();
      check($64.clampedMultiply($2)).equals(Int8(127));
      check($64.wrappedMultiply($2)).equals(Int8(-128));
    });

    test('overflows, one positive and one negative number', () {
      final $64 = Int8(64);
      final $3 = Int8(-3);

      if (assertionsEnabled) {
        check(() => $64 * $3).throws<Error>();
      } else {
        check(() => $64 * $3).returnsNormally().equals(Int8(64));
      }

      check($64.tryMultiply($3)).isNull();
      check($64.clampedMultiply($3)).equals(Int8(-128));
      check($64.wrappedMultiply($3)).equals(Int8(64));
    });
  });
}
