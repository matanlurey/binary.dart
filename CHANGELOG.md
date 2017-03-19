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
