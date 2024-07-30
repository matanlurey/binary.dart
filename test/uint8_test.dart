import 'package:binary/binary.dart';
import 'package:test/test.dart';

import 'src/prelude.dart';

void main() {
  setUp(() {
    // Reset the debugCheckFixedWithInRange variable to true if toggled off.
    debugCheckFixedWithInRange = true;
  });

  test('min is 0', () {
    check(Uint8.min).equals(Uint8(0));
  });

  test('max is 255', () {
    check(Uint8.max).equals(Uint8(255));
  });

  test('width is 8', () {
    check(Uint8.width).equals(8);
  });

  test('Uint8.new is OK with a valid value', () {
    check(() => Uint8(128)).returnsNormally().equals(Uint8(128));
  });

  test('Uint8.new when out of range throws an assertion error', () {
    check(() => Uint8(256)).throws<AssertionError>();
  });

  test('Uint8.new in production mode wraps the value', () {
    debugCheckFixedWithInRange = false;
    check(Uint8(256)).equals(Uint8(0));
  });

  test('Uint8.fromUnchecked allows invalid values', () {
    check(Uint8.fromUnchecked(256)).has((a) => a.value, 'value').equals(256);
  });

  test('Uint8.tryFrom returns null when out of range', () {
    check(Uint8.tryFrom(256)).isNull();
  });

  test('Uint8.fromWrapped wraps the value', () {
    check(Uint8.fromWrapped(-3)).equals(Uint8(253));
    check(Uint8.fromWrapped(300)).equals(Uint8(44));
  });

  test('Uint8.fromClamped clamps the value', () {
    check(Uint8.fromClamped(-3)).equals(Uint8(0));
    check(Uint8.fromClamped(300)).equals(Uint8(255));
  });
}
