import 'package:binary/binary.dart';

import 'src/prelude.dart';

/// Tests that [Uint32], even when it would overflow significantly, works.
void main() {
  test('Uint32.max (4294967295) * 2 is 4294967294', () {
    check(Uint32.max.wrappedMultiply(Uint32(2)))
        .has((a) => a.toInt(), 'toInt()')
        .equals(4294967294);
  });
}
