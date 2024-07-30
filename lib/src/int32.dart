import 'package:binary/src/descriptor.dart';
import 'package:binary/src/extension.dart';
import 'package:meta/meta.dart';

/// An signed 32-bit integer.
///
/// This type is _not_ explicitly boxed, and uses [extension types][]; that
/// means that _any_ [int] value _can_ be used as an Int32, but only values
/// in the range of [min] and [max] are considered valid.
///
/// [extension types]: https://dart.dev/language/extension-types
///
/// ## Constructing
///
/// For most use cases, use the default [Int32.new] constructor:
/// ```dart
/// Int32(3); // 3
/// ```
///
/// In _debug_ mode, an assertion is made that the value is in a valid range;
/// otherwise, the value is wrapped, if necessary, to fit in the valid range.
/// This behavior can be used explicitly with [Int32.fromWrapped]:
///
/// ```dart
/// Int32.fromWrapped(Int32.max + 1); // <min>
/// ```
///
/// See also:
/// - [Int32.fromClamped], which clamps the value if it is out of range.
/// - [Int32.tryFrom], which returns `null` if the value is out of range.
///
/// ## Operations
///
/// In most cases, every method available on [int] is also available on an
/// Int32; for example, [Int32.abs], [Int32.remainder], and so on.
///
/// Some methods that only make sense for unsigned integers are not available
/// for signed integers, and vice versa, and some methods that are typically
/// inherited from [num], but not useful for integers, are not available; these
/// can still be accessed through the underlying [int] value, using [toInt]:
///
/// ```dart
/// Int32(3).toInt().toStringAsExponential(); // "3e+0"
/// ```
///
/// ## Safety
///
/// Extension types are lightweight, but they are _not_ completely type-safe;
/// any [int] can be casted to an Int32, and will bypass the range checks;
/// we believe that the performance benefits outweigh the risks, but it is
/// important to be aware of this limitation.
///
/// This also applies to methods such as [List.cast] or [Iterable.whereType].
extension type const Int32._(int _) implements Comparable<num> {
  static const _descriptor = IntDescriptor<Int32>.signed(width: width);

  /// The minimum value that this type can represent.
  static const min = Int32.fromUnchecked(-2147483648);

  /// The maximum value that this type can represent.
  static const max = Int32.fromUnchecked(2147483647);

  /// The number of bits used to represent values of this type.
  static const width = 32;

  /// Defines [v] as an signed 32-bit integer, wrapping if necessary.
  ///
  /// In debug mode, an assertion is made that [v] is in a valid range.
  factory Int32(int v) => _descriptor.fit(v);

  /// Defines [v] as an signed 32-bit integer.
  ///
  /// Behavior is undefined if [v] is not in a valid range.
  const factory Int32.fromUnchecked(int v) = Int32._;

  /// Defines [v] as an signed 32-bit integer.
  ///
  /// Returns `null` if [v] is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32.tryFrom(Int32.max); // <max>
  /// Int32.tryFrom(Int32.max + 1); // null
  /// ```
  static Int32? tryFrom(int v) => _descriptor.fitChecked(v);

  /// Defines [v] as an signed 32-bit integer.
  ///
  /// If [v] is out of range, it is _wrapped_ to fit, similar to modular
  /// arithmetic:
  /// - If [v] is less than [min], the result is `v % (max + 1) + (max + 1)`.
  /// - If [v] is greater than [max], the result is `v % (max + 1)`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32.fromWrapped(Int32.min - 3); // <max - 3>
  /// Int32.fromWrapped(Int32.max + 3); // <min + 3>
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory Int32.fromWrapped(int v) => _descriptor.fitWrapped(v);

  /// Defines [v] as an signed 32-bit integer.
  ///
  /// If [v] is out of range, it is _clamped_ to fit:
  /// - If [v] is less than [min], the result is [min].
  /// - If [v] is greater than [max], the result is [max].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32.fromClamped(Int32.min - 3); // <min>
  /// Int32.fromClamped(Int32.max + 3); // <max>
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory Int32.fromClamped(int v) => _descriptor.fitClamping(v);

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
  /// Int32(2).pow(3); // 8
  /// ```
  Int32 pow(int exponent) => Int32(_.pow(exponent));

