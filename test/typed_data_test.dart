// ignore_for_file: unused_local_variable

import 'dart:typed_data';

import 'package:binary/binary.dart';

import 'src/prelude.dart';

void main() {
  test('Uint8List', () {
    final list = Uint8List.fromList([1, 2, 3]);
    final cast = list.asListUint8();

    check(cast[0]).equals(Uint8(1));
    check(cast[1]).equals(Uint8(2));
    check(cast[2]).equals(Uint8(3));
  });

  test('Uint16List', () {
    final list = Uint16List.fromList([1, 2, 3]);
    final cast = list.asListUint16();

    check(cast[0]).equals(Uint16(1));
    check(cast[1]).equals(Uint16(2));
    check(cast[2]).equals(Uint16(3));
  });

  test('Uint32List', () {
    final list = Uint32List.fromList([1, 2, 3]);
    final cast = list.asListUint32();

    check(cast[0]).equals(Uint32(1));
    check(cast[1]).equals(Uint32(2));
    check(cast[2]).equals(Uint32(3));
  });

  test('Int8List', () {
    final list = Int8List.fromList([1, 2, 3]);
    final cast = list.asListInt8();

    check(cast[0]).equals(Int8(1));
    check(cast[1]).equals(Int8(2));
    check(cast[2]).equals(Int8(3));
  });

  test('Int16List', () {
    final list = Int16List.fromList([1, 2, 3]);
    final cast = list.asListInt16();

    check(cast[0]).equals(Int16(1));
    check(cast[1]).equals(Int16(2));
    check(cast[2]).equals(Int16(3));
  });

  test('Int32List', () {
    final list = Int32List.fromList([1, 2, 3]);
    final cast = list.asListInt32();

    check(cast[0]).equals(Int32(1));
    check(cast[1]).equals(Int32(2));
    check(cast[2]).equals(Int32(3));
  });
}
