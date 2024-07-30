import 'package:binary/binary.dart';
import 'package:test/test.dart';

import 'src/prelude.dart';

void main() {
  setUp(() {
    // Reset the debugCheckFixedWithInRange variable to true if toggled off.
    debugCheckFixedWithInRange = true;
  });

  test('min is -128', () {
    check(Int8.min).equals(Int8(-128));
  });

  test('max is 127', () {
    check(Int8.max).equals(Int8(127));
  });

  test('width is 8', () {
    check(Int8.width).equals(8);
  });

  test('Int8.new is OK with a valid value', () {
    check(() => Int8(127)).returnsNormally().equals(Int8(127));
  });

  test('Int8.new when out of range throws an assertion error', () {
    check(() => Int8(256)).throws<AssertionError>();
  });

  test('Int8.new in production mode wraps the value', () {
    debugCheckFixedWithInRange = false;
    check(Int8(256)).equals(Int8(0));
  });

  test('Int8.tryFrom returns null when out of range', () {
    check(Int8.tryFrom(256)).isNull();
  });

  test('Int8.fromWrapped wraps the value', () {
    check(Int8.fromWrapped(-3)).equals(Int8(-3));
    check(Int8.fromWrapped(129)).equals(Int8(-127));
  });

  test('Int8.fromClamped clamps the value', () {
    check(Int8.fromClamped(-3)).equals(Int8(-3));
    check(Int8.fromClamped(129)).equals(Int8(127));
  });

  test('Int8.fromHiLo creates a value from high and low parts', () {
    check(Int8.fromHiLo(-5, 15)).equals(Int8(-65));
  });

  test('Int8.hiLo returns the high and low parts of a value', () {
    check(Int8(-65).hiLo).equals((-5, 15));
  });

  group('pow', () {
    test('pow(2, 0) is 1', () {
      check(Int8(2).pow(0)).equals(Int8(1));
    });

    test('pow(2, 1) is 2', () {
      check(Int8(2).pow(1)).equals(Int8(2));
    });

    test('pow(2, 2) is 4', () {
      check(Int8(2).pow(2)).equals(Int8(4));
    });

    test('pow(2, 3) is 8', () {
      check(Int8(2).pow(3)).equals(Int8(8));
    });

    test('pow(2, 4) is 16', () {
      check(Int8(2).pow(4)).equals(Int8(16));
    });
  });

  group('uncheckedPow', () {
    test('uncheckedPow(2, 0) is 1', () {
      check(Int8(2).uncheckedPow(0)).equals(Int8(1));
    });

    test('uncheckedPow(2, 1) is 2', () {
      check(Int8(2).uncheckedPow(1)).equals(Int8(2));
    });

    test('uncheckedPow(2, 2) is 4', () {
      check(Int8(2).uncheckedPow(2)).equals(Int8(4));
    });

    test('uncheckedPow(2, 3) is 8', () {
      check(Int8(2).uncheckedPow(3)).equals(Int8(8));
    });

    test('uncheckedPow(2, 4) is 16', () {
      check(Int8(2).uncheckedPow(4)).equals(Int8(16));
    });
  });

  group('tryPow', () {
    test('tryPow(2, 0) is 1', () {
      check(Int8(2).tryPow(0)).equals(Int8(1));
    });

    test('tryPow(2, 1) is 2', () {
      check(Int8(2).tryPow(1)).equals(Int8(2));
    });

    test('tryPow(2, 2) is 4', () {
      check(Int8(2).tryPow(2)).equals(Int8(4));
    });

    test('tryPow(2, 3) is 8', () {
      check(Int8(2).tryPow(3)).equals(Int8(8));
    });

    test('tryPow(2, 4) is 16', () {
      check(Int8(2).tryPow(4)).equals(Int8(16));
    });

    test('tryPow(2, 8) is null', () {
      check(Int8(2).tryPow(8)).isNull();
    });
  });

  group('wrappedPow', () {
    test('wrappedPow(2, 0) is 1', () {
      check(Int8(2).wrappedPow(0)).equals(Int8(1));
    });

    test('wrappedPow(2, 1) is 2', () {
      check(Int8(2).wrappedPow(1)).equals(Int8(2));
    });

    test('wrappedPow(2, 2) is 4', () {
      check(Int8(2).wrappedPow(2)).equals(Int8(4));
    });

    test('wrappedPow(2, 3) is 8', () {
      check(Int8(2).wrappedPow(3)).equals(Int8(8));
    });

    test('wrappedPow(2, 4) is 16', () {
      check(Int8(2).wrappedPow(4)).equals(Int8(16));
    });

    test('wrappedPow(2, 8) is 0', () {
      check(Int8(2).wrappedPow(8)).equals(Int8(0));
    });
  });

  group('clampedPow', () {
    test('clampedPow(2, 0) is 1', () {
      check(Int8(2).clampedPow(0)).equals(Int8(1));
    });

    test('clampedPow(2, 1) is 2', () {
      check(Int8(2).clampedPow(1)).equals(Int8(2));
    });

    test('clampedPow(2, 2) is 4', () {
      check(Int8(2).clampedPow(2)).equals(Int8(4));
    });

    test('clampedPow(2, 3) is 8', () {
      check(Int8(2).clampedPow(3)).equals(Int8(8));
    });

    test('clampedPow(2, 4) is 16', () {
      check(Int8(2).clampedPow(4)).equals(Int8(16));
    });
  });

  group('sqrt', () {
    test('sqrt(0) is 0', () {
      check(Int8(0).sqrt()).equals(Int8(0));
    });

    test('sqrt(1) is 1', () {
      check(Int8(1).sqrt()).equals(Int8(1));
    });

    test('sqrt(2) is 1', () {
      check(Int8(2).sqrt()).equals(Int8(1));
    });

    test('sqrt(3) is 1', () {
      check(Int8(3).sqrt()).equals(Int8(1));
    });

    test('sqrt(4) is 2', () {
      check(Int8(4).sqrt()).equals(Int8(2));
    });

    test('sqrt(5) is 2', () {
      check(Int8(5).sqrt()).equals(Int8(2));
    });

    test('sqrt(6) is 2', () {
      check(Int8(6).sqrt()).equals(Int8(2));
    });

    test('sqrt(7) is 2', () {
      check(Int8(7).sqrt()).equals(Int8(2));
    });

    test('sqrt(8) is 2', () {
      check(Int8(8).sqrt()).equals(Int8(2));
    });

    test('sqrt(9) is 3', () {
      check(Int8(9).sqrt()).equals(Int8(3));
    });
  });

  group('log', () {
    test('log(1) is 0', () {
      check(Int8(1).log(2)).equals(Int8(0));
    });

    test('log(2) is 1', () {
      check(Int8(2).log(2)).equals(Int8(1));
    });

    test('log(3) is 1', () {
      check(Int8(3).log(2)).equals(Int8(1));
    });

    test('log(4) is 2', () {
      check(Int8(4).log(2)).equals(Int8(2));
    });

    test('log(5) is 2', () {
      check(Int8(5).log(2)).equals(Int8(2));
    });

    test('log(6) is 2', () {
      check(Int8(6).log(2)).equals(Int8(2));
    });

    test('log(7) is 2', () {
      check(Int8(7).log(2)).equals(Int8(2));
    });

    test('log(8) is 3', () {
      check(Int8(8).log(2)).equals(Int8(3));
    });
  });

  group('log2', () {
    test('log2(1) is 0', () {
      check(Int8(1).log2()).equals(Int8(0));
    });

    test('log2(2) is 1', () {
      check(Int8(2).log2()).equals(Int8(1));
    });

    test('log2(3) is 1', () {
      check(Int8(3).log2()).equals(Int8(1));
    });

    test('log2(4) is 2', () {
      check(Int8(4).log2()).equals(Int8(2));
    });

    test('log2(5) is 2', () {
      check(Int8(5).log2()).equals(Int8(2));
    });

    test('log2(6) is 2', () {
      check(Int8(6).log2()).equals(Int8(2));
    });

    test('log2(7) is 2', () {
      check(Int8(7).log2()).equals(Int8(2));
    });

    test('log2(8) is 3', () {
      check(Int8(8).log2()).equals(Int8(3));
    });
  });

  group('log10', () {
    test('log10(1) is 0', () {
      check(Int8(1).log10()).equals(Int8(0));
    });

    test('log10(2) is 0', () {
      check(Int8(2).log10()).equals(Int8(0));
    });

    test('log10(3) is 0', () {
      check(Int8(3).log10()).equals(Int8(0));
    });

    test('log10(4) is 0', () {
      check(Int8(4).log10()).equals(Int8(0));
    });

    test('log10(5) is 0', () {
      check(Int8(5).log10()).equals(Int8(0));
    });

    test('log10(6) is 0', () {
      check(Int8(6).log10()).equals(Int8(0));
    });

    test('log10(7) is 0', () {
      check(Int8(7).log10()).equals(Int8(0));
    });

    test('log10(8) is 0', () {
      check(Int8(8).log10()).equals(Int8(0));
    });

    test('log10(9) is 0', () {
      check(Int8(9).log10()).equals(Int8(0));
    });
  });

  group('midpoint', () {
    test('midpoint(0, 0) is 0', () {
      check(Int8(0).midpoint(Int8(0))).equals(Int8(0));
    });

    test('midpoint(0, 1) is 0', () {
      check(Int8(0).midpoint(Int8(1))).equals(Int8(0));
    });

    test('midpoint(1, 0) is 0', () {
      check(Int8(1).midpoint(Int8(0))).equals(Int8(0));
    });

    test('midpoint(1, 1) is 1', () {
      check(Int8(1).midpoint(Int8(1))).equals(Int8(1));
    });

    test('midpoint(-50, 50) is 0', () {
      check(Int8(-50).midpoint(Int8(50))).equals(Int8(0));
    });

    test('midpoint(-30, -10) is -20', () {
      check(Int8(-30).midpoint(Int8(-10))).equals(Int8(-20));
    });
  });

  group('bits iterable', () {
    test('bits for 0xF is 1111', () {
      check(
        Int8(0xF).bits,
      ).deepEquals([true, true, true, true, false, false, false, false]);
    });
  });

  group('nthBit', () {
    test('nthBit(0) for 0xF is true', () {
      check(Int8(0xF)[0]).isTrue();
    });

    test('nthBit(1) for 0xF is true', () {
      check(Int8(0xF)[1]).isTrue();
    });

    test('nthBit(2) for 0xF is true', () {
      check(Int8(0xF)[2]).isTrue();
    });

    test('nthBit(3) for 0xF is true', () {
      check(Int8(0xF)[3]).isTrue();
    });

    test('nthBit(4) for 0xF is false', () {
      check(Int8(0xF)[4]).isFalse();
    });

    test('nthBit(5) for 0xF is false', () {
      check(Int8(0xF)[5]).isFalse();
    });

    test('nthBit(6) for 0xF is false', () {
      check(Int8(0xF)[6]).isFalse();
    });

    test('nthBit(7) for 0xF is false', () {
      check(Int8(0xF)[7]).isFalse();
    });
  });

  group('msb', () {
    test('msb for 0 is false', () {
      check(Int8(0).msb).isFalse();
    });

    test('msb for 1 is false', () {
      check(Int8(1).msb).isFalse();
    });

    test('msb for 2 is false', () {
      check(Int8(2).msb).isFalse();
    });

    test('msb for 3 is false', () {
      check(Int8(3).msb).isFalse();
    });

    test('msb for 4 is false', () {
      check(Int8(4).msb).isFalse();
    });

    test('msb for 5 is false', () {
      check(Int8(5).msb).isFalse();
    });

    test('msb for 6 is false', () {
      check(Int8(6).msb).isFalse();
    });

    test('msb for 7 is false', () {
      check(Int8(7).msb).isFalse();
    });

    test('msb for 8 is false', () {
      check(Int8(8).msb).isFalse();
    });

    test('msb for 127 is false', () {
      check(Int8(127).msb).isFalse();
    });

    test('msb for -4 is true', () {
      check(Int8(-4).msb).isTrue();
    });
  });

  group('setNthBit', () {
    test('setNthBit(0) for 0 is 1', () {
      check(Int8(0).setNthBit(0)).equals(Int8(1));
    });

    test('setNthBit(1) for 0 is 2', () {
      check(Int8(0).setNthBit(1)).equals(Int8(2));
    });

    test('setNthBit(2) for 0 is 4', () {
      check(Int8(0).setNthBit(2)).equals(Int8(4));
    });

    test('setNthBit(3) for 0 is 8', () {
      check(Int8(0).setNthBit(3)).equals(Int8(8));
    });

    test('setNthBit(4) for 0 is 16', () {
      check(Int8(0).setNthBit(4)).equals(Int8(16));
    });

    test('setNthBit(5) for 0 is 32', () {
      check(Int8(0).setNthBit(5)).equals(Int8(32));
    });

    test('setNthBit(6) for 0 is 64', () {
      check(Int8(0).setNthBit(6)).equals(Int8(64));
    });
  });

  group('toggleNthBit', () {
    test('toggleNthBit(0) for 0 is 1', () {
      check(Int8(0).toggleNthBit(0)).equals(Int8(1));
    });

    test('toggleNthBit(1) for 0 is 2', () {
      check(Int8(0).toggleNthBit(1)).equals(Int8(2));
    });

    test('toggleNthBit(2) for 0 is 4', () {
      check(Int8(0).toggleNthBit(2)).equals(Int8(4));
    });

    test('toggleNthBit(3) for 0 is 8', () {
      check(Int8(0).toggleNthBit(3)).equals(Int8(8));
    });

    test('toggleNthBit(4) for 0 is 16', () {
      check(Int8(0).toggleNthBit(4)).equals(Int8(16));
    });

    test('toggleNthBit(5) for 0 is 32', () {
      check(Int8(0).toggleNthBit(5)).equals(Int8(32));
    });

    test('toggleNthBit(6) for 0 is 64', () {
      check(Int8(0).toggleNthBit(6)).equals(Int8(64));
    });
  });

  group('nextPowerOf2', () {
    test('nextPowerOf2(0) throws', () {
      check(() => Int8(0).nextPowerOf2()).throws<Error>();
    });

    test('nextPowerOf2(1) is 1', () {
      check(Int8(1).nextPowerOf2()).equals(Int8(1));
    });

    test('nextPowerOf2(2) is 2', () {
      check(Int8(2).nextPowerOf2()).equals(Int8(2));
    });

    test('nextPowerOf2(3) is 4', () {
      check(Int8(3).nextPowerOf2()).equals(Int8(4));
    });

    test('nextPowerOf2(4) is 4', () {
      check(Int8(4).nextPowerOf2()).equals(Int8(4));
    });

    test('nextPowerOf2(5) is 8', () {
      check(Int8(5).nextPowerOf2()).equals(Int8(8));
    });

    test('nextPowerOf2(6) is 8', () {
      check(Int8(6).nextPowerOf2()).equals(Int8(8));
    });

    test('nextPowerOf2(7) is 8', () {
      check(Int8(7).nextPowerOf2()).equals(Int8(8));
    });

    test('nextPowerOf2(8) is 8', () {
      check(Int8(8).nextPowerOf2()).equals(Int8(8));
    });

    test('nextPowerOf2(9) is 16', () {
      check(Int8(9).nextPowerOf2()).equals(Int8(16));
    });
  });

  group('uncheckedNextPowerOf2', () {
    test('uncheckedNextPowerOf2(0) throws', () {
      check(() => Int8(0).uncheckedNextPowerOf2()).throws<Error>();
    });

    test('uncheckedNextPowerOf2(1) is 1', () {
      check(Int8(1).uncheckedNextPowerOf2()).equals(Int8(1));
    });

    test('uncheckedNextPowerOf2(2) is 2', () {
      check(Int8(2).uncheckedNextPowerOf2()).equals(Int8(2));
    });

    test('uncheckedNextPowerOf2(3) is 4', () {
      check(Int8(3).uncheckedNextPowerOf2()).equals(Int8(4));
    });

    test('uncheckedNextPowerOf2(4) is 4', () {
      check(Int8(4).uncheckedNextPowerOf2()).equals(Int8(4));
    });

    test('uncheckedNextPowerOf2(5) is 8', () {
      check(Int8(5).uncheckedNextPowerOf2()).equals(Int8(8));
    });

    test('uncheckedNextPowerOf2(6) is 8', () {
      check(Int8(6).uncheckedNextPowerOf2()).equals(Int8(8));
    });

    test('uncheckedNextPowerOf2(7) is 8', () {
      check(Int8(7).uncheckedNextPowerOf2()).equals(Int8(8));
    });

    test('uncheckedNextPowerOf2(8) is 8', () {
      check(Int8(8).uncheckedNextPowerOf2()).equals(Int8(8));
    });

    test('uncheckedNextPowerOf2(9) is 16', () {
      check(Int8(9).uncheckedNextPowerOf2()).equals(Int8(16));
    });
  });

  group('tryNextPowerOf2', () {
    test('tryNextPowerOf2(0) throws', () {
      check(() => Int8(0).tryNextPowerOf2()).throws<Error>();
    });

    test('tryNextPowerOf2(1) is 1', () {
      check(Int8(1).tryNextPowerOf2()).equals(Int8(1));
    });

    test('tryNextPowerOf2(2) is 2', () {
      check(Int8(2).tryNextPowerOf2()).equals(Int8(2));
    });

    test('tryNextPowerOf2(3) is 4', () {
      check(Int8(3).tryNextPowerOf2()).equals(Int8(4));
    });

    test('tryNextPowerOf2(4) is 4', () {
      check(Int8(4).tryNextPowerOf2()).equals(Int8(4));
    });

    test('tryNextPowerOf2(5) is 8', () {
      check(Int8(5).tryNextPowerOf2()).equals(Int8(8));
    });

    test('tryNextPowerOf2(6) is 8', () {
      check(Int8(6).tryNextPowerOf2()).equals(Int8(8));
    });

    test('tryNextPowerOf2(7) is 8', () {
      check(Int8(7).tryNextPowerOf2()).equals(Int8(8));
    });

    test('tryNextPowerOf2(8) is 8', () {
      check(Int8(8).tryNextPowerOf2()).equals(Int8(8));
    });
  });

  group('wrappedNextPowerOf2', () {
    test('wrappedNextPowerOf2(0) throws', () {
      check(() => Int8(0).wrappedNextPowerOf2()).throws<Error>();
    });

    test('wrappedNextPowerOf2(1) is 1', () {
      check(Int8(1).wrappedNextPowerOf2()).equals(Int8(1));
    });

    test('wrappedNextPowerOf2(2) is 2', () {
      check(Int8(2).wrappedNextPowerOf2()).equals(Int8(2));
    });

    test('wrappedNextPowerOf2(3) is 4', () {
      check(Int8(3).wrappedNextPowerOf2()).equals(Int8(4));
    });

    test('wrappedNextPowerOf2(4) is 4', () {
      check(Int8(4).wrappedNextPowerOf2()).equals(Int8(4));
    });

    test('wrappedNextPowerOf2(5) is 8', () {
      check(Int8(5).wrappedNextPowerOf2()).equals(Int8(8));
    });

    test('wrappedNextPowerOf2(6) is 8', () {
      check(Int8(6).wrappedNextPowerOf2()).equals(Int8(8));
    });

    test('wrappedNextPowerOf2(7) is 8', () {
      check(Int8(7).wrappedNextPowerOf2()).equals(Int8(8));
    });

    test('wrappedNextPowerOf2(8) is 8', () {
      check(Int8(8).wrappedNextPowerOf2()).equals(Int8(8));
    });
  });

  group('clampedNextPowerOf2', () {
    test('clampedNextPowerOf2(0) throws', () {
      check(() => Int8(0).clampedNextPowerOf2()).throws<Error>();
    });

    test('clampedNextPowerOf2(1) is 1', () {
      check(Int8(1).clampedNextPowerOf2()).equals(Int8(1));
    });

    test('clampedNextPowerOf2(2) is 2', () {
      check(Int8(2).clampedNextPowerOf2()).equals(Int8(2));
    });

    test('clampedNextPowerOf2(3) is 4', () {
      check(Int8(3).clampedNextPowerOf2()).equals(Int8(4));
    });

    test('clampedNextPowerOf2(4) is 4', () {
      check(Int8(4).clampedNextPowerOf2()).equals(Int8(4));
    });

    test('clampedNextPowerOf2(5) is 8', () {
      check(Int8(5).clampedNextPowerOf2()).equals(Int8(8));
    });

    test('clampedNextPowerOf2(6) is 8', () {
      check(Int8(6).clampedNextPowerOf2()).equals(Int8(8));
    });

    test('clampedNextPowerOf2(7) is 8', () {
      check(Int8(7).clampedNextPowerOf2()).equals(Int8(8));
    });

    test('clampedNextPowerOf2(8) is 8', () {
      check(Int8(8).clampedNextPowerOf2()).equals(Int8(8));
    });
  });

  group('nextMultipleOf', () {
    test('nextMultipleOf(0, 1) is 0', () {
      check(Int8(0).nextMultipleOf(Int8(1))).equals(Int8(0));
    });

    test('nextMultipleOf(1, 1) is 1', () {
      check(Int8(1).nextMultipleOf(Int8(1))).equals(Int8(1));
    });

    test('nextMultipleOf(2, 1) is 2', () {
      check(Int8(2).nextMultipleOf(Int8(1))).equals(Int8(2));
    });

    test('nextMultipleOf(3, 1) is 3', () {
      check(Int8(3).nextMultipleOf(Int8(1))).equals(Int8(3));
    });

    test('nextMultipleOf(4, 1) is 4', () {
      check(Int8(4).nextMultipleOf(Int8(1))).equals(Int8(4));
    });

    test('nextMultipleOf(5, 1) is 5', () {
      check(Int8(5).nextMultipleOf(Int8(1))).equals(Int8(5));
    });

    test('nextMultipleOf(6, 1) is 6', () {
      check(Int8(6).nextMultipleOf(Int8(1))).equals(Int8(6));
    });

    test('nextMultipleOf(7, 1) is 7', () {
      check(Int8(7).nextMultipleOf(Int8(1))).equals(Int8(7));
    });

    test('nextMultipleOf(8, 1) is 8', () {
      check(Int8(8).nextMultipleOf(Int8(1))).equals(Int8(8));
    });

    test('nextMultipleOf(9, 1) is 9', () {
      check(Int8(9).nextMultipleOf(Int8(1))).equals(Int8(9));
    });
  });

  group('uncheckedNextMultipleOf', () {
    test('uncheckedNextMultipleOf(0, 1) is 0', () {
      check(Int8(0).uncheckedNextMultipleOf(Int8(1))).equals(Int8(0));
    });

    test('uncheckedNextMultipleOf(1, 1) is 1', () {
      check(Int8(1).uncheckedNextMultipleOf(Int8(1))).equals(Int8(1));
    });

    test('uncheckedNextMultipleOf(2, 1) is 2', () {
      check(Int8(2).uncheckedNextMultipleOf(Int8(1))).equals(Int8(2));
    });

    test('uncheckedNextMultipleOf(3, 1) is 3', () {
      check(Int8(3).uncheckedNextMultipleOf(Int8(1))).equals(Int8(3));
    });

    test('uncheckedNextMultipleOf(4, 1) is 4', () {
      check(Int8(4).uncheckedNextMultipleOf(Int8(1))).equals(Int8(4));
    });

    test('uncheckedNextMultipleOf(5, 1) is 5', () {
      check(Int8(5).uncheckedNextMultipleOf(Int8(1))).equals(Int8(5));
    });

    test('uncheckedNextMultipleOf(6, 1) is 6', () {
      check(Int8(6).uncheckedNextMultipleOf(Int8(1))).equals(Int8(6));
    });

    test('uncheckedNextMultipleOf(7, 1) is 7', () {
      check(Int8(7).uncheckedNextMultipleOf(Int8(1))).equals(Int8(7));
    });

    test('uncheckedNextMultipleOf(8, 1) is 8', () {
      check(Int8(8).uncheckedNextMultipleOf(Int8(1))).equals(Int8(8));
    });

    test('uncheckedNextMultipleOf(9, 1) is 9', () {
      check(Int8(9).uncheckedNextMultipleOf(Int8(1))).equals(Int8(9));
    });
  });

  group('tryNextMultipleOf', () {
    test('tryNextMultipleOf(0, 1) is 0', () {
      check(Int8(0).tryNextMultipleOf(Int8(1))).equals(Int8(0));
    });

    test('tryNextMultipleOf(1, 1) is 1', () {
      check(Int8(1).tryNextMultipleOf(Int8(1))).equals(Int8(1));
    });

    test('tryNextMultipleOf(2, 1) is 2', () {
      check(Int8(2).tryNextMultipleOf(Int8(1))).equals(Int8(2));
    });

    test('tryNextMultipleOf(3, 1) is 3', () {
      check(Int8(3).tryNextMultipleOf(Int8(1))).equals(Int8(3));
    });

    test('tryNextMultipleOf(4, 1) is 4', () {
      check(Int8(4).tryNextMultipleOf(Int8(1))).equals(Int8(4));
    });

    test('tryNextMultipleOf(5, 1) is 5', () {
      check(Int8(5).tryNextMultipleOf(Int8(1))).equals(Int8(5));
    });

    test('tryNextMultipleOf(6, 1) is 6', () {
      check(Int8(6).tryNextMultipleOf(Int8(1))).equals(Int8(6));
    });

    test('tryNextMultipleOf(7, 1) is 7', () {
      check(Int8(7).tryNextMultipleOf(Int8(1))).equals(Int8(7));
    });

    test('tryNextMultipleOf(8, 1) is 8', () {
      check(Int8(8).tryNextMultipleOf(Int8(1))).equals(Int8(8));
    });

    test('tryNextMultipleOf(9, 1) is 9', () {
      check(Int8(9).tryNextMultipleOf(Int8(1))).equals(Int8(9));
    });
  });

  group('wrappedNextMultipleOf', () {
    test('wrappedNextMultipleOf(0, 1) is 0', () {
      check(Int8(0).wrappedNextMultipleOf(Int8(1))).equals(Int8(0));
    });

    test('wrappedNextMultipleOf(1, 1) is 1', () {
      check(Int8(1).wrappedNextMultipleOf(Int8(1))).equals(Int8(1));
    });

    test('wrappedNextMultipleOf(2, 1) is 2', () {
      check(Int8(2).wrappedNextMultipleOf(Int8(1))).equals(Int8(2));
    });

    test('wrappedNextMultipleOf(3, 1) is 3', () {
      check(Int8(3).wrappedNextMultipleOf(Int8(1))).equals(Int8(3));
    });

    test('wrappedNextMultipleOf(4, 1) is 4', () {
      check(Int8(4).wrappedNextMultipleOf(Int8(1))).equals(Int8(4));
    });

    test('wrappedNextMultipleOf(5, 1) is 5', () {
      check(Int8(5).wrappedNextMultipleOf(Int8(1))).equals(Int8(5));
    });

    test('wrappedNextMultipleOf(6, 1) is 6', () {
      check(Int8(6).wrappedNextMultipleOf(Int8(1))).equals(Int8(6));
    });

    test('wrappedNextMultipleOf(7, 1) is 7', () {
      check(Int8(7).wrappedNextMultipleOf(Int8(1))).equals(Int8(7));
    });

    test('wrappedNextMultipleOf(8, 1) is 8', () {
      check(Int8(8).wrappedNextMultipleOf(Int8(1))).equals(Int8(8));
    });

    test('wrappedNextMultipleOf(9, 1) is 9', () {
      check(Int8(9).wrappedNextMultipleOf(Int8(1))).equals(Int8(9));
    });
  });

  group('clampedNextMultipleOf', () {
    test('clampedNextMultipleOf(0, 1) is 0', () {
      check(Int8(0).clampedNextMultipleOf(Int8(1))).equals(Int8(0));
    });

    test('clampedNextMultipleOf(1, 1) is 1', () {
      check(Int8(1).clampedNextMultipleOf(Int8(1))).equals(Int8(1));
    });

    test('clampedNextMultipleOf(2, 1) is 2', () {
      check(Int8(2).clampedNextMultipleOf(Int8(1))).equals(Int8(2));
    });

    test('clampedNextMultipleOf(3, 1) is 3', () {
      check(Int8(3).clampedNextMultipleOf(Int8(1))).equals(Int8(3));
    });

    test('clampedNextMultipleOf(4, 1) is 4', () {
      check(Int8(4).clampedNextMultipleOf(Int8(1))).equals(Int8(4));
    });

    test('clampedNextMultipleOf(5, 1) is 5', () {
      check(Int8(5).clampedNextMultipleOf(Int8(1))).equals(Int8(5));
    });

    test('clampedNextMultipleOf(6, 1) is 6', () {
      check(Int8(6).clampedNextMultipleOf(Int8(1))).equals(Int8(6));
    });

    test('clampedNextMultipleOf(7, 1) is 7', () {
      check(Int8(7).clampedNextMultipleOf(Int8(1))).equals(Int8(7));
    });

    test('clampedNextMultipleOf(8, 1) is 8', () {
      check(Int8(8).clampedNextMultipleOf(Int8(1))).equals(Int8(8));
    });

    test('clampedNextMultipleOf(9, 1) is 9', () {
      check(Int8(9).clampedNextMultipleOf(Int8(1))).equals(Int8(9));
    });
  });

  group('countOnes', () {
    test('countOnes(0) is 0', () {
      check(Int8(0).countOnes()).equals(0);
    });

    test('countOnes(1) is 1', () {
      check(Int8(1).countOnes()).equals(1);
    });
  });

  group('countTrailingOnes', () {
    test('countTrailingOnes(0) is 0', () {
      check(Int8(0).countTrailingOnes()).equals(0);
    });

    test('countTrailingOnes(1) is 1', () {
      check(Int8(1).countTrailingOnes()).equals(1);
    });
  });

  group('countZeros', () {
    test('countZeros(0) is 8', () {
      check(Int8(0).countZeros()).equals(8);
    });

    test('countZeros(1) is 7', () {
      check(Int8(1).countZeros()).equals(7);
    });
  });

  group('countLeadingZeros', () {
    test('countLeadingZeros(0) is 8', () {
      check(Int8(0).countLeadingZeros()).equals(8);
    });

    test('countLeadingZeros(1) is 7', () {
      check(Int8(1).countLeadingZeros()).equals(7);
    });
  });

  group('countTrailingZeros', () {
    test('countTrailingZeros(0) is 8', () {
      check(Int8(0).countTrailingZeros()).equals(8);
    });

    test('countTrailingZeros(1) is 0', () {
      check(Int8(1).countTrailingZeros()).equals(0);
    });
  });

  group('bitChunk', () {
    test('bitChunk(0, 0) is 0', () {
      check(Int8(0).bitChunk(0, 0)).equals(Int8(0));
    });
  });

  group('bitSlice', () {
    test('bitSlice(0, 0) is 0', () {
      check(Int8(0).bitSlice(0, 0)).equals(Int8(0));
    });
  });

  group('rotateLeft', () {
    test('0xF.rotateLeft(0) is 0xF', () {
      check(Int8(0xF).rotateLeft(0)).equals(Int8(0xF));
    });

    test('0xF.rotateLeft(1) is 0x1E', () {
      check(Int8(0xF).rotateLeft(1)).equals(Int8(0x1E));
    });
  });

  group('rotateRight', () {
    test('0xF.rotateRight(0) is 0xF', () {
      check(Int8(0xF).rotateRight(0)).equals(Int8(0xF));
    });
  });

  test('bitLength', () {
    check(Int8(0xF).bitLength).equals(4);
  });

  test('isEven', () {
    check(Int8(0).isEven).isTrue();
    check(Int8(1).isEven).isFalse();
    check(Int8(2).isEven).isTrue();
    check(Int8(3).isEven).isFalse();
  });

  test('isOdd', () {
    check(Int8(0).isOdd).isFalse();
    check(Int8(1).isOdd).isTrue();
    check(Int8(2).isOdd).isFalse();
    check(Int8(3).isOdd).isTrue();
  });

  test('isZero', () {
    check(Int8(0).isZero).isTrue();
    check(Int8(1).isZero).isFalse();
  });

  test('isPositive', () {
    check(Int8(0).isPositive).isFalse();
    check(Int8(1).isPositive).isTrue();
  });

  test('clamp', () {
    check(Int8(0).clamp(Int8(1), Int8(2))).equals(Int8(1));
    check(Int8(1).clamp(Int8(1), Int8(2))).equals(Int8(1));
    check(Int8(2).clamp(Int8(1), Int8(2))).equals(Int8(2));
    check(Int8(3).clamp(Int8(1), Int8(2))).equals(Int8(2));
  });

  test('remainder', () {
    check(Int8(0).remainder(Int8(1))).equals(Int8(0));
    check(Int8(1).remainder(Int8(1))).equals(Int8(0));
    check(Int8(2).remainder(Int8(1))).equals(Int8(0));
    check(Int8(3).remainder(Int8(1))).equals(Int8(0));
    check(Int8(100).remainder(Int8(3))).equals(Int8(1));
  });

  test('operator %', () {
    check(Int8(0) % Int8(1)).equals(Int8(0));
    check(Int8(1) % Int8(1)).equals(Int8(0));
    check(Int8(2) % Int8(1)).equals(Int8(0));
    check(Int8(3) % Int8(1)).equals(Int8(0));
    check(Int8(100) % Int8(3)).equals(Int8(1));
  });

  test('operator *', () {
    check(Int8(0) * Int8(1)).equals(Int8(0));
    check(Int8(1) * Int8(1)).equals(Int8(1));
    check(Int8(2) * Int8(1)).equals(Int8(2));
    check(Int8(3) * Int8(1)).equals(Int8(3));
  });

  test('uncheckedMultiply', () {
    check(Int8(0).uncheckedMultiply(Int8(1))).equals(Int8(0));
    check(Int8(1).uncheckedMultiply(Int8(1))).equals(Int8(1));
    check(Int8(2).uncheckedMultiply(Int8(1))).equals(Int8(2));
    check(Int8(3).uncheckedMultiply(Int8(1))).equals(Int8(3));
  });

  test('tryMultiply', () {
    check(Int8(0).tryMultiply(Int8(1))).equals(Int8(0));
    check(Int8(1).tryMultiply(Int8(1))).equals(Int8(1));
    check(Int8(2).tryMultiply(Int8(1))).equals(Int8(2));
    check(Int8(3).tryMultiply(Int8(1))).equals(Int8(3));
    check(Int8(100).tryMultiply(Int8(3))).isNull();
  });

  test('wrappedMultiply', () {
    check(Int8(0).wrappedMultiply(Int8(1))).equals(Int8(0));
    check(Int8(1).wrappedMultiply(Int8(1))).equals(Int8(1));
    check(Int8(2).wrappedMultiply(Int8(1))).equals(Int8(2));
    check(Int8(3).wrappedMultiply(Int8(1))).equals(Int8(3));
    check(Int8(100).wrappedMultiply(Int8(3))).equals(Int8(44));
  });

  test('clampedMultiply', () {
    check(Int8(0).clampedMultiply(Int8(1))).equals(Int8(0));
    check(Int8(1).clampedMultiply(Int8(1))).equals(Int8(1));
    check(Int8(2).clampedMultiply(Int8(1))).equals(Int8(2));
    check(Int8(3).clampedMultiply(Int8(1))).equals(Int8(3));
    check(Int8(100).clampedMultiply(Int8(3))).equals(Int8(127));
  });

  test('operator +', () {
    check(Int8(0) + Int8(1)).equals(Int8(1));
    check(Int8(1) + Int8(1)).equals(Int8(2));
    check(Int8(2) + Int8(1)).equals(Int8(3));
    check(Int8(3) + Int8(1)).equals(Int8(4));
    check(Int8(100) + Int8(3)).equals(Int8(103));
  });

  test('uncheckedAdd', () {
    check(Int8(0).uncheckedAdd(Int8(1))).equals(Int8(1));
    check(Int8(1).uncheckedAdd(Int8(1))).equals(Int8(2));
    check(Int8(2).uncheckedAdd(Int8(1))).equals(Int8(3));
    check(Int8(3).uncheckedAdd(Int8(1))).equals(Int8(4));
  });

  test('tryAdd', () {
    check(Int8(0).tryAdd(Int8(1))).equals(Int8(1));
    check(Int8(1).tryAdd(Int8(1))).equals(Int8(2));
    check(Int8(2).tryAdd(Int8(1))).equals(Int8(3));
    check(Int8(3).tryAdd(Int8(1))).equals(Int8(4));
    check(Int8(100).tryAdd(Int8(100))).isNull();
  });

  test('wrappedAdd', () {
    check(Int8(0).wrappedAdd(Int8(1))).equals(Int8(1));
    check(Int8(1).wrappedAdd(Int8(1))).equals(Int8(2));
    check(Int8(2).wrappedAdd(Int8(1))).equals(Int8(3));
    check(Int8(3).wrappedAdd(Int8(1))).equals(Int8(4));
    check(Int8(100).wrappedAdd(Int8(100))).equals(Int8(-56));
  });

  test('clampedAdd', () {
    check(Int8(0).clampedAdd(Int8(1))).equals(Int8(1));
    check(Int8(1).clampedAdd(Int8(1))).equals(Int8(2));
    check(Int8(2).clampedAdd(Int8(1))).equals(Int8(3));
    check(Int8(3).clampedAdd(Int8(1))).equals(Int8(4));
    check(Int8(100).clampedAdd(Int8(100))).equals(Int8(127));
  });

  test('operator -', () {
    check(Int8(1) - Int8(1)).equals(Int8(0));
    check(Int8(2) - Int8(1)).equals(Int8(1));
    check(Int8(3) - Int8(1)).equals(Int8(2));
    check(Int8(100) - Int8(3)).equals(Int8(97));
  });

  test('uncheckedSubtract', () {
    check(Int8(1).uncheckedSubtract(Int8(1))).equals(Int8(0));
    check(Int8(2).uncheckedSubtract(Int8(1))).equals(Int8(1));
    check(Int8(3).uncheckedSubtract(Int8(1))).equals(Int8(2));
  });

  test('trySubtract', () {
    check(Int8(1).trySubtract(Int8(1))).equals(Int8(0));
    check(Int8(2).trySubtract(Int8(1))).equals(Int8(1));
    check(Int8(3).trySubtract(Int8(1))).equals(Int8(2));
    check(Int8(-100).trySubtract(Int8(100))).isNull();
  });

  test('wrappedSubtract', () {
    check(Int8(1).wrappedSubtract(Int8(1))).equals(Int8(0));
    check(Int8(2).wrappedSubtract(Int8(1))).equals(Int8(1));
    check(Int8(3).wrappedSubtract(Int8(1))).equals(Int8(2));
    check(Int8(-100).wrappedSubtract(Int8(100))).equals(Int8(56));
  });

  test('clampedSubtract', () {
    check(Int8(1).clampedSubtract(Int8(1))).equals(Int8(0));
    check(Int8(2).clampedSubtract(Int8(1))).equals(Int8(1));
    check(Int8(3).clampedSubtract(Int8(1))).equals(Int8(2));
    check(Int8(-100).clampedSubtract(Int8(100))).equals(Int8(-128));
  });

  test('operator <', () {
    check(Int8(0) < Int8(1)).isTrue();
    check(Int8(1) < Int8(1)).isFalse();
    check(Int8(2) < Int8(1)).isFalse();
  });

  test('operator <=', () {
    check(Int8(0) <= Int8(1)).isTrue();
    check(Int8(1) <= Int8(1)).isTrue();
    check(Int8(2) <= Int8(1)).isFalse();
  });

  test('operator >', () {
    check(Int8(0) > Int8(1)).isFalse();
    check(Int8(1) > Int8(1)).isFalse();
    check(Int8(2) > Int8(1)).isTrue();
  });

  test('operator >=', () {
    check(Int8(0) >= Int8(1)).isFalse();
    check(Int8(1) >= Int8(1)).isTrue();
    check(Int8(2) >= Int8(1)).isTrue();
  });

  test('operator ~/', () {
    check(Int8(0) ~/ Int8(1)).equals(Int8(0));
    check(Int8(1) ~/ Int8(1)).equals(Int8(1));
    check(Int8(2) ~/ Int8(1)).equals(Int8(2));
    check(Int8(3) ~/ Int8(2)).equals(Int8(1));
  });

  test('operator &', () {
    check(Int8(0) & Int8(1)).equals(Int8(0));
    check(Int8(1) & Int8(1)).equals(Int8(1));
    check(Int8(2) & Int8(1)).equals(Int8(0));
    check(Int8(3) & Int8(2)).equals(Int8(2));
  });

  test('operator |', () {
    check(Int8(0) | Int8(1)).equals(Int8(1));
    check(Int8(1) | Int8(1)).equals(Int8(1));
    check(Int8(2) | Int8(1)).equals(Int8(3));
    check(Int8(3) | Int8(2)).equals(Int8(3));
  });

  test('operator ^', () {
    check(Int8(0) ^ Int8(1)).equals(Int8(1));
    check(Int8(1) ^ Int8(1)).equals(Int8(0));
    check(Int8(2) ^ Int8(1)).equals(Int8(3));
    check(Int8(3) ^ Int8(2)).equals(Int8(1));
  });

  test('operator <<', () {
    check(Int8(0) << 0).equals(Int8(0));
    check(Int8(1) << 1).equals(Int8(2));
    check(Int8(2) << 1).equals(Int8(4));
    check(Int8(3) << 1).equals(Int8(6));
  });

  test('operator >>', () {
    check(Int8(0) >> 0).equals(Int8(0));
    check(Int8(2) >> 1).equals(Int8(1));
    check(Int8(4) >> 1).equals(Int8(2));
    check(Int8(6) >> 1).equals(Int8(3));
  });

  test('operator >>', () {
    check(Int8(0) >> 0).equals(Int8(0));
    check(Int8(2) >> 1).equals(Int8(1));
    check(Int8(4) >> 1).equals(Int8(2));
    check(Int8(6) >> 1).equals(Int8(3));
  });

  test('operator <<', () {
    check(Int8(0) << 0).equals(Int8(0));
    check(Int8(1) << 1).equals(Int8(2));
    check(Int8(2) << 1).equals(Int8(4));
    check(Int8(3) << 1).equals(Int8(6));
  });

  test('uncheckedShiftLeft', () {
    check(Int8(0).uncheckedShiftLeft(0)).equals(Int8(0));
    check(Int8(1).uncheckedShiftLeft(1)).equals(Int8(2));
    check(Int8(2).uncheckedShiftLeft(1)).equals(Int8(4));
    check(Int8(3).uncheckedShiftLeft(1)).equals(Int8(6));
  });

  test('tryShiftLeft', () {
    check(Int8(0).tryShiftLeft(0)).equals(Int8(0));
    check(Int8(1).tryShiftLeft(1)).equals(Int8(2));
    check(Int8(2).tryShiftLeft(1)).equals(Int8(4));
    check(Int8(3).tryShiftLeft(1)).equals(Int8(6));
    check(Int8(-128).tryShiftLeft(1)).isNull();
  });

  test('wrappedShiftLeft', () {
    check(Int8(0).wrappedShiftLeft(0)).equals(Int8(0));
    check(Int8(1).wrappedShiftLeft(1)).equals(Int8(2));
    check(Int8(2).wrappedShiftLeft(1)).equals(Int8(4));
    check(Int8(3).wrappedShiftLeft(1)).equals(Int8(6));
    check(Int8(-128).wrappedShiftLeft(1)).equals(Int8(0));
  });

  test('clampedShiftLeft', () {
    check(Int8(0).clampedShiftLeft(0)).equals(Int8(0));
    check(Int8(1).clampedShiftLeft(1)).equals(Int8(2));
    check(Int8(2).clampedShiftLeft(1)).equals(Int8(4));
    check(Int8(3).clampedShiftLeft(1)).equals(Int8(6));
    check(Int8(-128).clampedShiftLeft(1)).equals(Int8(-128));
  });
}
