import 'package:binary/binary.dart';
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
}
