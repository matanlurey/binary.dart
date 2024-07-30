import 'package:binary/binary.dart';
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
      check(Int8(-128)).equals(Int8(-128));
      check(Int8(127)).equals(Int8(127));
    });

    test('throws on underflow', () {
      check(() => Int8(-129)).throws<Error>();
    });

    test('throws on overflow', () {
      check(() => Int8(128)).throws<Error>();
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
    const result = _Int8Result.all(16);
    check(Int8(2)).checkPow(4, result);
  });

  test('pow that overflows', () {
    const result = _Int8Result.fails(
      expectedClamp: 127,
      expectedWrap: 0,
    );
    check(Int8(2)).checkPow(8, result);
  });
}

final class _Int8Result {
  const _Int8Result.fails({
    required this.expectedClamp,
    required this.expectedWrap,
  })  : expected = null,
        expectedTry = null;

  const _Int8Result.all(int expected)
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

extension on Subject<Int8> {
  void checkPow(int exponent, _Int8Result result) {
    if (result.expected case final int expected) {
      has((p) => p.pow(exponent), 'pow($exponent)').equals(
        expected as Int8,
      );
    } else {
      has((p) => () => p.pow(exponent), 'pow($exponent)').throws<Error>();
    }

    has((p) => p.tryPow(exponent), 'tryPow($exponent)').equals(
      result.expectedTry as Int8?,
    );

    has((p) => p.clampedPow(exponent), 'clampedPow($exponent)').equals(
      result.expectedClamp as Int8,
    );

    has((p) => p.wrappedPow(exponent), 'wrappedPow($exponent)').equals(
      result.expectedWrap as Int8,
    );
  }
}
