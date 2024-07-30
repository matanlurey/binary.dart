/// A compatibility library that provides some API compatibility for
/// `binary.dart` prior to version 4.0.0.
@Deprecated(
  'The functionality in this library is discontinued, and will be removed in '
  'the next major release of the package. The individual methods have more '
  'details about alternatives.',
)
library;

import 'package:binary/binary.dart';

/// Deprecated extension methods for `int` that were discontinued.
extension BinaryInt on int {
  /// Returns whether bit `n` is set (i.e. `1`).
  @Deprecated('Use `nthBit` instead.')
  bool isSet(int n) => nthBit(n);

  /// Returns whether bit `n` is clear (i.e. `0`).
  @Deprecated('Use `!nthBit` instead.')
  bool isClear(int n) => !nthBit(n);

  /// Returns a new int with the nth bit cleared.
  @Deprecated('Use `setNthBit(n, false)` instead.')
  int clearBit(int n) => setNthBit(n, false);

  /// Returns a new int with the nth bit set.
  @Deprecated('Use `setNthBit(n)` instead.')
  int setBit(int n) => setNthBit(n);

  /// Returns `1` if the `n`-th bit is set, otherwise `0`.
  @Deprecated('Use `nthBit(n) ? 1 : 0` instead.')
  int getBit(int n) => nthBit(n) ? 1 : 0;

  /// Returns a new [int] with the `n`-th bit toggled.
  ///
  /// If [v] is provided, it is used as the new value. Otherwise the opposite
  /// value (of the current value) is used - i.e. `1` becomes `0` and `0`
  /// becomes `1` (logical not).
  @Deprecated('Use `toggleNthBit(n)` or `setNthBit(n, !nthBit(n))` instead.')
  // ignore: avoid_positional_boolean_parameters
  int toggleBit(int n, [bool? v]) => setNthBit(n, v ?? !nthBit(n));

  /// Returns the number of set bits in `this`, assuming a [bitWidth] `this`.
  @Deprecated('Use `countOnes()` instead.')
  int countSetBits(int bitWidth) {
    // Truncate to the bit width.
    final mask = (1 << bitWidth) - 1;
    return (this & mask).countOnes();
  }
}