  /// Returns the exponention of this integer with the given [exponent].
  ///
  /// If the result is out of range, the behavior is undefined.
  Int32 uncheckedPow(int exponent) => Int32.fromUnchecked(_.pow(exponent));

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
  /// Int32(2).tryPow(3); // 8
  /// ```
  Int32? tryPow(int exponent) => tryFrom(_.pow(exponent));

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
  /// Int32(2).wrappedPow(3); // 8
  /// ```
  Int32 wrappedPow(int exponent) => Int32.fromWrapped(_.pow(exponent));

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
  /// Int32(2).clampedPow(3); // 8
  /// ```
  Int32 clampedPow(int exponent) => Int32.fromClamped(_.pow(exponent));

  /// Returns the square root of this integer, rounded down.
  ///
  /// `this` must be non-negative integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(9).sqrt(); // 3
  /// ```
  Int32 sqrt() => Int32.fromUnchecked(_.sqrt());

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
  /// Int32(8).log(); // 2
  /// Int32(8).log(2); // 3
  /// ```
  Int32 log([int base = 10]) => Int32.fromUnchecked(_.log(base));

  /// Returns the base 2 logarithm of this integer, rounded down.
  ///
  /// This is equivalent to `log(2)`.
  ///
  /// `this` must be positive integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(8).log2(); // 3
  /// ```
  Int32 log2() => Int32.fromUnchecked(_.log2());

  /// Returns the base 10 logarithm of this integer, rounded down.
  ///
  /// This is equivalent to `log(10)`.
  ///
  /// `this` must be positive integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(8).log10(); // 2
  /// ```
  Int32 log10() => Int32.fromUnchecked(_.log10());

  /// Returns the midpoint between this integer and [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(2).midpoint(Int32(4)); // 3
  /// ```
  Int32 midpoint(Int32 other) => Int32.fromUnchecked(_.midpoint(other._));

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
  Int32 setNthBit(int n, [bool value = true]) {
    RangeError.checkValidRange(n, 0, width - 1, 'n');
    return uncheckedSetNthBit(n, value);
  }

  /// Sets the n-th bit to [value], where `true` is `1` and `false` is `0`.
  ///
  /// If [n] is out of range, the behavior is undefined.
  // ignore: avoid_positional_boolean_parameters
  Int32 uncheckedSetNthBit(int n, [bool value = true]) {
    return Int32.fromUnchecked(_.setNthBit(n, value));
  }

  /// Toggles the n-th bit.
  ///
  /// [n] must be in the range of `0` to `width - 1`.
  Int32 toggleNthBit(int n) {
    RangeError.checkValidRange(n, 0, width - 1, 'n');
    return uncheckedToggleNthBit(n);
  }

