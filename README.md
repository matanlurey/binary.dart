# Binary

Utilities for accessing binary data and bit manipulation in Dart and Flutter.

[![Binary on pub.dev][pub_img]][pub_url]
[![Code coverage][cov_img]][cov_url]
[![Github action status][gha_img]][gha_url]
[![Dartdocs][doc_img]][doc_url]
[![Style guide][sty_img]][sty_url]

> [!IMPORTANT]
> Version 4.0.0 has a _large_ set of breaking changes, including removing the
> vast majority of extension methods and boxed classes, in favor of using the
> newer _extension types_ feature in Dart. I would be opening to adding back
> some deprecated methods, or a `lib/compat.dart` file if there is demand;
> please [file an issue][] if you need this.

## Getting started

```bash
dart pub add binary
```

Then, import the package and start using it:

```dart
import 'package:binary/binary.dart';
```

If you are not familiar with [extension methods][] and [extension types][], it
is worth reading the documentation before using this package, which has heavy
use of extensions for most functionality. A small primer is instead of writing
something like:

```dart
void main() {
  // Old API in version <= 0.1.3:
  print(toBinaryPadded(0x0C, 8)); // 00001100

  // Old API in version < 4.0.0:
  print(0x0C.toBinaryPadded(8)); // 00001100
}
```

You now use `toBinaryString` (and other methods) on an _extension type_:

```dart
void main() {
  // New API.
  print(Uint8(0x0C).toBinaryString()); // 00001100
}
```

Notice that the width is no longer required, as the type itself knows its width.

## Usage

This package provides a few sets of APIs extension types and methods.

Most users will use one of the fixed-width integer types, such as `Uint8`:

```dart
// Parse and reprsent a binary integer:
final rawInt = int.parse('0111' '1111', radix: 2);
final fixInt = Uint8(rawInt);
print(fixInt); // 127

// Works identically to the >>> operator in JavaScript:
final shifted = fixInt.signedRightShift(5);
print(shifted.toBinaryString()); // 00000011
```

### Overflows

Fixed with integers do not overflow unexpectedly, unlike the core Dart types.

By default, any operation that _can_ overflow throws an assertion error in debug
mode, and wraps around in release mode. For example:

```dart
// An error in debug mode, or 0 in release mode.
Uint8(255) + Uint8(1);
```

To disable assertions, and always wrap, even in debug mode:

```dart
debugCheckFixedWithInRange = false;
```

Finer-grained control is available by using variants of the operators that
explicitly handle overflow:

```dart
// Returns null if the operation would overflow.
Uint8(255).tryAdd(Uint8(1));

// Wraps around if the operation would overflow.
Uint8(255).wrappedAdd(Uint8(1));

// Clamps the result to the min/max value if the operation would overflow.
Uint8(255).clampedAdd(Uint8(1));
```

An additional variant, `uncheckedAdd`, is available for when you are certain
that overflow is not possible, and want to avoid the overhead of checking:

```dart
// Asserts in debug mode, no overhead in release mode, but can overflow!

// OK, this will definitely not overflow.
Uint8(1).uncheckedAdd(Uint8(3));

// DANGEROUS: This will overflow, but it won't be checked in release mode!
Uint8(255).uncheckedAdd(Uint8(1));
```

### Bit Patterns

There is also builder-type API for generating patterns to match against bits.
The easiest way to explain this API is it is _like_ `RegExp`, except for
matching and capturing components of bits:

```dart
void main() {
  // Create a BitPattern.
  final $01V = BitPatternBuilder([
    BitPart.zero,
    BitPart.one,
    BitPart.v(1),
  ]).build();

  // Match it against bits.
  print($01V.matches('011'.bits)); // true

  // Capture variables (if any), similar to a RegExp.
  print($01V.capture('011'.bits)); // [1]
}
```

## Compatibility

This package is intended to work identically and well in:

- The Dart VM, in both JIT and AOT modes.
- Flutter, in both JIT and AOT modes.
- The web, in both DDC, Dart2JS modes and compiled to WASM.

As a result, there are no built-in ways to access integers > 32-bit provided (as
JS integers are limited).

Feel free to [file an issue][] if you'd like limited support for 64 and 128-bit
integers.

[pub_url]: https://pub.dartlang.org/packages/binary
[pub_img]: https://img.shields.io/pub/v/binary.svg
[gha_url]: https://github.com/matanlurey/binary.dart/actions
[gha_img]: https://github.com/matanlurey/binary.dart/workflows/Dart/badge.svg
[cov_url]: https://codecov.io/gh/matanlurey/binary.dart
[cov_img]: https://codecov.io/gh/matanlurey/binary.dart/branch/main/graph/badge.svg
[doc_url]: https://www.dartdocs.org/documentation/binary/latest
[doc_img]: https://img.shields.io/badge/Documentation-binary-blue.svg
[sty_url]: https://pub.dev/packages/oath
[sty_img]: https://img.shields.io/badge/style-oath-9cf.svg
[extension methods]: https://dart.dev/guides/language/extension-methods
[extension types]: https://dart.dev/guides/language/extension-types
[file an issue]: https://github.com/matanlurey/binary.dart/issues

## Contributing

To run the tests, run:

```shell
dart test
```

Or, to run a comprehensive set of tests on all supported platforms, run:

```shell
dart test -P all
```

To check code coverage locally, run:

```shell
./chore coverage
```

To preview `dartdoc` output locally, run:

```shell
./chore dartdoc
```
