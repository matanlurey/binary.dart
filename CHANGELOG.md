# CHANGELOG

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
