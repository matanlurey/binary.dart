// coverage:ignore-file

import 'package:binary/src/descriptor.dart';
import 'package:binary/src/extension.dart';
import 'package:meta/meta.dart';

/// An unsigned 16-bit integer.
///
/// This type is _not_ explicitly boxed, and uses [extension types][]; that
/// means that _any_ [int] value _can_ be used as an Uint16, but only values
/// in the range of [min] and [max] are considered valid.
///
/// [extension types]: https://dart.dev/language/extension-types
///
/// ## Constructing
///
/// For most use cases, use the default [Uint16.new] constructor:
/// ```dart
/// Uint16(3); // 3
/// ```
///
/// In _debug_ mode, an assertion is made that the value is in a valid range;
/// otherwise, the value is wrapped, if necessary, to fit in the valid range.
/// This behavior can be used explicitly with [Uint16.fromWrapped]:
///
/// ```dart
/// Uint16.fromWrapped(Uint16.max + 1); // <min>
/// ```
///
/// See also:
/// - [Uint16.fromClamped], which clamps the value if it is out of range.
/// - [Uint16.tryFrom], which returns `null` if the value is out of range.
///
/// ## Operations
///
/// In most cases, every method available on [int] is also available on an
/// Uint16.
///
/// Some methods that only make sense for unsigned integers are not available
/// for signed integers, and vice versa, and some methods that are typically
/// inherited from [num], but not useful for integers, are not available; these
/// can still be accessed through the underlying [int] value, using [toInt]:
///
/// ```dart
/// Uint16(3).toInt().toStringAsExponential(); // "3e+0"
/// ```
///
/// ## Safety
///
/// Extension types are lightweight, but they are _not_ completely type-safe;
/// any [int] can be casted to an Uint16, and will bypass the range checks;
/// we believe that the performance benefits outweigh the risks, but it is
/// important to be aware of this limitation.
///
/// This also applies to methods such as [List.cast] or [Iterable.whereType].
extension type const Uint16._(int _) implements Comparable<num> {
  static const _descriptor = IntDescriptor<Uint16>.unsigned(
    Uint16.fromUnchecked,
    width: width,
    max: 65535,
  );

  /// The minimum value that this type can represent.
  static const min = Uint16.fromUnchecked(0);

  /// The maximum value that this type can represent.
  static const max = Uint16.fromUnchecked(65535);

  /// The number of bits used to represent values of this type.
  static const width = 16;

  /// Defines [v] as An unsigned 16-bit integer, wrapping if necessary.
  ///
  /// In debug mode, an assertion is made that [v] is in a valid range.
  factory Uint16(int v) => _descriptor.fit(v);

  /// Defines [v] as An unsigned 16-bit integer.
  ///
  /// Behavior is undefined if [v] is not in a valid range.
  const Uint16.fromUnchecked(
    int v,
  )   : _ = v,
        assert(
          // Dart2JS crashes if the boolean is first in this expression, but have
          // not been able to reproduce it in a minimal example yet, so this is a
          // workaround.
          v >= 0 && v <= 65535 || !debugCheckUncheckedInRange,
          'Value out of range: $v.\n\n'
          'This should never happen, and is likely a bug. To intentionally '
          'overflow, even in debug mode, set '
          '"-DdebugCheckUncheckedInRange=false" when running your program.',
        );

  /// Defines [v] as An unsigned 16-bit integer.
  ///
  /// Returns `null` if [v] is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16.tryFrom(Uint16.max); // <max>
  /// Uint16.tryFrom(Uint16.max + 1); // null
  /// ```
  static Uint16? tryFrom(int v) => _descriptor.fitChecked(v);

  /// Defines [v] as An unsigned 16-bit integer.
  ///
  /// If [v] is out of range, it is _wrapped_ to fit, similar to modular
  /// arithmetic:
  /// - If [v] is less than [min], the result is `v % (max + 1) + (max + 1)`.
  /// - If [v] is greater than [max], the result is `v % (max + 1)`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16.fromWrapped(Uint16.min - 3); // <max - 3>
  /// Uint16.fromWrapped(Uint16.max + 3); // <min + 3>
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory Uint16.fromWrapped(int v) => _descriptor.fitWrapped(v);

  /// Defines [v] as An unsigned 16-bit integer.
  ///
  /// If [v] is out of range, it is _clamped_ to fit:
  /// - If [v] is less than [min], the result is [min].
  /// - If [v] is greater than [max], the result is [max].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16.fromClamped(Uint16.min - 3); // <min>
  /// Uint16.fromClamped(Uint16.max + 3); // <max>
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory Uint16.fromClamped(int v) => _descriptor.fitClamping(v);