  /// Toggles the n-th bit.
  ///
  /// If [n] is out of range, the behavior is undefined.
  Int32 uncheckedToggleNthBit(int n) {
    return Int32.fromUnchecked(_.toggleNthBit(n));
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
  /// Int32(3).nextPowerOf2(); // 4
  /// ```
  Int32 nextPowerOf2() => Int32(_.nextPowerOf2());

  /// Returns the smallest power of two greater than or equal to `this`.
  ///
  /// If `this` is already a power of two, it is returned.
  ///
  /// `this` must be a positive integer.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int32 uncheckedNextPowerOf2() => Int32.fromUnchecked(_.nextPowerOf2());

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
  /// Int32(3).tryNextPowerOf2(); // 4
  /// ```
  Int32? tryNextPowerOf2() => tryFrom(_.nextPowerOf2());

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
  /// Int32(3).wrappedNextPowerOf2(); // 4
  /// ```
  Int32 wrappedNextPowerOf2() => Int32.fromWrapped(_.nextPowerOf2());

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
  /// Int32(3).clampedNextPowerOf2(); // 4
  /// ```
  Int32 clampedNextPowerOf2() => Int32.fromClamped(_.nextPowerOf2());

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
  /// Int32(3).nextMultipleOf(2); // 4
  /// ```
  Int32 nextMultipleOf(Int32 n) => Int32(_.nextMultipleOf(n._));

  /// Calculates the smallest value greater than or equal to `this` that is
  ///
  /// a multiple of [n].
  ///
  /// `n` must be a positive integer.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int32 uncheckedNextMultipleOf(Int32 n) {
    return Int32.fromUnchecked(_.nextMultipleOf(n._));
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
  /// Int32(3).tryNextMultipleOf(2); // 4
  /// ```
  Int32? tryNextMultipleOf(Int32 n) => tryFrom(_.nextMultipleOf(n._));

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
  /// Int32(3).wrappedNextMultipleOf(2); // 4
  /// ```
  Int32 wrappedNextMultipleOf(Int32 n) {
    return Int32.fromWrapped(_.nextMultipleOf(n._));
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
  /// Int32(3).clampedNextMultipleOf(2); // 4
  /// ```
  Int32 clampedNextMultipleOf(Int32 n) {
    return Int32.fromClamped(_.nextMultipleOf(n._));
  }

  /// Returns the number of `1`s in the binary representation of `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(3).countOnes(); // 2
  /// ```
  int countOnes() => _.countOnes();

  /// Returns the number of leading ones in the binary representation of `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(3).countLeadingOnes(); // <width - 2>
  /// ```
  int countLeadingOnes() => _descriptor.countLeadingOnes(_);

  /// Returns the number of trailing ones in the binary representation of `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(3).countTrailingOnes(); // 0
  /// ```
  int countTrailingOnes() => _descriptor.countTrailingOnes(_);

  /// Returns the number of `0`s in the binary representation of `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(3).countZeros(); // <width - 2>
  /// ```
  int countZeros() => _descriptor.countZeros(_);

  /// Returns the number of leading zeros in the binary representation of
  /// `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(3).countLeadingZeros(); // <width - 2>
  /// ```
  int countLeadingZeros() => _descriptor.countLeadingZeros(_);

  /// Returns the number of trailing zeros in the binary representation of
  /// `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(3).countTrailingZeros(); // 0
  /// ```
  int countTrailingZeros() => _descriptor.countTrailingZeros(_);

  /// Returns a new [Int32] with bits in [left] to [size].
  ///
  /// The result is left-padded with 0's.
  ///
  /// Both [left] and [size] must be in range.
  Int32 bitChunk(int left, [int? size]) {
    RangeError.checkValidRange(left, 0, width - 1, 'left');
    if (size != null) {
      RangeError.checkValidRange(size, 0, width - left, 'size');
    }
    return _descriptor.uncheckedBitChunk(_, left, size);
  }

  /// Returns a new [Int32] with bits in [left] to [size].
  ///
  /// The result is left-padded with 0's.
  ///
  /// If either [left] or [size] is out of range, the behavior is undefined.
  Int32 uncheckedBitChunk(int left, [int? size]) {
    return _descriptor.uncheckedBitChunk(_, left, size);
  }

  /// Returns a new instance with bits [left] to [right], inclusive.
  ///
  /// The result is left-padded with 0's.
  ///
  /// Both [left] and [right] must be in range.
  Int32 bitSlice(int left, [int? right]) {
    RangeError.checkValidRange(left, 0, width - 1, 'left');
    if (right != null) {
      RangeError.checkValidRange(right, left, width - 1, 'right');
    }
    return _descriptor.uncheckedBitSlice(_, left, right);
  }

  /// Returns a new instance with bits [left] to [right], inclusive.
  ///
  /// The result is left-padded with 0's.
  ///
  /// If either [left] or [right] is out of range, the behavior is undefined.
  Int32 uncheckedBitSlice(int left, [int? right]) {
    return _descriptor.uncheckedBitSlice(_, left, right);
  }

  /// Returns a new instance with bits [left] to [right], inclusive, replaced
  /// with the same number of bits from [value].
  ///
  /// Additional bits in [value] are ignored.
  ///
  /// Both [left] and [right] must be in range.
  Int32 bitReplace(int value, int left, [int? right]) {
    RangeError.checkValidRange(left, 0, width - 1, 'left');
    if (right != null) {
      RangeError.checkValidRange(right, left, width - 1, 'right');
    }
    return _descriptor.uncheckedBitReplace(_, value, left, right);
  }

  /// Returns a new instance with bits [left] to [right], inclusive, replaced
  /// with the same number of bits from [value].
  ///
  /// Additional bits in [value] are ignored.
  ///
  /// If either [left] or [right] is out of range, the behavior is undefined.
  Int32 uncheckedBitReplace(int value, int left, [int? right]) {
    return _descriptor.uncheckedBitReplace(_, value, left, right);
  }

  /// Rotates the bits in `this` to the left by [n] positions.
  ///
  /// The bits that are rotated out of the integer are rotated back in from the
  /// other side.
  Int32 rotateLeft(int n) => _descriptor.rotateLeft(_, n);

  /// Rotates the bits in `this` to the right by [n] positions.
  ///
  /// The bits that are rotated out of the integer are rotated back in from the
  /// other side.
  Int32 rotateRight(int n) => _descriptor.rotateRight(_, n);

  /// Returns the absolute value of this integer.
  ///
  /// If the result is out of range, it asserts in debug mode, and wraps in
  /// release mode.
  ///
  /// See also:
  /// - [tryAbs], which returns `null` if the result is out of range.
  /// - [wrappedAbs], which wraps the result if it is out of range.
  /// - [clampedAbs], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(-3).abs(); // 3
  /// ```
  Int32 abs() => Int32(_.abs());

  /// Returns the absolute value of this integer.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int32 uncheckedAbs() => Int32.fromUnchecked(_.abs());

  /// Returns the absolute value of this integer.
  ///
  /// If the result is out of range, it returns `null`.
  ///
  /// See also:
  /// - [abs], which asserts in debug mode, and wraps in release mode.
  /// - [wrappedAbs], which wraps the result if it is out of range.
  /// - [clampedAbs], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(-3).tryAbs(); // 3
  /// ```
  Int32? tryAbs() => tryFrom(_.abs());

  /// Returns the absolute value of this integer.
  ///
  /// If the result is out of range, it wraps the result.
  ///
  /// See also:
  /// - [abs], which asserts in debug mode, and wraps in release mode.
  /// - [tryAbs], which returns `null` if the result is out of range.
  /// - [clampedAbs], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(-3).wrappedAbs(); // 3
  /// ```
  Int32 wrappedAbs() => Int32.fromWrapped(_.abs());

  /// Returns the absolute value of this integer.
  ///
  /// If the result is out of range, it clamps the result.
  ///
  /// See also:
  /// - [abs], which asserts in debug mode, and wraps in release mode.
  /// - [tryAbs], which returns `null` if the result is out of range.
  /// - [wrappedAbs], which wraps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(-3).clampedAbs(); // 3
  /// ```
  Int32 clampedAbs() => Int32.fromClamped(_.abs());

  /// Returns the _minimum_ number of bits required to store this integer.
  ///
  /// The result is always in the range of `0` to `width`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(0).bitLength(); // 0
  /// Int32(1).bitLength(); // 1
  /// Int32(2).bitLength(); // 2
  /// ```
  int get bitLength => _.bitLength;

  /// Returns true if and only if this integer is even.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(2).isEven; // true
  /// Int32(3).isEven; // false
  /// ```
  bool get isEven => _.isEven;

  /// Returns true if and only if this integer is odd.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(2).isOdd; // false
  /// Int32(3).isOdd; // true
  /// ```
  bool get isOdd => _.isOdd;

  /// Returns the sign of this integer.
  ///
  /// Returns 0 for zero, -1 for values less than zero and +1 for values greater
  /// than zero.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(-3).sign; // -1
  /// Int32(0).sign; // 0
  /// Int32(3).sign; // 1
  /// ```
  Int32 get sign => Int32.fromUnchecked(_.sign);

  /// Returns true if and only if this integer is zero.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(0).isZero; // true
  /// Int32(3).isZero; // false
  /// ```
  bool get isZero => _ == 0;

  /// Returns true if and only if this integer is positive.
  ///
  /// A positive integer is greater than zero.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(0).isPositive; // false
  /// Int32(3).isPositive; // true
  /// ```
  bool get isPositive => _ > 0;

  /// Returns true if and only if this integer is negative.
  ///
  /// A negative integer is less than zero.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(-3).isNegative; // true
  /// Int32(0).isNegative; // false
  /// ```
  bool get isNegative => _ < 0;

  /// Returns `this` clamped to be in the range of [lowerLimit] and
  /// [upperLimit].
  ///
  /// The arguments [lowerLimit] and [upperLimit] must form a valid range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(2).clamp(Int32(3), Int32(5)); // 3
  /// Int32(4).clamp(Int32(3), Int32(5)); // 4
  /// Int32(6).clamp(Int32(3), Int32(5)); // 5
  /// ```
  Int32 clamp(Int32 lowerLimit, Int32 upperLimit) {
    return Int32.fromUnchecked(_.clamp(lowerLimit._, upperLimit._));
  }

  /// The remainder of the truncating division of `this` by [other].
  ///
  /// The result r of this operation satisfies: `this == (this ~/ other) *`
  /// `other + r`. As a consequence, the remainder `r` has the same sign as the
  /// dividend `this`.
  Int32 remainder(Int32 other) {
    return Int32.fromUnchecked(_.remainder(other._));
  }

  /// This number as a [double].
  ///
  /// If an integer number is not precisely representable as a [double], an
  /// approximation is returned.
  double toDouble() => _.toDouble();

  /// This number as an [int].
  ///
  /// This is the underlying integer representation of a [Int32], and is
  /// effectively an identity function, but for consistency and completeness,
  /// it is provided as a method to discourage casting.
  int toInt() => _;

  /// Euclidean modulo of this number by other.
  ///
  /// The sign of the returned value is always positive.
  ///
  /// See [num.operator %] for more details.
  Int32 operator %(Int32 other) {
    return Int32.fromUnchecked(_ % other._);
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
  /// Int32(2) * Int32(3); // 6
  /// ```
  Int32 operator *(Int32 other) => Int32(_ * other._);

  /// Multiplies this number by other.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int32 uncheckedMultiply(Int32 other) => Int32.fromUnchecked(_ * other._);

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
  /// Int32(2).tryMultiply(Int32(3)); // 6
  /// ```
  Int32? tryMultiply(Int32 other) => tryFrom(_ * other._);

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
  /// Int32(2).wrappedMultiply(Int32(3)); // 6
  /// ```
  Int32 wrappedMultiply(Int32 other) => Int32.fromWrapped(_ * other._);

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
  /// Int32(2).clampedMultiply(Int32(3)); // 6
  /// ```
  Int32 clampedMultiply(Int32 other) => Int32.fromClamped(_ * other._);

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
  /// Int32(2) + Int32(3); // 5
  /// ```
  Int32 operator +(Int32 other) => Int32(_ + other._);

  /// Adds [other] to this number.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int32 uncheckedAdd(Int32 other) => Int32.fromUnchecked(_ + other._);

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
  /// Int32(2).tryAdd(Int32(3)); // 5
  /// ```
  Int32? tryAdd(Int32 other) => tryFrom(_ + other._);

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
  /// Int32(2).wrappedAdd(Int32(3)); // 5
  /// ```
  Int32 wrappedAdd(Int32 other) => Int32.fromWrapped(_ + other._);

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
  /// Int32(2).clampedAdd(Int32(3)); // 5
  /// ```
  Int32 clampedAdd(Int32 other) => Int32.fromClamped(_ + other._);

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
  /// Int32(3) - Int32(2); // 1
  /// ```
  Int32 operator -(Int32 other) => Int32(_ - other._);

  /// Subtracts [other] from this number.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int32 uncheckedSubtract(Int32 other) => Int32.fromUnchecked(_ - other._);

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
  /// Int32(3).trySubtract(Int32(2)); // 1
  /// ```
  Int32? trySubtract(Int32 other) => tryFrom(_ - other._);

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
  /// Int32(3).wrappedSubtract(Int32(2)); // 1
  /// ```
  Int32 wrappedSubtract(Int32 other) => Int32.fromWrapped(_ - other._);

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
  /// Int32(3).clampedSubtract(Int32(2)); // 1
  /// ```
  Int32 clampedSubtract(Int32 other) => Int32.fromClamped(_ - other._);

  /// Whether this number is numerically smaller than [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(2) < Int32(3); // true
  /// ```
  bool operator <(Int32 other) => _ < other._;

  /// Whether this number is numerically smaller than or equal to [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(2) <= Int32(3); // true
  /// Int32(3) <= Int32(3); // true
  /// ```
  bool operator <=(Int32 other) => _ <= other._;

  /// Whether this number is numerically greater than [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(3) > Int32(2); // true
  /// ```
  bool operator >(Int32 other) => _ > other._;

  /// Whether this number is numerically greater than or equal to [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(3) >= Int32(2); // true
  /// Int32(3) >= Int32(3); // true
  /// ```
  bool operator >=(Int32 other) => _ >= other._;

  /// The negation of `this`.
  ///
  /// If the result is out of range, it asserts in debug mode, and wraps in
  /// release mode.
  ///
  /// See also:
  /// - [tryNegate], which returns `null` if the result is out of range.
  /// - [wrappedNegate], which wraps the result if it is out of range.
  /// - [clampedNegate], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// -Int32(3); // -3
  /// ```
  Int32 operator -() => Int32(-_);

  /// The negation of `this`.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int32 uncheckedNegate() => Int32.fromUnchecked(-_);

  /// The negation of `this`.
  ///
  /// If the result is out of range, it returns `null`.
  ///
  /// See also:
  /// - [operator -], which asserts in debug mode, and wraps in release mode.
  /// - [wrappedNegate], which wraps the result if it is out of range.
  /// - [clampedNegate], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(3).tryNegate(); // -3
  /// ```
  Int32? tryNegate() => tryFrom(-_);

  /// The negation of `this`.
  ///
  /// If the result is out of range, it wraps the result.
  ///
  /// See also:
  /// - [operator -], which asserts in debug mode, and wraps in release mode.
  /// - [tryNegate], which returns `null` if the result is out of range.
  /// - [clampedNegate], which clamps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(3).wrappedNegate(); // -3
  /// ```
  Int32 wrappedNegate() => Int32.fromWrapped(-_);

  /// The negation of `this`.
  ///
  /// If the result is out of range, it clamps the result.
  ///
  /// See also:
  /// - [operator -], which asserts in debug mode, and wraps in release mode.
  /// - [tryNegate], which returns `null` if the result is out of range.
  /// - [wrappedNegate], which wraps the result if it is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(3).clampedNegate(); // -3
  /// ```
  Int32 clampedNegate() => Int32.fromClamped(-_);

  /// Truncating division operator.
  ///
  /// Performs truncating division of this number by [other]. Truncating
  /// division is division where a fractional result is converted to an integer
  /// by rounding towards zero.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int32(10) ~/ Int32(3); // 3
  /// ```
  Int32 operator ~/(int other) => Int32.fromUnchecked(_ ~/ other);

  /// Bit-wise and operator.
  ///
  /// See [int.operator &] for more details.
  Int32 operator &(Int32 other) => Int32.fromUnchecked(_ & other._);

  /// Bit-wise or operator.
  ///
  /// See [int.operator |] for more details.
  Int32 operator |(Int32 other) => Int32.fromUnchecked(_ | other._);

  /// Shifts the bits of this integer to the right by [shiftAmount].
  ///
  /// Shifting to the right makes the number smaller and drops the least
  /// significant bits, effectively doing an integer division by
  /// `pow(2, shiftAmount)`.
  ///
  /// [shiftAmount] must be non-negative.
  Int32 operator >>(int shiftAmount) => Int32.fromUnchecked(_ >> shiftAmount);

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
  /// Int32(3) << 2; // 12
  /// ```
  Int32 operator <<(int shiftAmount) => Int32(_ << shiftAmount);

  /// Shifts the bits of this integer to the left by [shiftAmount].
  ///
  /// If the result is out of range, the behavior is undefined.
  Int32 uncheckedShiftLeft(int shiftAmount) {
    return Int32.fromUnchecked(_ << shiftAmount);
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
  /// Int32(3).tryShiftLeft(2); // 12
  /// ```
  Int32? tryShiftLeft(int shiftAmount) => tryFrom(_ << shiftAmount);

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
  /// Int32(3).wrappedShiftLeft(2); // 12
  /// ```
  Int32 wrappedShiftLeft(int shiftAmount) {
    return Int32.fromWrapped(_ << shiftAmount);
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
  /// Int32(3).clampedShiftLeft(2); // 12
  /// ```
  Int32 clampedShiftLeft(int shiftAmount) {
    return Int32.fromClamped(_ << shiftAmount);
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
  Int32 signedRightShift(int shiftAmount) {
    return _descriptor.signedRightShift(_, shiftAmount);
  }

  /// Bitwise unsigned right shift by [shiftAmount] bits.
  ///
  /// The least significant shiftAmount bits are dropped, the remaining bits (if
  /// any) are shifted down, and zero-bits are shifted in as the new most
  /// significant bits.
  ///
  /// The shiftAmount must be non-negative.
  Int32 operator >>>(int shiftAmount) => Int32.fromUnchecked(_ >>> shiftAmount);

  /// Bit-wise exclusive-or operator.
  ///
  /// See [int.operator ^] for more details.
  Int32 operator ^(Int32 other) => Int32.fromUnchecked(_ ^ other._);

  /// The bit-wise negate operator.
  ///
  /// See [int.operator ~] for more details.
  Int32 operator ~() => Int32.fromUnchecked(~_);
}
