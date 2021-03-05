# CHANGELOG

## 3.0.0

Support null-safety

## 2.0.0

### Highlights

Added limited support for operations on integer values that exceed 32-bits.
Before `2.0.0` most of the methods provided by this package had undefined
behavior when accessing a bit > the 31st bit when compiled to JavaScript:

- `msb`
- `getBit`
- `setBit` and `isSet`
- `clearBit` and `isCleared`
- `toggleBit`
- `countSetBits`
- `bitRange` and `bitChunk`
- `hiLo`
- `toBinary` and `toBinaryPadded`

In addition, these operations will now throw `UnsupportedError` when compiled
to JavaScript when attempting operations on integer values that exceed 52-bits,
which is the maximum integer that is supported in JavaScript VMs. The remaining
methods (i.e. `signedRightShift`, so on), unless otherwise documented are
assumed to have _undefined behavior_ when compiled to JavaScript.

> Tip: Don't want to consider all of that? You can always just use `Uint32`!

### Operating on Larger Ints

Added `<int>.hiLo()`, which returns a fixed 2-length `Uint32List` where
element 0 is the "hi" (upper bits) and element 1 is the "lo" (lower bits).
Because of platform limitations, "hi" may only include up to the 52nd bit.

Additionally, `Uint32List` has received new extension methods through the
extension class `BinaryUint64HiLo` (e.g. the result of `<int>.hiLo()`), which
simplifies operations for integers larger than 32 bits:

- `.hi` and `.lo` getters.
- `~` and `&` and `|` operators.
- `equals(Uint32List)` and `toInt()` methods.

These methods allow treating a `Uint32List` roughly as a 64-bit integer with
limited boxing. We may still consider adding a `Uint64` boxed `Integral` in a
future release, but you may also try using these other implemntations:

- [BigInt](https://api.dart.dev/stable/2.8.4/dart-core/BigInt-class.html)
- [Int64](https://pub.dev/documentation/fixnum/latest/fixnum/Int64-class.html)

### Additional changes

- Added `<int>.pow(n)`, which is like `<dart:math>.pow` with a return of `int`.
- Added `<Integral>.signExtend(startSize)`.
- Removed all methods deprecated up to this point.
- Removed `<Integral>.[un]signed`, which was misleading for unsigned integers.
- Fixed a bug where `<int>.replaceBitRange` often emitted an incorrect result.
- Fixed a bug where `<int>.signExtend` often emitted an incorrect result.

## 1.7.0

- Deprecated `<*>.shiftRight` in favor of `<*>.signedShiftRight>`.
- Deprecated `<*>.rotateRight`, which was not correctly implemeted.
- Added `<*>.rotateRightShift` to replace `rotateRight`.
- Updated some doc comments that referred to incorrect JavaScript operators.

## 1.6.0

- Added `<BinaryInt|BinaryList|Integral>.toggleBit`.
- Deprecated `Integral.setBits` in favor of `.bitsSet`.

## 1.5.0

- Added `BitPatternGroup`'s constructor, deprecating `.toGroup()`.
- Added `BitPart.zero` and `BitPart.one` and deprecated `BitPart(int)`.

## 1.4.0

- Added `List<int>.toBits()` as a replacement for `List<int>.parseBits()`.
- Added `String.bits` as a replacement for `String.parseBits()`.
- Deprecated `List<int>.parseBits()` and `String.parseBits()`.
- Deprecated `int.as[U]Int{N}` functions in favor of manual wrapping.

## 1.3.0

- Added comparison operators (`>`, `>=`, `<`, `<=`) to `Integral`.
- Added `<Integral>.checkRange` and `<Integral>.assertRange` static methods.
- Added the abiltiy to extend `Integral` to create custom-sized integers.

## 1.2.2

- Fixed a bug where `_InterpretedBitPattern` (the `BitPattern` generated from
  `BitPatternBuilder`) was sorted in an incorrect order (ascending instead of
  descending), which would not `match` correctly in some scenarios.

## 1.2.1

- Fixed a bug where `BitPatternBuilder.parse('00AA_AABB')` incorrectly threw a
  `FormatException` assuming that `_` deliniated the end of the `A` variable
  segment and the subsequent `A` was a _new_ segment (which is invalid). It now
  correctly parses the above as just two variable segments (`AAAA`, `BB`).

## 1.2.0

- Added `BitPatternBuilder.parse`, a simplified-format for building `BitPattern`
  from a string of alpha-numeric characters, where `0` and `1` are pre-defined
  (static) flags for matching, and charaters are variable segments:

  ```dart
  // Create a BitPattern (Data Structures).
  final $01V = BitPatternBuilder([
    BitPart(0),
    BitPart(1),
    BitPart.v(1, 'A'),
  ]).build();

  // Create a BitPattern (Parse a String).
  final $01Vs = BitPatternBuilder.parse('01A').build();
  print($01V == $01Vs); // true
  ```

- Fixed a bug where it was not possible to capture variables that were >8-bit.

## 1.1.0

- Added `BitPatternBuilder`, `BitPattern`, `BitPart`: a new API in order to
  build bit-based patterns and match against arbitrary sets of bits, optionally
  extracting variable names. This API is intended to make it easier to build
  apps and packages around implementing emulators and other decoders.

## 1.0.0

A large update to bring into line for Dart 2, as well take advantage of newer
langauge features like
[extension methods](https://dart.dev/guides/language/extension-methods) over
top-level methods. As a result, the new API is _not_ compatible with previous
versions, but migration should be trivial.

## 0.1.3

- Added `arithmeticShiftRight`

## 0.1.2

- Moved into a standalone repository (outside of `gba.dart`).
- Added `signExtend` as a method to `Integral`.
- Added `areSet`.
- Added `msb`.

## 0.1.1

- Added `signExtend`

## 0.1.0

- Fixed a bug where `int128` and `uint128` only had a length of 64.

## 0.0.4

- Updated the documentation and README.

## 0.0.3

- Added `isZero`.

## 0.0.2

- Added `isNegative`, `hasCarryBit`, `doesAddOverflow`, `doesSubOverflow`,
  `mask`.
- Added `parseBits`.

## 0.0.1

- Add top-level `isSet` and `isClear`, `Integral#isSet`, `Integral#isClear`.
- Add _checked_-mode range checks to `bitChunk` and `bitRange`.
- Fix a bug in the implementation of `bitChunk` and `bitRange`.
- Added a top-level `fromBits` and `Integral#fromBits`

## 0.0.0

- Initial commit, feedback welcome!
