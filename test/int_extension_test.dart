import 'package:binary/binary.dart' show IntExtension;

import 'src/prelude.dart';

void main() {
  group('pow', () {
    // This is already tested in the Dart SDK, so let's just test some cases.
    test('-1.pow(-1) == -1', () {
      check((-1).pow(-1)).equals(-1);
    });

    test('-1.pow(0) == 1', () {
      check((-1).pow(0)).equals(1);
    });

    test('-1.pow(1) == -1', () {
      check((-1).pow(1)).equals(-1);
    });

    test('0.pow(0) == 1', () {
      check(0.pow(0)).equals(1);
    });

    test('0.pow(1) == 0', () {
      check(0.pow(1)).equals(0);
    });

    test('0.pow(2) == 0', () {
      check(0.pow(2)).equals(0);
    });

    test('1.pow(0) == 1', () {
      check(1.pow(0)).equals(1);
    });

    test('1.pow(1) == 1', () {
      check(1.pow(1)).equals(1);
    });

    test('1.pow(2) == 1', () {
      check(1.pow(2)).equals(1);
    });

    test('2.pow(0) == 1', () {
      check(2.pow(0)).equals(1);
    });

    test('2.pow(1) == 2', () {
      check(2.pow(1)).equals(2);
    });

    test('2.pow(2) == 4', () {
      check(2.pow(2)).equals(4);
    });
  });

  group('sqrt', () {
    // This is already tested in the Dart SDK, so let's just test some cases.

    test('-1.sqrt() throws', () {
      check(() => (-1).sqrt()).throws<Error>();
    });

    test('0.sqrt() == 0', () {
      check(0.sqrt()).equals(0);
    });

    test('1.sqrt() == 1', () {
      check(1.sqrt()).equals(1);
    });

    test('2.sqrt() == 1', () {
      check(2.sqrt()).equals(1);
    });

    test('3.sqrt() == 1', () {
      check(3.sqrt()).equals(1);
    });

    test('4.sqrt() == 2', () {
      check(4.sqrt()).equals(2);
    });

    test('5.sqrt() == 2', () {
      check(5.sqrt()).equals(2);
    });

    test('6.sqrt() == 2', () {
      check(6.sqrt()).equals(2);
    });

    test('7.sqrt() == 2', () {
      check(7.sqrt()).equals(2);
    });

    test('8.sqrt() == 2', () {
      check(8.sqrt()).equals(2);
    });

    test('9.sqrt() == 3', () {
      check(9.sqrt()).equals(3);
    });
  });

  group('log', () {
    // This is already tested in the Dart SDK, so let's just test some cases.

    test('10.log() == 2', () {
      check(10.log()).equals(2);
    });

    test('1000.log(100) == 1', () {
      check(1000.log(100)).equals(1);
    });

    test('1.log(1) throws', () {
      check(() => 1.log(1)).throws<Error>();
    });

    test('1.log(2) == 0', () {
      check(1.log(2)).equals(0);
    });

    test('1.log(10) == 0', () {
      check(1.log(10)).equals(0);
    });

    test('2.log(1) throws', () {
      check(() => 2.log(1)).throws<Error>();
    });

    test('2.log(2) == 1', () {
      check(2.log(2)).equals(1);
    });

    test('2.log(10) == 0', () {
      check(2.log(10)).equals(0);
    });

    test('3.log(2) == 1', () {
      check(3.log(2)).equals(1);
    });

    test('3.log(10) == 0', () {
      check(3.log(10)).equals(0);
    });

    test('4.log(2) == 2', () {
      check(4.log(2)).equals(2);
    });

    test('4.log(10) == 0', () {
      check(4.log(10)).equals(0);
    });

    test('5.log(2) == 2', () {
      check(5.log(2)).equals(2);
    });

    test('5.log(10) == 0', () {
      check(5.log(10)).equals(0);
    });

    test('6.log(1) throws', () {
      check(() => 6.log(1)).throws<Error>();
    });

    test('6.log(2) == 2', () {
      check(6.log(2)).equals(2);
    });
  });

  group('log2', () {
    // This is already tested in the Dart SDK, so let's just test some cases.

    test('1.log2() == 0', () {
      check(1.log2()).equals(0);
    });

    test('2.log2() == 1', () {
      check(2.log2()).equals(1);
    });

    test('3.log2() == 1', () {
      check(3.log2()).equals(1);
    });

    test('4.log2() == 2', () {
      check(4.log2()).equals(2);
    });

    test('5.log2() == 2', () {
      check(5.log2()).equals(2);
    });

    test('6.log2() == 2', () {
      check(6.log2()).equals(2);
    });
  });

  group('log10', () {
    // This is already tested in the Dart SDK, so let's just test some cases.

    test('1.log10() == 0', () {
      check(1.log10()).equals(0);
    });

    test('2.log10() == 0', () {
      check(2.log10()).equals(0);
    });

    test('3.log10() == 0', () {
      check(3.log10()).equals(0);
    });

    test('4.log10() == 0', () {
      check(4.log10()).equals(0);
    });

    test('5.log10() == 0', () {
      check(5.log10()).equals(0);
    });

    test('6.log10() == 0', () {
      check(6.log10()).equals(0);
    });

    test('7.log10() == 0', () {
      check(7.log10()).equals(0);
    });

    test('8.log10() == 0', () {
      check(8.log10()).equals(0);
    });

    test('9.log10() == 0', () {
      check(9.log10()).equals(0);
    });
  });

  group('midpoint', () {
    test('0.midpoint(0) == 0', () {
      check(0.midpoint(0)).equals(0);
    });

    test('5.midpoint(5) == 5', () {
      check(5.midpoint(5)).equals(5);
    });

    test('0.midpoint(10) == 5', () {
      check(0.midpoint(10)).equals(5);
    });

    test('10.midpoint(0) == 5', () {
      check(10.midpoint(0)).equals(5);
    });

    test('5.midpoint(10) == 7', () {
      check(5.midpoint(10)).equals(7);
    });

    test('10.midpoint(5) == 7', () {
      check(10.midpoint(5)).equals(7);
    });
  });
}
