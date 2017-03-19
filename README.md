# binary

Utilities for working with binary data and bit manipulation in Dart.

[![Pub](https://img.shields.io/pub/v/binary.svg)](https://pub.dartlang.org/packages/binary)
[![Build Status](https://travis-ci.org/matanlurey/binary.svg?branch=master)](https://travis-ci.org/matanlurey/binary)
[![Coverage Status](https://coveralls.io/repos/github/matanlurey/binary/badge.svg?branch=master)](https://coveralls.io/github/matanlurey/binary?branch=master)
[![documentation](https://img.shields.io/badge/Documentation-binary-blue.svg)](https://www.dartdocs.org/documentation/binary/latest)

_**NOTE**: Unless otherwise noted, all functionality is based around treating
bits as [little endian][], that is in a 32-bit integer the leftmost bit is 31
and the rightmost bit is 0_

[little endian]: https://en.wikipedia.org/wiki/Endianness

## Overview

This library supports an `Integral` data type for fluent bit manipulation:

```dart
print(uint8.toBinaryPadded(196)); // '11000100'
```

Because of Dart's ability to do advanced *inlining* in both the Dart VM and
dart2js, this library should perform well and be extremely easy to use for most
use cases. For example, it's used in an [`arm7_tdmi`][arm7_tdmi] emulator.

[arm7_tdmi]: https://pub.dartlang.org/packages/arm7_tdmi

## Usage

This library has a combination of top-level methods, and instance methods of
pre-defined _`Integral` data types_ (see below). For example there are two ways
to _clear_ (set to `0`) a bit:

```dart
// Sets the 0th bit in an (int) bits to 0
bits = clearBit(bits, 0)
```

However, this will _not_ do range validation. Use `Integral#clearBit`:

```dart
// Sets the 0th bit in a uint32 to 0.
// In dev-mode, if either bits or `n` is out of range it throws.
bits = uint32.clearBit(bits, 0);
```
### Integral data types

* `bit`
* `int4`
* `int8`
* `int16`
* `int32`
* `int64`
* `int128`
* `uint4`
* `uint8`
* `uint16`
* `uint32`
* `uint64`
* `uint128`

### Learning more

See the [dartdocs][] for more about the API.

[dartdocs]: https://www.dartdocs.org/documentation/binary/latest
