import 'dart:math' as math;

/// Additional functionality for any integer, without size restrictions.
///
/// This extension provides additional functionality for integers that is not
/// provided by the standard library. This includes convenience methods for
/// accessing `dart:math` functions, as well as behavior that is not provided by
/// the standard library such as [midpoint].
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
  int midpoint(int other) {
    // Uses ~/ to ensure that the operation is the same in the VM and JS.
    return (this + other) ~/ 2;
  }
}
