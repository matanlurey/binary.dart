import 'package:binary/binary.dart' show Uint32, Uint8;

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
}
