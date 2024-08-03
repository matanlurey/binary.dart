import 'package:binary/binary.dart';

import 'src/prelude.dart';

void main() {
  final uint8 = IntDescriptor<int>.unsigned(
    (i) => i,
    width: 8,
    max: 255,
  );
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

  test('uncheckedSetNthBit', () {
    final bits = int.parse('1', radix: 2);
    final set = i.uncheckedSetNthBit(bits, 0, false);
    check(set).equals(0);
  });

  test('bit list', () {
    final bits = int.parse('10101010', radix: 2);
    final it = i.toBitList(bits);

    check(it.elementAt(0)).equals(false);
    check(it.elementAt(1)).equals(true);
    check(it.elementAt(2)).equals(false);
    check(it.elementAt(3)).equals(true);
    check(it.elementAt(4)).equals(false);
    check(it.elementAt(5)).equals(true);
    check(it.elementAt(6)).equals(false);
    check(it.elementAt(7)).equals(true);

    check(it.first).equals(false);
    check(it.last).equals(true);
    check(() => it.single).throws<Error>();
    check(it.isEmpty).isFalse();
    check(it.isNotEmpty).isTrue();
    check(it.contains(true)).isTrue();
    check(it.contains(false)).isTrue();
  });

  test('single length bits iterable', () {
    final i1 = IntDescriptor<int>.unsigned(
      (i) => i,
      width: 1,
      max: 1,
    );
    final bits = int.parse('1', radix: 2);
    final it = i1.toBitList(bits);

    check(it.single).equals(true);
  });
}
