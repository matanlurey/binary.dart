import 'package:binary/binary.dart';

import 'src/prelude.dart';

void main() {
  const uint8 = IntDescriptor<int>.unsigned(width: 8);
  _test(uint8);
}

void _test(IntDescriptor<int> i) {
  test('has a width is 8', () {
    check(i).has((a) => a.width, 'width').equals(8);
  });

  test('is not signed', () {
    check(i).has((a) => a.signed, 'signed').isFalse();
    check(i).has((a) => a.unsigned, 'unsigned').isTrue();
  });

  test('has a minimum value of 0', () {
    check(i).has((a) => a.min, 'min').equals(0);
  });

  test('has a maximum value of 255', () {
    check(i).has((a) => a.max, 'max').equals(255);
  });

  test('is ==, hashCode, and toString of itself', () {
    check(i).equals(i);
    check(i).has((a) => a.hashCode, 'hashCode').equals(i.hashCode);
    check(i).has((a) => a.toString(), 'toString').equals(i.toString());
  });
}