  /// Creates a [Uint16] using two integers as high and low bits.
  ///
  /// Each integer should be in the range of `0` to `2^(16 / 2) - 1`;
  /// extra bits are ignored.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory Uint16.fromHiLo(int hi, int lo) {
    return _descriptor.fromHiLo(hi, lo);
  }

  /// Returns the exponention of this integer with the given [exponent].
  ///
  /// If the result is out of range, it asserts in debug mode, and wraps in
  /// release mode.
  ///
  /// See also:
  /// - [tryPow], which returns `null` if the result is out of range.
  /// - [wrappedPow], which wraps the result if it is out of range.
  /// - [clampedPow], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).pow(3); // 8
  /// ```
  Uint16 pow(int exponent) => Uint16(_.pow(exponent));

  /// Returns the exponention of this integer with the given [exponent].
  ///
  /// If the result is out of range, the behavior is undefined.
  Uint16 uncheckedPow(int exponent) => Uint16.fromUnchecked(_.pow(exponent));

  /// Returns the exponention of this integer with the given [exponent].
  ///
  /// If the result is out of range, it returns `null`.
  ///
  /// See also:
  /// - [pow], which asserts in debug mode, and wraps in release mode.
  /// - [wrappedPow], which wraps the result if it is out of range.
  /// - [clampedPow], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).tryPow(3); // 8
  /// ```
  Uint16? tryPow(int exponent) => tryFrom(_.pow(exponent));

  /// Returns the exponention of this integer with the given [exponent].
  ///
  /// If the result is out of range, it wraps the result.
  ///
  /// See also:
  /// - [pow], which asserts in debug mode, and wraps in release mode.
  /// - [tryPow], which returns `null` if the result is out of range.
  /// - [clampedPow], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).wrappedPow(3); // 8
  /// ```
  Uint16 wrappedPow(int exponent) => Uint16.fromWrapped(_.pow(exponent));

  /// Returns the exponention of this integer with the given [exponent].
  ///
  /// If the result is out of range, it clamps the result.
  ///
  /// See also:
  /// - [pow], which asserts in debug mode, and wraps in release mode.
  /// - [tryPow], which returns `null` if the result is out of range.
  /// - [wrappedPow], which wraps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).clampedPow(3); // 8
  /// ```
  Uint16 clampedPow(int exponent) => Uint16.fromClamped(_.pow(exponent));

  /// Returns the square root of this integer, rounded down.
  ///
  /// `this` must be non-negative integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(9).sqrt(); // 3
  /// ```
  Uint16 sqrt() => Uint16.fromUnchecked(_.sqrt());

  /// Returns the natural logarithm of this integer, rounded down.
  ///
  /// `this` must be positive integer.
  ///
  /// If [base] is provided, the logarithm is calculated with respect to that
  /// base; for example, `log(10)` returns the base 10 logarithm of `this`, and
  /// [base] must be a positive integer greater than 1.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(8).log(); // 2
  /// Uint16(8).log(2); // 3
  /// ```
  Uint16 log([int? base]) => Uint16.fromUnchecked(_.log(base));

  /// Returns the base 2 logarithm of this integer, rounded down.
  ///
  /// This is equivalent to `log(2)`.
  ///
  /// `this` must be positive integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(8).log2(); // 3
  /// ```
  Uint16 log2() => Uint16.fromUnchecked(_.log2());

  /// Returns the base 10 logarithm of this integer, rounded down.
  ///
  /// This is equivalent to `log(10)`.
  ///
  /// `this` must be positive integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(8).log10(); // 2
  /// ```
  Uint16 log10() => Uint16.fromUnchecked(_.log10());

  /// Returns the midpoint between this integer and [other], rounded down.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).midpoint(Uint16(4)); // 3
  /// ```
  Uint16 midpoint(Uint16 other) => Uint16.fromUnchecked(_.midpoint(other._));

  /// Bits, from least significant to most significant.
  Iterable<bool> get bits => _descriptor.bits(_);

  /// Returns whether the n-th bit is set.
  bool nthBit(int n) => _.nthBit(n);

  /// Returns whether the n-th bit is set.
  ///
  /// This is an alias for [nthBit].
  bool operator [](int n) => nthBit(n);

  /// Returns whether the most significant bit is set.
  ///
  /// This is equivalent to `nthBit(width - 1)`.
  bool get msb => nthBit(width - 1);

  /// Sets the n-th bit to [value], where `true` is `1` and `false` is `0`.
  ///
  /// [n] must be in the range of `0` to `width - 1`.
  @useResult
  // ignore: avoid_positional_boolean_parameters
  Uint16 setNthBit(int n, [bool value = true]) {
    RangeError.checkValidRange(0, n, width - 1, 'n');
    return uncheckedSetNthBit(n, value);
  }

  /// Sets the n-th bit to [value], where `true` is `1` and `false` is `0`.
  ///
  /// If [n] is out of range, the behavior is undefined.
  // ignore: avoid_positional_boolean_parameters
  Uint16 uncheckedSetNthBit(int n, [bool value = true]) {
    return _descriptor.uncheckedSetNthBit(_, n, value);
  }

  /// Toggles the n-th bit.
  ///
  /// [n] must be in the range of `0` to `width - 1`.
  Uint16 toggleNthBit(int n) {
    RangeError.checkValidRange(0, n, width - 1, 'n');
    return uncheckedToggleNthBit(n);
  }

  /// Toggles the n-th bit.
  ///
  /// If [n] is out of range, the behavior is undefined.
  Uint16 uncheckedToggleNthBit(int n) {
    return _descriptor.uncheckedToggleNthBit(_, n);
  }

  /// Returns the smallest power of two greater than or equal to `this`.
  ///
  /// If `this` is already a power of two, it is returned.
  ///
  /// `this` must be a positive integer.
  ///
  /// If the result is out of range, it asserts in debug mode, and wraps in
  /// release mode.
  ///
  /// See also:
  /// - [tryNextPowerOf2], which returns `null` if the result is out of range.
  /// - [wrappedNextPowerOf2], which wraps the result if it is out of range.
  /// - [clampedNextPowerOf2], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).nextPowerOf2(); // 4
  /// ```
  Uint16 nextPowerOf2() => Uint16(_.nextPowerOf2());

  /// Returns the smallest power of two greater than or equal to `this`.
  ///
  /// If `this` is already a power of two, it is returned.
  ///
  /// `this` must be a positive integer.
  ///
  /// If the result is out of range, the behavior is undefined.
  Uint16 uncheckedNextPowerOf2() => Uint16.fromUnchecked(_.nextPowerOf2());

  /// Returns the smallest power of two greater than or equal to `this`.
  ///
  /// If `this` is already a power of two, it is returned.
  ///
  /// `this` must be a positive integer.
  ///
  /// If the result is out of range, it returns `null`.
  ///
  /// See also:
  /// - [nextPowerOf2], which asserts in debug mode, and wraps in release mode.
  /// - [wrappedNextPowerOf2], which wraps the result if it is out of range.
  /// - [clampedNextPowerOf2], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).tryNextPowerOf2(); // 4
  /// ```
  Uint16? tryNextPowerOf2() => tryFrom(_.nextPowerOf2());

  /// Returns the smallest power of two greater than or equal to `this`.
  ///
  /// If `this` is already a power of two, it is returned.
  ///
  /// `this` must be a positive integer.
  ///
  /// If the result is out of range, it wraps the result.
  ///
  /// See also:
  /// - [nextPowerOf2], which asserts in debug mode, and wraps in release mode.
  /// - [tryNextPowerOf2], which returns `null` if the result is out of range.
  /// - [clampedNextPowerOf2], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).wrappedNextPowerOf2(); // 4
  /// ```
  Uint16 wrappedNextPowerOf2() => Uint16.fromWrapped(_.nextPowerOf2());

  /// Returns the smallest power of two greater than or equal to `this`.
  ///
  /// If `this` is already a power of two, it is returned.
  ///
  /// `this` must be a positive integer.
  ///
  /// If the result is out of range, it clamps the result.
  ///
  /// See also:
  /// - [nextPowerOf2], which asserts in debug mode, and wraps in release mode.
  /// - [tryNextPowerOf2], which returns `null` if the result is out of range.
  /// - [wrappedNextPowerOf2], which wraps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).clampedNextPowerOf2(); // 4
  /// ```
  Uint16 clampedNextPowerOf2() => Uint16.fromClamped(_.nextPowerOf2());

  /// Calculates the smallest value greater than or equal to `this` that is
  /// a multiple of [n].
  ///
  /// `n` must be a positive integer.
  ///
  /// If the result is out of range, it asserts in debug mode, and wraps in
  /// release mode.
  ///
  /// See also:
  /// - [tryNextMultipleOf], which returns `null` if the result is out of range.
  /// - [wrappedNextMultipleOf], which wraps the result if it is out of range.
  /// - [clampedNextMultipleOf], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).nextMultipleOf(2); // 4
  /// ```
  Uint16 nextMultipleOf(Uint16 n) => Uint16(_.nextMultipleOf(n._));

  /// Calculates the smallest value greater than or equal to `this` that is
  ///
  /// a multiple of [n].
  ///
  /// `n` must be a positive integer.
  ///
  /// If the result is out of range, the behavior is undefined.
  Uint16 uncheckedNextMultipleOf(Uint16 n) {
    return Uint16.fromUnchecked(_.nextMultipleOf(n._));
  }

  /// Calculates the smallest value greater than or equal to `this` that is
  /// a multiple of [n].
  ///
  /// `n` must be a positive integer.
  ///
  /// If the result is out of range, it returns `null`.
  ///
  /// See also:
  /// - [nextMultipleOf], which asserts in debug mode, and wraps in release
  ///   mode.
  /// - [wrappedNextMultipleOf], which wraps the result if it is out of range.
  /// - [clampedNextMultipleOf], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).tryNextMultipleOf(2); // 4
  /// ```
  Uint16? tryNextMultipleOf(Uint16 n) => tryFrom(_.nextMultipleOf(n._));

  /// Calculates the smallest value greater than or equal to `this` that is
  /// a multiple of [n].
  ///
  /// `n` must be a positive integer.
  ///
  /// If the result is out of range, it wraps the result.
  ///
  /// See also:
  /// - [nextMultipleOf], which asserts in debug mode, and wraps in release
  ///   mode.
  /// - [tryNextMultipleOf], which returns `null` if the result is out of range.
  /// - [clampedNextMultipleOf], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).wrappedNextMultipleOf(2); // 4
  /// ```
  Uint16 wrappedNextMultipleOf(Uint16 n) {
    return Uint16.fromWrapped(_.nextMultipleOf(n._));
  }

  /// Calculates the smallest value greater than or equal to `this` that is
  /// a multiple of [n].
  ///
  /// `n` must be a positive integer.
  ///
  /// If the result is out of range, it clamps the result.
  ///
  /// See also:
  /// - [nextMultipleOf], which asserts in debug mode, and wraps in release
  ///   mode.
  /// - [tryNextMultipleOf], which returns `null` if the result is out of range.
  /// - [wrappedNextMultipleOf], which wraps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).clampedNextMultipleOf(2); // 4
  /// ```
  Uint16 clampedNextMultipleOf(Uint16 n) {
    return Uint16.fromClamped(_.nextMultipleOf(n._));
  }

  /// Returns the number of `1`s in the binary representation of `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).countOnes(); // 2
  /// ```
  int countOnes() => _descriptor.countOnes(_);

  /// Returns the number of leading ones in the binary representation of `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).countLeadingOnes(); // <width - 2>
  /// ```
  int countLeadingOnes() => _descriptor.countLeadingOnes(_);

  /// Returns the number of trailing ones in the binary representation of `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).countTrailingOnes(); // 0
  /// ```
  int countTrailingOnes() => _descriptor.countTrailingOnes(_);

  /// Returns the number of `0`s in the binary representation of `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).countZeros(); // <width - 2>
  /// ```
  int countZeros() => _descriptor.countZeros(_);

  /// Returns the number of leading zeros in the binary representation of
  /// `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).countLeadingZeros(); // <width - 2>
  /// ```
  int countLeadingZeros() => _descriptor.countLeadingZeros(_);

  /// Returns the number of trailing zeros in the binary representation of
  /// `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).countTrailingZeros(); // 0
  /// ```
  int countTrailingZeros() => _descriptor.countTrailingZeros(_);

  /// Returns a new [Uint16] with bits in [left] to [size].
  ///
  /// The result is left-padded with 0's.
  ///
  /// Both [left] and [size] must be in range.
  Uint16 bitChunk(int left, [int? size]) {
    RangeError.checkValidRange(0, left, width - 1, 'left');
    if (size != null) {
      RangeError.checkValidRange(0, size, width - left, 'size');
    }
    return uncheckedBitChunk(left, size);
  }

  /// Returns a new [Uint16] with bits in [left] to [size].
  ///
  /// The result is left-padded with 0's.
  ///
  /// If either [left] or [size] is out of range, the behavior is undefined.
  Uint16 uncheckedBitChunk(int left, [int? size]) {
    return _descriptor.uncheckedBitChunk(_, left, size);
  }

  /// Returns a new instance with bits [left] to [right], inclusive.
  ///
  /// The result is left-padded with 0's.
  ///
  /// Both [left] and [right] must be in range.
  Uint16 bitSlice(int left, [int? right]) {
    RangeError.checkValidRange(0, left, width - 1, 'left');
    if (right != null) {
      RangeError.checkValidRange(left, right, width - 1, 'right');
    }
    return uncheckedBitSlice(left, right);
  }

  /// Returns a new instance with bits [left] to [right], inclusive.
  ///
  /// The result is left-padded with 0's.
  ///
  /// If either [left] or [right] is out of range, the behavior is undefined.
  Uint16 uncheckedBitSlice(int left, [int? right]) {
    return _descriptor.uncheckedBitSlice(_, left, right);
  }

  /// Returns a new instance with bits [left] to [right], inclusive, replaced
  /// with the same number of bits from [replacement].
  ///
  /// Additional bits in [replacement] are ignored.
  ///
  /// Both [left] and [right] must be in range.
  Uint16 bitReplace(int left, int? right, int replacement) {
    RangeError.checkValidRange(0, left, width - 1, 'left');
    if (right != null) {
      RangeError.checkValidRange(left, right, width - 1, 'right');
    }
    return uncheckedBitReplace(left, right, replacement);
  }

  /// Returns a new instance with bits [left] to [right], inclusive, replaced
  /// with the same number of bits from [replacement].
  ///
  /// Additional bits in [replacement] are ignored.
  ///
  /// If either [left] or [right] is out of range, the behavior is undefined.
  Uint16 uncheckedBitReplace(int left, int? right, int replacement) {
    return _descriptor.uncheckedBitReplace(_, left, right, replacement);
  }

  /// Rotates the bits in `this` to the left by [n] positions.
  ///
  /// The bits that are rotated out of the integer are rotated back in from the
  /// other side.
  Uint16 rotateLeft(int n) => _descriptor.rotateLeft(_, n);

  /// Rotates the bits in `this` to the right by [n] positions.
  ///
  /// The bits that are rotated out of the integer are rotated back in from the
  /// other side.
  Uint16 rotateRight(int n) => _descriptor.rotateRight(_, n);

  /// Returns the _minimum_ number of bits required to store this integer.
  ///
  /// The result is always in the range of `0` to `width`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(0).bitLength(); // 0
  /// Uint16(1).bitLength(); // 1
  /// Uint16(2).bitLength(); // 2
  /// ```
  int get bitLength => _.bitLength;

  /// Whether this integer is the minimum value representable by this type.
  bool get isMin => identical(_, min);

  /// Whether this integer is the maximum value representable by this type.
  bool get isMax => identical(_, max);

  /// Returns true if and only if this integer is even.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).isEven; // true
  /// Uint16(3).isEven; // false
  /// ```
  bool get isEven => _.isEven;

  /// Returns true if and only if this integer is odd.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).isOdd; // false
  /// Uint16(3).isOdd; // true
  /// ```
  bool get isOdd => _.isOdd;

  /// Returns true if and only if this integer is zero.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(0).isZero; // true
  /// Uint16(3).isZero; // false
  /// ```
  bool get isZero => _ == 0;

  /// Returns true if and only if this integer is positive.
  ///
  /// A positive integer is greater than zero.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(0).isPositive; // false
  /// Uint16(3).isPositive; // true
  /// ```
  bool get isPositive => _ > 0;

  /// Returns `this` clamped to be in the range of [lowerLimit] and
  /// [upperLimit].
  ///
  /// The arguments [lowerLimit] and [upperLimit] must form a valid range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).clamp(Uint16(3), Uint16(5)); // 3
  /// Uint16(4).clamp(Uint16(3), Uint16(5)); // 4
  /// Uint16(6).clamp(Uint16(3), Uint16(5)); // 5
  /// ```
  Uint16 clamp(Uint16 lowerLimit, Uint16 upperLimit) {
    return Uint16.fromUnchecked(_.clamp(lowerLimit._, upperLimit._));
  }

  /// The remainder of the truncating division of `this` by [other].
  ///
  /// The result r of this operation satisfies: `this == (this ~/ other) *`
  /// `other + r`. As a consequence, the remainder `r` has the same sign as the
  /// dividend `this`.
  Uint16 remainder(Uint16 other) {
    return Uint16.fromUnchecked(_.remainder(other._));
  }

  /// This number as a [double].
  ///
  /// If an integer number is not precisely representable as a [double], an
  /// approximation is returned.
  double toDouble() => _.toDouble();

  /// This number as an [int].
  ///
  /// This is the underlying integer representation of a [Uint16], and is
  /// effectively an identity function, but for consistency and completeness,
  /// it is provided as a method to discourage casting.
  int toInt() => _;

  /// Returns this integer split into two parts: high and low bits.
  ///
  /// The high bits are the most significant bits, and the low bits are the
  /// least significant bits. This is the inverse of [Uint16.fromHiLo], and
  /// is useful for operations that require splitting an integer into two parts.
  (int hi, int lo) get hiLo => _descriptor.hiLo(_);

  /// Euclidean modulo of this number by other.
  ///
  /// The sign of the returned value is always positive.
  ///
  /// See [num.operator %] for more details.
  Uint16 operator %(Uint16 other) {
    return Uint16.fromUnchecked(_ % other._);
  }

  /// Multiplies this number by other.
  ///
  /// If the result is out of range, it asserts in debug mode, and wraps in
  /// release mode.
  ///
  /// See also:
  /// - [tryMultiply], which returns `null` if the result is out of range.
  /// - [wrappedMultiply], which wraps the result if it is out of range.
  /// - [clampedMultiply], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2) * Uint16(3); // 6
  /// ```
  Uint16 operator *(Uint16 other) => Uint16(_ * other._);

  /// Multiplies this number by other.
  ///
  /// If the result is out of range, the behavior is undefined.
  Uint16 uncheckedMultiply(Uint16 other) => Uint16.fromUnchecked(_ * other._);

  /// Multiplies this number by other.
  ///
  /// If the result is out of range, it returns `null`.
  ///
  /// See also:
  /// - [operator *], which asserts in debug mode, and wraps in release mode.
  /// - [wrappedMultiply], which wraps the result if it is out of range.
  /// - [clampedMultiply], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).tryMultiply(Uint16(3)); // 6
  /// ```
  Uint16? tryMultiply(Uint16 other) => tryFrom(_ * other._);

  /// Multiplies this number by other.
  ///
  /// If the result is out of range, it wraps the result.
  ///
  /// See also:
  /// - [operator *], which asserts in debug mode, and wraps in release mode.
  /// - [tryMultiply], which returns `null` if the result is out of range.
  /// - [clampedMultiply], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).wrappedMultiply(Uint16(3)); // 6
  /// ```
  Uint16 wrappedMultiply(Uint16 other) => Uint16.fromWrapped(_ * other._);

  /// Multiplies this number by other.
  ///
  /// If the result is out of range, it clamps the result.
  ///
  /// See also:
  /// - [operator *], which asserts in debug mode, and wraps in release mode.
  /// - [tryMultiply], which returns `null` if the result is out of range.
  /// - [wrappedMultiply], which wraps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).clampedMultiply(Uint16(3)); // 6
  /// ```
  Uint16 clampedMultiply(Uint16 other) => Uint16.fromClamped(_ * other._);

  /// Adds [other] to this number.
  ///
  /// If the result is out of range, it asserts in debug mode, and wraps in
  /// release mode.
  ///
  /// See also:
  /// - [tryAdd], which returns `null` if the result is out of range.
  /// - [wrappedAdd], which wraps the result if it is out of range.
  /// - [clampedAdd], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2) + Uint16(3); // 5
  /// ```
  Uint16 operator +(Uint16 other) => Uint16(_ + other._);

  /// Adds [other] to this number.
  ///
  /// If the result is out of range, the behavior is undefined.
  Uint16 uncheckedAdd(Uint16 other) => Uint16.fromUnchecked(_ + other._);

  /// Adds [other] to this number.
  ///
  /// If the result is out of range, it returns `null`.
  ///
  /// See also:
  /// - [operator +], which asserts in debug mode, and wraps in release mode.
  /// - [wrappedAdd], which wraps the result if it is out of range.
  /// - [clampedAdd], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).tryAdd(Uint16(3)); // 5
  /// ```
  Uint16? tryAdd(Uint16 other) => tryFrom(_ + other._);

  /// Adds [other] to this number.
  ///
  /// If the result is out of range, it wraps the result.
  ///
  /// See also:
  /// - [operator +], which asserts in debug mode, and wraps in release mode.
  /// - [tryAdd], which returns `null` if the result is out of range.
  /// - [clampedAdd], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).wrappedAdd(Uint16(3)); // 5
  /// ```
  Uint16 wrappedAdd(Uint16 other) => Uint16.fromWrapped(_ + other._);

  /// Adds [other] to this number.
  ///
  /// If the result is out of range, it clamps the result.
  ///
  /// See also:
  /// - [operator +], which asserts in debug mode, and wraps in release mode.
  /// - [tryAdd], which returns `null` if the result is out of range.
  /// - [wrappedAdd], which wraps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2).clampedAdd(Uint16(3)); // 5
  /// ```
  Uint16 clampedAdd(Uint16 other) => Uint16.fromClamped(_ + other._);

  /// Subtracts [other] from this number.
  ///
  /// If the result is out of range, it asserts in debug mode, and wraps in
  /// release mode.
  ///
  /// See also:
  /// - [trySubtract], which returns `null` if the result is out of range.
  /// - [wrappedSubtract], which wraps the result if it is out of range.
  /// - [clampedSubtract], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3) - Uint16(2); // 1
  /// ```
  Uint16 operator -(Uint16 other) => Uint16(_ - other._);

  /// Subtracts [other] from this number.
  ///
  /// If the result is out of range, the behavior is undefined.
  Uint16 uncheckedSubtract(Uint16 other) => Uint16.fromUnchecked(_ - other._);

  /// Subtracts [other] from this number.
  ///
  /// If the result is out of range, it returns `null`.
  ///
  /// See also:
  /// - [operator -], which asserts in debug mode, and wraps in release mode.
  /// - [wrappedSubtract], which wraps the result if it is out of range.
  /// - [clampedSubtract], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).trySubtract(Uint16(2)); // 1
  /// ```
  Uint16? trySubtract(Uint16 other) => tryFrom(_ - other._);

  /// Subtracts [other] from this number.
  ///
  /// If the result is out of range, it wraps the result.
  ///
  /// See also:
  /// - [operator -], which asserts in debug mode, and wraps in release mode.
  /// - [trySubtract], which returns `null` if the result is out of range.
  /// - [clampedSubtract], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).wrappedSubtract(Uint16(2)); // 1
  /// ```
  Uint16 wrappedSubtract(Uint16 other) => Uint16.fromWrapped(_ - other._);

  /// Subtracts [other] from this number.
  ///
  /// If the result is out of range, it clamps the result.
  ///
  /// See also:
  /// - [operator -], which asserts in debug mode, and wraps in release mode.
  /// - [trySubtract], which returns `null` if the result is out of range.
  /// - [wrappedSubtract], which wraps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).clampedSubtract(Uint16(2)); // 1
  /// ```
  Uint16 clampedSubtract(Uint16 other) => Uint16.fromClamped(_ - other._);

  /// Whether this number is numerically smaller than [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2) < Uint16(3); // true
  /// ```
  bool operator <(Uint16 other) => _ < other._;

  /// Whether this number is numerically smaller than or equal to [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(2) <= Uint16(3); // true
  /// Uint16(3) <= Uint16(3); // true
  /// ```
  bool operator <=(Uint16 other) => _ <= other._;

  /// Whether this number is numerically greater than [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3) > Uint16(2); // true
  /// ```
  bool operator >(Uint16 other) => _ > other._;

  /// Whether this number is numerically greater than or equal to [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3) >= Uint16(2); // true
  /// Uint16(3) >= Uint16(3); // true
  /// ```
  bool operator >=(Uint16 other) => _ >= other._;

  /// Truncating division operator.
  ///
  /// Performs truncating division of this number by [other]. Truncating
  /// division is division where a fractional result is converted to an integer
  /// by rounding towards zero.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(10) ~/ Uint16(3); // 3
  /// ```
  Uint16 operator ~/(Uint16 other) => Uint16.fromUnchecked(_ ~/ other._);

  /// Bit-wise and operator.
  ///
  /// See [int.operator &] for more details.
  Uint16 operator &(Uint16 other) => Uint16.fromUnchecked(_ & other._);

  /// Bit-wise or operator.
  ///
  /// See [int.operator |] for more details.
  Uint16 operator |(Uint16 other) => Uint16.fromUnchecked(_ | other._);

  /// Shifts the bits of this integer to the right by [shiftAmount].
  ///
  /// Shifting to the right makes the number smaller and drops the least
  /// significant bits, effectively doing an integer division by
  /// `pow(2, shiftAmount)`.
  ///
  /// [shiftAmount] must be non-negative.
  Uint16 operator >>(int shiftAmount) => Uint16.fromUnchecked(_ >> shiftAmount);

  /// Shifts the bits of this integer to the left by [shiftAmount].
  ///
  /// Shifting to the left makes the number larger, effectively multiplying the
  /// number by `pow(2, shiftAmount)`.
  ///
  /// If the result is out of range, it asserts in debug mode, and wraps in
  /// release mode.
  ///
  /// See also:
  /// - [tryShiftLeft], which returns `null` if the result is out of range.
  /// - [wrappedShiftLeft], which wraps the result if it is out of range.
  /// - [clampedShiftLeft], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3) << 2; // 12
  /// ```
  Uint16 operator <<(int shiftAmount) => Uint16(_ << shiftAmount);

  /// Shifts the bits of this integer to the left by [shiftAmount].
  ///
  /// If the result is out of range, the behavior is undefined.
  Uint16 uncheckedShiftLeft(int shiftAmount) {
    return Uint16.fromUnchecked(_ << shiftAmount);
  }

  /// Shifts the bits of this integer to the left by [shiftAmount].
  ///
  /// If the result is out of range, it returns `null`.
  ///
  /// See also:
  /// - [operator <<], which asserts in debug mode, and wraps in release mode.
  /// - [wrappedShiftLeft], which wraps the result if it is out of range.
  /// - [clampedShiftLeft], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).tryShiftLeft(2); // 12
  /// ```
  Uint16? tryShiftLeft(int shiftAmount) => tryFrom(_ << shiftAmount);

  /// Shifts the bits of this integer to the left by [shiftAmount].
  ///
  /// If the result is out of range, it wraps the result.
  ///
  /// See also:
  /// - [operator <<], which asserts in debug mode, and wraps in release mode.
  /// - [tryShiftLeft], which returns `null` if the result is out of range.
  /// - [clampedShiftLeft], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).wrappedShiftLeft(2); // 12
  /// ```
  Uint16 wrappedShiftLeft(int shiftAmount) {
    return Uint16.fromWrapped(_ << shiftAmount);
  }

  /// Shifts the bits of this integer to the left by [shiftAmount].
  ///
  /// If the result is out of range, it clamps the result.
  ///
  /// See also:
  ///
  /// - [operator <<], which asserts in debug mode, and wraps in release mode.
  /// - [tryShiftLeft], which returns `null` if the result is out of range.
  /// - [wrappedShiftLeft], which wraps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Uint16(3).clampedShiftLeft(2); // 12
  /// ```
  Uint16 clampedShiftLeft(int shiftAmount) {
    return Uint16.fromClamped(_ << shiftAmount);
  }

  /// Bitwise signed right shift by [shiftAmount] bits.
  ///
  /// The least significant shiftAmount bits are dropped, the remaining bits (if
  /// any) are shifted down, and the most significant bit is preserved.
  ///
  /// The shiftAmount must be non-negative.
  ///
  /// > [!NOTE]
  /// > This is intended to be roughly equivalent to JavaScript's `>>` operator.
  Uint16 signedRightShift(int shiftAmount) {
    return _descriptor.signedRightShift(_, shiftAmount);
  }

  /// Bitwise unsigned right shift by [shiftAmount] bits.
  ///
  /// The least significant shiftAmount bits are dropped, the remaining bits (if
  /// any) are shifted down, and zero-bits are shifted in as the new most
  /// significant bits.
  ///
  /// The shiftAmount must be non-negative.
  Uint16 operator >>>(int shiftAmount) =>
      Uint16.fromUnchecked(_ >>> shiftAmount);

  /// Bit-wise exclusive-or operator.
  ///
  /// See [int.operator ^] for more details.
  Uint16 operator ^(Uint16 other) => Uint16.fromUnchecked(_ ^ other._);

  /// Returns `this` sign-extended to the full width, from the [startWidth].
  ///
  /// All bits to the left (inclusive of [startWidth]) are replaced as a result.
  Uint16 signExtend(int startWidth) {
    return _descriptor.signExtend(_, startWidth);
  }

  /// Returns `this` as a binary string.
  String toBinaryString({bool padded = true}) {
    return _descriptor.toBinaryString(_, padded: padded);
  }
}