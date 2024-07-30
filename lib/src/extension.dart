import 'dart:math' as math;

import 'package:meta/meta.dart';

/// Additional functionality for any integer, without size restrictions.
///
/// This extension provides additional functionality for integers that is not
/// provided by the standard library. This includes convenience methods for
/// accessing `dart:math` functions, as well as behavior that is not provided by
/// the standard library such as [midpoint] and [isPowerOf2].
///
/// Methods in [IntExtension] make no assumptions about the size of the
/// integer.
///
/// ## Example
///
/// ```dart
/// 2.pow(3); // 8
/// 0x0F.countOnes(); // 4
/// ```
extension IntExtension on int {
  /// Returns the exponentiation of this integer with the given [exponent].
  ///
  /// ## Example
  ///
  /// ```dart
  /// 2.pow(3); // 8
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int pow(int exponent) => math.pow(this, exponent).toInt();

  /// Returns the square root of this integer, rounded down.
  ///
  /// `this` must be a non-negative integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// 9.sqrt(); // 3
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int sqrt() => math.sqrt(this).toInt();

  /// Returns the natural logarithm of this integer, rounded down.
  ///
  /// `this` must be a positive integer.
  ///
  /// If [base] is provided, the logarithm is calculated with respect to that
  /// base; for example, `log(10)` returns the base 10 logarithm of `this`, and
  /// [base] must be a positive integer greater than 1.
  ///
  /// ## Example
  ///
  /// ```dart
  /// 10.log(); // 2
  /// 10.log(2); // 3
  /// 10.log(10); // 1
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int log([int? base]) {
    final a = math.log(this);
    return switch (base) {
      null => a.toInt(),
      2 => a ~/ math.ln2,
      10 => a ~/ math.ln10,
      1 => throw ArgumentError.value(base, 'base', 'must be greater than 1'),
      _ => a ~/ math.log(base),
    };
  }

  /// Returns the base 2 logarithm of this integer, rounded down.
  ///
  /// This is equivalent to `log(2)`.
  ///
  /// `this` must be a positive integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// 8.log2(); // 3
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int log2() => math.log(this) ~/ math.ln2;

  /// Returns the base 10 logarithm of this integer, rounded down.
  ///
  /// This is equivalent to `log(10)`.
  ///
  /// `this` must be a positive integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// 100.log10(); // 2
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int log10() => math.log(this) ~/ math.ln10;

  /// Returns the midpoint between this integer and [other].
  ///
  /// `midpoint(a, b)` is a `(a + b) >> 1` as if it were performed in a
  /// sufficiently-large signed integral type. This implies that the result is
  /// always rounded towards negative infinity and that no overflow will ever
  /// occur.
  ///
  /// ## Example
  ///
  /// ```dart
  /// 0.midpoint(0); // 0
  /// 5.midpoint(5); // 5
  /// 0.midpoint(10); // 5
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int midpoint(int other) => (this + other) ~/ 2;

  /// Returns `true` iff `value == 2^n` for some integer `n`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// 8.isPowerOf2(); // true
  /// 9.isPowerOf2(); // false
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  bool isPowerOf2() => this > 0 && (this & (this - 1)) == 0;

  /// Returns whether the n-th bit is set.
  ///
  /// ## Example
  ///
  /// ```dart
  /// 0x0F.nthBit(0); // true
  /// 0x0F.nthBit(1); // true
  /// 0x0F.nthBit(2); // true
  /// 0x0F.nthBit(3); // true
  /// 0x0F.nthBit(4); // false
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  bool nthBit(int n) => (this & (1 << n)) != 0;

  /// Returns whether the n-th bit is set.
  ///
  /// This is an alias for [nthBit].
  bool operator [](int n) => nthBit(n);

  /// Sets the n-th bit to [value], where `true` is `1` and `false` is `0`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final v = 0x0F.setNthBit(2, false);
  /// print(v.toRadixString(16)); // 7
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @useResult
  // ignore: avoid_positional_boolean_parameters
  int setNthBit(int n, [bool value = true]) {
    if (value) {
      return this | (1 << n);
    } else {
      return this & ~(1 << n);
    }
  }

  /// Toggles the n-th bit.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final v = 0x0F.toggleNthBit(2);
  /// print(v.toRadixString(16)); // 3
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @useResult
  int toggleNthBit(int n) => this ^ (1 << n);

  /// Returns the smallest power of two greater than or equal to `this`.
  ///
  /// If `this` is already a power of two, it is returned.
  ///
  /// `this` must be a positive integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// 7.nextPowerOf2(); // 8
  /// 8.nextPowerOf2(); // 8
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int nextPowerOf2() => isPowerOf2() ? this : 1 << (log2() + 1);

  /// Calculates the smallest value greater than or equal to `this` that is
  /// a multiple of [n].
  ///
  /// `n` must be a positive integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// 7.nextMultipleOf(3); // 9
  /// 8.nextMultipleOf(3); // 9
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int nextMultipleOf(int n) {
    return ((this + n - 1) ~/ RangeError.checkNotNegative(n)) * n;
  }

  /// Returns the number of `1`s in the binary representation of `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// 0xFF.countOnes(); // 8
  /// ```
  int countOnes() {
    var count = 0;
    var value = this;
    while (value != 0) {
      count += value & 1;
      value >>= 1;
    }
    return count;
  }
}
