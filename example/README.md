# Examples

This directory contains examples of how to use `package:binary`.

## [Basic](./basic.dart)

A simple example of how to use `package:binary` to parse and shift bits.

```shell
$ dart example/basic.dart

127
00000011
```

## [Checksum](./checksum.dart)

Calculates the CRC32 checksum of a file.

```shell
$ dart example/checksum.dart example/checksum.dart

CRC32 checksum: 13b53c2f
```

## [Bitfield](./bitfield.dart)

Demonstrates decoding binary data efficiently, i.e. opcodes or binary formats.

```shell
$ dart example/bitfield.dart

11011101

Kind:  00001101
S:     00000001
Level: 00000010
P:     00000001
```
