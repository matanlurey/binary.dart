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

  group('isPowerOf2', () {
    test('0.isPowerOf2() == false', () {
      check(0.isPowerOf2()).isFalse();
    });

    test('1.isPowerOf2() == true', () {
      check(1.isPowerOf2()).isTrue();
    });

    test('2.isPowerOf2() == true', () {
      check(2.isPowerOf2()).isTrue();
    });

    test('3.isPowerOf2() == false', () {
      check(3.isPowerOf2()).isFalse();
    });

    test('4.isPowerOf2() == true', () {
      check(4.isPowerOf2()).isTrue();
    });

    test('5.isPowerOf2() == false', () {
      check(5.isPowerOf2()).isFalse();
    });

    test('6.isPowerOf2() == false', () {
      check(6.isPowerOf2()).isFalse();
    });

    test('7.isPowerOf2() == false', () {
      check(7.isPowerOf2()).isFalse();
    });

    test('8.isPowerOf2() == true', () {
      check(8.isPowerOf2()).isTrue();
    });

    test('9.isPowerOf2() == false', () {
      check(9.isPowerOf2()).isFalse();
    });
  });

  group('nthBit', () {
    test('0x0F.nthBit(0) == true', () {
      check(0x0F[0]).isTrue();
    });

    test('0x0F.nthBit(1) == true', () {
      check(0x0F[1]).isTrue();
    });

    test('0x0F.nthBit(2) == true', () {
      check(0x0F[2]).isTrue();
    });

    test('0x0F.nthBit(3) == true', () {
      check(0x0F[3]).isTrue();
    });

    test('0x0F.nthBit(4) == false', () {
      check(0x0F[4]).isFalse();
    });
  });

  group('setNthBit', () {
    test('0x0F.setNthBit(2, false) == 0x0B', () {
      check(0x0F.setNthBit(2, false)).equals(0x0B);
    });

    test('0x0F.setNthBit(2) == 15', () {
      check(0x0F.setNthBit(2)).equals(15);
    });
  });

  group('toggleNthBit', () {
    test('0x0F.toggleNthBit(2) == 11', () {
      check(0x0F.toggleNthBit(2)).equals(11);
    });

    test('0x0B.toggleNthBit(2) == 0x0F', () {
      check(0x0B.toggleNthBit(2)).equals(0x0F);
    });
  });

  group('nextPowerOf2', () {
    test('0.nextPowerOf2() == 1', () {
      check(() => 0.nextPowerOf2()).throws<Error>();
    });

    test('1.nextPowerOf2() == 1', () {
      check(1.nextPowerOf2()).equals(1);
    });

    test('2.nextPowerOf2() == 2', () {
      check(2.nextPowerOf2()).equals(2);
    });

    test('3.nextPowerOf2() == 4', () {
      check(3.nextPowerOf2()).equals(4);
    });

    test('4.nextPowerOf2() == 4', () {
      check(4.nextPowerOf2()).equals(4);
    });

    test('5.nextPowerOf2() == 8', () {
      check(5.nextPowerOf2()).equals(8);
    });

    test('6.nextPowerOf2() == 8', () {
      check(6.nextPowerOf2()).equals(8);
    });

    test('7.nextPowerOf2() == 8', () {
      check(7.nextPowerOf2()).equals(8);
    });

    test('8.nextPowerOf2() == 8', () {
      check(8.nextPowerOf2()).equals(8);
    });

    test('9.nextPowerOf2() == 16', () {
      check(9.nextPowerOf2()).equals(16);
    });
  });

  group('nextMultipleOf', () {
    test('0.nextMultipleOf(1) == 0', () {
      check(0.nextMultipleOf(1)).equals(0);
    });

    test('1.nextMultipleOf(1) == 1', () {
      check(1.nextMultipleOf(1)).equals(1);
    });

    test('2.nextMultipleOf(1) == 2', () {
      check(2.nextMultipleOf(1)).equals(2);
    });

    test('3.nextMultipleOf(1) == 3', () {
      check(3.nextMultipleOf(1)).equals(3);
    });

    test('4.nextMultipleOf(1) == 4', () {
      check(4.nextMultipleOf(1)).equals(4);
    });

    test('5.nextMultipleOf(1) == 5', () {
      check(5.nextMultipleOf(1)).equals(5);
    });

    test('6.nextMultipleOf(1) == 6', () {
      check(6.nextMultipleOf(1)).equals(6);
    });

    test('7.nextMultipleOf(1) == 7', () {
      check(7.nextMultipleOf(1)).equals(7);
    });

    test('8.nextMultipleOf(1) == 8', () {
      check(8.nextMultipleOf(1)).equals(8);
    });

    test('9.nextMultipleOf(1) == 9', () {
      check(9.nextMultipleOf(1)).equals(9);
    });

    test('0.nextMultipleOf(2) == 0', () {
      check(0.nextMultipleOf(2)).equals(0);
    });

    test('1.nextMultipleOf(2) == 2', () {
      check(1.nextMultipleOf(2)).equals(2);
    });

    test('2.nextMultipleOf(2) == 2', () {
      check(2.nextMultipleOf(2)).equals(2);
    });

    test('3.nextMultipleOf(2) == 4', () {
      check(3.nextMultipleOf(2)).equals(4);
    });

    test('4.nextMultipleOf(2) == 4', () {
      check(4.nextMultipleOf(2)).equals(4);
    });
  });

  group('countOnes', () {
    test('0.countOnes() == 0', () {
      check(0.countOnes()).equals(0);
    });

    test('1.countOnes() == 1', () {
      check(1.countOnes()).equals(1);
    });

    test('2.countOnes() == 1', () {
      check(2.countOnes()).equals(1);
    });

    test('3.countOnes() == 2', () {
      check(3.countOnes()).equals(2);
    });

    test('4.countOnes() == 1', () {
      check(4.countOnes()).equals(1);
    });

    test('5.countOnes() == 2', () {
      check(5.countOnes()).equals(2);
    });

    test('6.countOnes() == 2', () {
      check(6.countOnes()).equals(2);
    });

    test('7.countOnes() == 3', () {
      check(7.countOnes()).equals(3);
    });

    test('8.countOnes() == 1', () {
      check(8.countOnes()).equals(1);
    });

    test('9.countOnes() == 2', () {
      check(9.countOnes()).equals(2);
    });
  });
}
