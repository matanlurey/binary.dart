import 'package:binary/binary.dart' show Int32, Uint32, Uint8;

import 'src/prelude.dart';

/// A minimal suite that checks wrap semantics independent of the larger tests.
void main() {
  test('handles wrapping a Uint8 after a + as expected', () {
    final n = Uint8.max;
    final q = n.wrappedAdd(Uint8(1));
    check(q).has((a) => a.toInt(), 'toInt()').equals(0);
  });

  test('handles wrapping a Uint8 after * as expected', () {
    final n = Uint8.max;
    final q = n.wrappedMultiply(Uint8(2));
    check(q).has((a) => a.toInt(), 'toInt()').equals(254);
  });

  test('handles wrapping a Uint32 after a + as expected', () {
    final n = Uint32.max;
    final q = n.wrappedAdd(Uint32(1));
    check(q).has((a) => a.toInt(), 'toInt()').equals(0);
  });

  test('handles wrapping a Uint32 after * as expected', () {
    final n = Uint32.max;
    final q = n.wrappedMultiply(Uint32(2));
    check(q).has((a) => a.toInt(), 'toInt()').equals(4294967294);
  });

  test('-1 >> 0 does not overflow unexpectedly', () {
    check(Int32(-1).wrappedUnsignedShiftRight(0)).equals(Int32(-1));
  });

  test('-1 ^ 2 does not overflow unexpectedly', () {
    check(Int32(-1) ^ Int32(2)).equals(Int32(-3));
  });

  test('2.pow(32) does not overflow unexpectedly', () {
    check(Uint32(2).wrappedPow(32)).equals(Uint32(0));
  });

  test('2.pow(32) >> 1 does not overflow unexpectedly', () {
    check(Uint32(2).wrappedPow(32).wrappedUnsignedShiftRight(1))
        .equals(Uint32(0));
  });

  test('2.pow(32) - 1 >> 1 does not overflow unexpectedly', () {
    check(
      Uint32(2)
          .wrappedPow(32)
          .wrappedSubtract(Uint32(1))
          .wrappedUnsignedShiftRight(1),
    ).equals(Uint32(2147483647));
  });
}
