import 'dart:typed_data';

import 'package:binary/binary.dart';

import '_prelude.dart';

void main() {
  test('addWord (Endian = big)', () {
    final builder = BytesBuilder();
    builder.addWord(0x1234);
    check(builder.toBytes()).deepEquals([0x12, 0x34]);
  });

  test('addWord (Endian = little)', () {
    final builder = BytesBuilder();
    builder.addWord(0x1234, Endian.little);
    check(builder.toBytes()).deepEquals([0x34, 0x12]);
  });

  test('addWords (Endian = big)', () {
    final builder = BytesBuilder();
    builder.addWords([0x1234, 0x5678]);
    check(builder.toBytes()).deepEquals([0x12, 0x34, 0x56, 0x78]);
  });

  test('addWords (Endian = little)', () {
    final builder = BytesBuilder();
    builder.addWords([0x1234, 0x5678], Endian.little);
    check(builder.toBytes()).deepEquals([0x34, 0x12, 0x78, 0x56]);
  });

  test('addDword (Endian = big)', () {
    final builder = BytesBuilder();
    builder.addDWord(0x12345678);
    check(builder.toBytes()).deepEquals([0x12, 0x34, 0x56, 0x78]);
  });

  test('addDword (Endian = little)', () {
    final builder = BytesBuilder();
    builder.addDWord(0x12345678, Endian.little);
    check(builder.toBytes()).deepEquals([0x78, 0x56, 0x34, 0x12]);
  });

  test('addDWords (Endian = big)', () {
    final builder = BytesBuilder();
    builder.addDWords([0x12345678, 0x9ABCDEF0]);
    check(
      builder.toBytes(),
    ).deepEquals([0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0]);
  });

  test('addDWords (Endian = little)', () {
    final builder = BytesBuilder();
    builder.addDWords([0x12345678, 0x9ABCDEF0], Endian.little);
    check(
      builder.toBytes(),
    ).deepEquals([0x78, 0x56, 0x34, 0x12, 0xF0, 0xDE, 0xBC, 0x9A]);
  });
}
