import 'package:binary/binary.dart' show BitList;

import 'src/prelude.dart';

void main() {
  group('fixed-length 16 bits', () {
    test('fill = false', () {
      final list = BitList(16);
      check(list).has((a) => a.length, 'length').equals(16);
      check(list).every((a) => a.isFalse());
      check(list.toUint32List()).deepEquals([0x0]);
      check(list).deepEquals(BitList.fromInt(0x0, length: 16));
    });

    test('fill = true', () {
      final list = BitList(16, fill: true);
      check(list).has((a) => a.length, 'length').equals(16);
      check(list).every((a) => a.isTrue());
      check(list.toUint32List()).deepEquals([0xFFFFFFFF]);
      check(list).deepEquals(BitList.fromInt(0xFFFFFFFF, length: 16));
    });

    test('set bits', () {
      final list = BitList(16);
      for (var i = 0; i < 16; i++) {
        list[i] = i.isEven;
      }
      check(list.toUint32List()).deepEquals([0x5555]);
      check(list).deepEquals(BitList.fromInt(0x5555, length: 16));
    });

    test('cannot add or set length', () {
      final list = BitList(16);
      check(() => list.add(true)).throws<UnsupportedError>();
      check(() => list.length = 32).throws<UnsupportedError>();
    });
  });

  group('fixed-length 32 bits', () {
    test('fill = false', () {
      final list = BitList(32);
      check(list).has((a) => a.length, 'length').equals(32);
      check(list).every((a) => a.isFalse());
      check(list.toUint32List()).deepEquals([0x0]);
      check(list).deepEquals(BitList.fromInt(0x0));
    });

    test('fill = true', () {
      final list = BitList(32, fill: true);
      check(list).has((a) => a.length, 'length').equals(32);
      check(list).every((a) => a.isTrue());
      check(list.toUint32List()).deepEquals([0xFFFFFFFF]);
      check(list).deepEquals(BitList.fromInt(0xFFFFFFFF));
    });

    test('set bits', () {
      final list = BitList(32);
      for (var i = 0; i < 32; i++) {
        list[i] = i.isEven;
      }
      check(list.toUint32List()).deepEquals([0x55555555]);
      check(list).deepEquals(BitList.fromInt(0x55555555));
    });

    test('cannot add or set length', () {
      final list = BitList(32);
      check(() => list.add(true)).throws<UnsupportedError>();
      check(() => list.length = 64).throws<UnsupportedError>();
    });
  });

  group('fixed-length 64 bits', () {
    test('fill = false', () {
      final list = BitList(64);
      check(list).has((a) => a.length, 'length').equals(64);
      check(list).every((a) => a.isFalse());
      check(list.toUint32List()).deepEquals([0x0, 0x0]);
    });

    test('fill = true', () {
      final list = BitList(64, fill: true);
      check(list).has((a) => a.length, 'length').equals(64);
      check(list).every((a) => a.isTrue());
      check(list.toUint32List()).deepEquals([0xFFFFFFFF, 0xFFFFFFFF]);
    });

    test('set bits', () {
      final list = BitList(64);
      for (var i = 0; i < 64; i++) {
        list[i] = i.isEven;
      }
      check(list.toUint32List()).deepEquals([0x55555555, 0x55555555]);
      check(list.toUint32List(copy: false)).deepEquals(
        [0x55555555, 0x55555555],
      );

      final init = list.toUint32List(copy: false);
      for (var i = 0; i < 64; i++) {
        list[i] = i.isOdd;
      }
      check(init).deepEquals([0xAAAAAAAA, 0xAAAAAAAA]);
    });

    test('cannot add or set length', () {
      final list = BitList(64);
      check(() => list.add(true)).throws<UnsupportedError>();
      check(() => list.length = 128).throws<UnsupportedError>();
    });
  });

  group('growable 16 bits', () {
    test('fill = false', () {
      final list = BitList(16, growable: true);
      check(list).has((a) => a.length, 'length').equals(16);
      check(list).every((a) => a.isFalse());
      check(list.toUint32List()).deepEquals([0x0]);
      check(list).deepEquals(BitList.fromInt(0x0, length: 16));
    });

    test('fill = true', () {
      final list = BitList(16, growable: true, fill: true);
      check(list).has((a) => a.length, 'length').equals(16);
      check(list).every((a) => a.isTrue());
      check(list.toUint32List()).deepEquals([0xFFFFFFFF]);
      check(list).deepEquals(BitList.fromInt(0xFFFFFFFF, length: 16));
    });

    test('set bits', () {
      final list = BitList(16, growable: true);
      for (var i = 0; i < 16; i++) {
        list[i] = i.isEven;
      }
      check(list.toUint32List()).deepEquals([0x5555]);
      check(list).deepEquals(BitList.fromInt(0x5555, length: 16));
    });

    test('add bits', () {
      final list = BitList(0, growable: true);
      check(list).has((a) => a.length, 'length').equals(0);

      for (var i = 0; i < 16; i++) {
        list.add(i.isEven);
      }
      check(list).has((a) => a.length, 'length').equals(16);
      check(list.toUint32List()).deepEquals([0x5555]);

      for (var i = 0; i < 16; i++) {
        list.add(i.isOdd);
      }
      check(list).has((a) => a.length, 'length').equals(32);
      check(list.toUint32List()).deepEquals([0xAAAA5555]);
    });

    test('set length', () {
      final list = BitList(16, growable: true);
      list.length = 32;
      check(list).has((a) => a.length, 'length').equals(32);
      check(list).every((a) => a.isFalse());
      check(list.toUint32List()).deepEquals([0x0]);
      check(list).deepEquals(BitList.fromInt(0x0));
    });
  });

  group('growable 32 bits', () {
    test('fill = false', () {
      final list = BitList(32, growable: true);
      check(list).has((a) => a.length, 'length').equals(32);
      check(list).every((a) => a.isFalse());
      check(list.toUint32List()).deepEquals([0x0]);
      check(list).deepEquals(BitList.fromInt(0x0));
    });

    test('fill = true', () {
      final list = BitList(32, growable: true, fill: true);
      check(list).has((a) => a.length, 'length').equals(32);
      check(list).every((a) => a.isTrue());
      check(list.toUint32List()).deepEquals([0xFFFFFFFF]);
      check(list).deepEquals(BitList.fromInt(0xFFFFFFFF));
    });

    test('set bits', () {
      final list = BitList(32, growable: true);
      for (var i = 0; i < 32; i++) {
        list[i] = i.isEven;
      }
      check(list.toUint32List()).deepEquals([0x55555555]);
      check(list).deepEquals(BitList.fromInt(0x55555555));
    });

    test('add bits', () {
      final list = BitList(0, growable: true);
      check(list).has((a) => a.length, 'length').equals(0);

      for (var i = 0; i < 32; i++) {
        list.add(i.isEven);
      }
      check(list).has((a) => a.length, 'length').equals(32);
      check(list.toUint32List()).deepEquals([0x55555555]);

      for (var i = 0; i < 32; i++) {
        list.add(true);
      }
      check(list).has((a) => a.length, 'length').equals(64);
      check(list.toUint32List()).deepEquals([0x55555555, 0xFFFFFFFF]);
    });

    test('set length', () {
      final list = BitList(32, growable: true);
      list.length = 64;
      check(list).has((a) => a.length, 'length').equals(64);
      check(list).every((a) => a.isFalse());
      check(list.toUint32List()).deepEquals([0x0, 0x0]);
    });

    test('shrink length', () {
      final list = BitList(32, growable: true);
      list.length = 64;
      list.length = 32;
      check(list).has((a) => a.length, 'length').equals(32);
      check(list).every((a) => a.isFalse());
      check(list.toUint32List()).deepEquals([0x0]);
      check(list).deepEquals(BitList.fromInt(0x0));
    });

    test('insert bits', () {
      final list = BitList(31, growable: true);
      list.insert(0, true);
      check(list).has((a) => a.length, 'length').equals(32);
      check(list.toUint32List()).deepEquals([0x1]);

      list.insertAll(0, List.generate(32, (i) => i.isEven));
      check(list).has((a) => a.length, 'length').equals(64);
      check(list.toUint32List()).deepEquals([0x55555555, 0x1]);
    });

    test('addAll', () {
      final list = BitList(32, growable: true);
      list.addAll(Iterable.generate(32, (i) => i.isEven));
      check(list).has((a) => a.length, 'length').equals(64);
      check(list.toUint32List()).deepEquals([0x0, 0x55555555]);
    });

    test('toUint32List(copy: false)', () {
      final list = BitList(32, growable: true);
      list.addAll(Iterable.generate(32, (i) => i.isEven));
      final uint32List = list.toUint32List(copy: false);
      check(uint32List).deepEquals([0x0, 0x55555555]);

      list.add(true);
      check(uint32List).deepEquals([0x0, 0x55555555]);
    });
  });

  test('BitList.fromInt growable: true', () {
    final list = BitList.fromInt(0x55555555, growable: true);
    check(list).has((a) => a.length, 'length').equals(32);
    check(list.toUint32List()).deepEquals([0x55555555]);
  });

  group('BitList.from', () {
    test('fixed 32-bit', () {
      final list = BitList.from(Iterable.generate(32, (_) => true));
      check(list).has((a) => a.length, 'length').equals(32);
      check(list.toUint32List()).deepEquals([0xFFFFFFFF]);
    });

    test('fixed 64-bit', () {
      final list = BitList.from(Iterable.generate(64, (_) => true));
      check(list).has((a) => a.length, 'length').equals(64);
      check(list.toUint32List()).deepEquals([0xFFFFFFFF, 0xFFFFFFFF]);
    });

    test('growable 128-bit', () {
      final list = BitList.from(
        Iterable.generate(128, (_) => true),
        growable: true,
      );
      check(list).has((a) => a.length, 'length').equals(128);
      check(list.toUint32List()).deepEquals([
        0xFFFFFFFF,
        0xFFFFFFFF,
        0xFFFFFFFF,
        0xFFFFFFFF,
      ]);
    });
  });
}
