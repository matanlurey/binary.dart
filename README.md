# Binary

Utilities for accessing binary data and bit manipulation in Dart and Flutter.

![pub_url][pub_img]
![gha_url][gha_img]
![doc_url][doc_img]
![sty_url][sty_img]

[pub_url]: https://pub.dartlang.org/packages/binary
[pub_img]: https://img.shields.io/pub/v/binary.svg
[gha_url]: https://github.com/matanlurey/binary.dart/actions
[gha_img]: https://github.com/matanlurey/binary.dart/workflows/Dart/badge.svg

[cov_url]:
[cov_img]:
[doc_url]: https://www.dartdocs.org/documentation/binary/latest
[doc_img]: https://img.shields.io/badge/Documentation-binary-blue.svg
[sty_url]: https://pub.dev/packages/pedantic
[sty_img]: https://img.shields.io/badge/style-pedantic-40c4ff.svg

## Getting started

Using `package:binary` is easy, we have almost no dependencies:

```yaml
# Add a new dependency to "pubspec.yaml".
dependencies:
  binary:
```

```dart
import 'package:binary/binary.dart';

// Start using package:binary.
```

If you are not familiar with [extension methods in Dart][], it is worth reading
the documentation before using this package, which has heavy use of extensions
for most functionality. A small primer is instead of writing something like:

```dart
void main() {
  // Old API in version <= 0.1.3:
  print(toBinaryPadded(0x0C, 8)); // 00001100
}
```

You now use `toBinaryPadded` (and other methods) as an _extension_ method:

```dart
void main() {
  // New API.
  print(0x0C.toBinaryPadded(8)); // 00001100
}
```

[extension methods in dart]: https://dart.dev/guides/language/extension-methods

## Usage

This package provides a few sets of APIs extension methods and boxed classes.

> See the [API docs](https://www.dartdocs.org/documentation/binary/latest) for
> complete documentation.

Most users will use the extension methods on `int` or `String`:

```dart
// Uses "parseBits" (on String) and "shiftRight" (on int).
void main() {
  test('shiftRight should work identical to >>> in JavaScript', () {
    expect(
      '0111' '1111'.parseBits().shiftRight(5, 8),
      '0000' '0011'.parseBits(),
    );
  });
}
```

For convenience, extension methods are also present on `List<int>`:

```dart
// Uses "rotateRight" (on List<int>).
void main() {
  test('rotateRight should work similarly to int.rotateRight', () {
    final list = ['0110' '0000'.parseBits()];
    expect(
      list.rotateRight(0, 1).toBinaryPadded(8),
      '0011' '0000',
    );
  });
}
```

There are also some specialized extension methods on the `typed_data` types:

- `Uint8List`, `Int8List`
- `Uint16List`, `Int16List`
- `Uint32List`, `Int32List`

### Boxed Types

It is possible to sacrifice performance in order to get more type safety and
range checking. For apps or libraries where this is a suitable tradeoff, we
provide these boxed types/classes:

- `Bit`
- `Int4` and `Uint4`
- `Int8` and `Uint8`
- `Int16` and `Uint16`
- `Int32` and `Uint32`

## Compatibility

This package is intended to work identically and well in both the standalone
Dart VM, Flutter, and web builds of Dart and Flutter (both in DDC and Dart2JS).
As a result, there are no built-in ways to access integers > 32-bit provided (as
web integers are limited).

Feel free to [file an issue][] if you'd like limited support for 64 and 128-bit.

[file an issue]: https://github.com/matanlurey/binary.dart/issues
