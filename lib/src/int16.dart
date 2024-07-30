// coverage:ignore-file

import 'package:binary/src/descriptor.dart';
import 'package:binary/src/extension.dart';
import 'package:meta/meta.dart';

/// A signed 16-bit integer.
///
/// This type is _not_ explicitly boxed, and uses [extension types][]; that
/// means that _any_ [int] value _can_ be used as an Int16, but only values
/// in the range of [min] and [max] are considered valid.
///
/// [extension types]: https://dart.dev/language/extension-types
///
/// ## Constructing
///
/// For most use cases, use the default [Int16.new] constructor:
/// ```dart
/// Int16(3); // 3
/// ```
///
/// In _debug_ mode, an assertion is made that the value is in a valid range;
/// otherwise, the value is wrapped, if necessary, to fit in the valid range.
/// This behavior can be used explicitly with [Int16.fromWrapped]:
///
/// ```dart
/// Int16.fromWrapped(Int16.max + 1); // <min>
/// ```
///
/// See also:
/// - [Int16.fromClamped], which clamps the value if it is out of range.
/// - [Int16.tryFrom], which returns `null` if the value is out of range.
///
/// ## Operations
///
/// In most cases, every method available on [int] is also available on an
/// Int16.
///
/// Some methods that only make sense for unsigned integers are not available
/// for signed integers, and vice versa, and some methods that are typically
/// inherited from [num], but not useful for integers, are not available; these
/// can still be accessed through the underlying [int] value, using [toInt]:
///
/// ```dart
/// Int16(3).toInt().toStringAsExponential(); // "3e+0"
/// ```
///
/// ## Safety
///
/// Extension types are lightweight, but they are _not_ completely type-safe;
/// any [int] can be casted to an Int16, and will bypass the range checks;
/// we believe that the performance benefits outweigh the risks, but it is
/// important to be aware of this limitation.
///
/// This also applies to methods such as [List.cast] or [Iterable.whereType].
extension type const Int16._(int _) implements Comparable<num> {
  static const _descriptor = IntDescriptor<Int16>.signed(
    Int16.fromUnchecked,
    width: width,
    max: 32767,
  );

  /// The minimum value that this type can represent.
  static const min = Int16.fromUnchecked(-32768);

  /// The maximum value that this type can represent.
  static const max = Int16.fromUnchecked(32767);

  /// The number of bits used to represent values of this type.
  static const width = 16;

  /// Defines [v] as A signed 16-bit integer, wrapping if necessary.
  ///
  /// In debug mode, an assertion is made that [v] is in a valid range.
  factory Int16(int v) => _descriptor.fit(v);

  /// Defines [v] as A signed 16-bit integer.
  ///
  /// Behavior is undefined if [v] is not in a valid range.
  const Int16.fromUnchecked(
    int v,
  )   : _ = v,
        assert(
          // Dart2JS crashes if the boolean is first in this expression, but have
          // not been able to reproduce it in a minimal example yet, so this is a
          // workaround.
          v >= -32768 && v <= 32767 || !debugCheckUncheckedInRange,
          'Value out of range: $v.\n\n'
          'This should never happen, and is likely a bug. To intentionally '
          'overflow, even in debug mode, set '
          '"-DdebugCheckUncheckedInRange=false" when running your program.',
        );

  /// Defines [v] as A signed 16-bit integer.
  ///
  /// Returns `null` if [v] is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16.tryFrom(Int16.max); // <max>
  /// Int16.tryFrom(Int16.max + 1); // null
  /// ```
  static Int16? tryFrom(int v) => _descriptor.fitChecked(v);

  /// Defines [v] as A signed 16-bit integer.
  ///
  /// If [v] is out of range, it is _wrapped_ to fit, similar to modular
  /// arithmetic:
  /// - If [v] is less than [min], the result is `v % (max + 1) + (max + 1)`.
  /// - If [v] is greater than [max], the result is `v % (max + 1)`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16.fromWrapped(Int16.min - 3); // <max - 3>
  /// Int16.fromWrapped(Int16.max + 3); // <min + 3>
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory Int16.fromWrapped(int v) => _descriptor.fitWrapped(v);

  /// Defines [v] as A signed 16-bit integer.
  ///
  /// If [v] is out of range, it is _clamped_ to fit:
  /// - If [v] is less than [min], the result is [min].
  /// - If [v] is greater than [max], the result is [max].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16.fromClamped(Int16.min - 3); // <min>
  /// Int16.fromClamped(Int16.max + 3); // <max>
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory Int16.fromClamped(int v) => _descriptor.fitClamping(v);

  /// Creates a [Int16] using two integers as high and low bits.
  ///
  /// Each integer should be in the range of `0` to `2^(16 / 2) - 1`;
  /// extra bits are ignored.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory Int16.fromHiLo(int hi, int lo) {
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
  /// Int16(2).pow(3); // 8
  /// ```
  Int16 pow(int exponent) => Int16(_.pow(exponent));

  /// Returns the exponention of this integer with the given [exponent].
  ///
  /// If the result is out of range, the behavior is undefined.
  Int16 uncheckedPow(int exponent) => Int16.fromUnchecked(_.pow(exponent));

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
  /// Int16(2).tryPow(3); // 8
  /// ```
  Int16? tryPow(int exponent) => tryFrom(_.pow(exponent));

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
  /// Int16(2).wrappedPow(3); // 8
  /// ```
  Int16 wrappedPow(int exponent) => Int16.fromWrapped(_.pow(exponent));

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
  /// Int16(2).clampedPow(3); // 8
  /// ```
  Int16 clampedPow(int exponent) => Int16.fromClamped(_.pow(exponent));

  /// Returns the square root of this integer, rounded down.
  ///
  /// `this` must be non-negative integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(9).sqrt(); // 3
  /// ```
  Int16 sqrt() => Int16.fromUnchecked(_.sqrt());

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
  /// Int16(8).log(); // 2
  /// Int16(8).log(2); // 3
  /// ```
  Int16 log([int? base]) => Int16.fromUnchecked(_.log(base));

  /// Returns the base 2 logarithm of this integer, rounded down.
  ///
  /// This is equivalent to `log(2)`.
  ///
  /// `this` must be positive integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(8).log2(); // 3
  /// ```
  Int16 log2() => Int16.fromUnchecked(_.log2());

  /// Returns the base 10 logarithm of this integer, rounded down.
  ///
  /// This is equivalent to `log(10)`.
  ///
  /// `this` must be positive integer.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(8).log10(); // 2
  /// ```
  Int16 log10() => Int16.fromUnchecked(_.log10());

  /// Returns the midpoint between this integer and [other], rounded down.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(2).midpoint(Int16(4)); // 3
  /// ```
  Int16 midpoint(Int16 other) => Int16.fromUnchecked(_.midpoint(other._));

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
  Int16 setNthBit(int n, [bool value = true]) {
    RangeError.checkValidRange(0, n, width - 1, 'n');
    return uncheckedSetNthBit(n, value);
  }

  /// Sets the n-th bit to [value], where `true` is `1` and `false` is `0`.
  ///
  /// If [n] is out of range, the behavior is undefined.
  // ignore: avoid_positional_boolean_parameters
  Int16 uncheckedSetNthBit(int n, [bool value = true]) {
    return _descriptor.uncheckedSetNthBit(_, n, value);
  }

  /// Toggles the n-th bit.
  ///
  /// [n] must be in the range of `0` to `width - 1`.
  Int16 toggleNthBit(int n) {
    RangeError.checkValidRange(0, n, width - 1, 'n');
    return uncheckedToggleNthBit(n);
  }

  /// Toggles the n-th bit.
  ///
  /// If [n] is out of range, the behavior is undefined.
  Int16 uncheckedToggleNthBit(int n) {
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
  /// Int16(3).nextPowerOf2(); // 4
  /// ```
  Int16 nextPowerOf2() => Int16(_.nextPowerOf2());

  /// Returns the smallest power of two greater than or equal to `this`.
  ///
  /// If `this` is already a power of two, it is returned.
  ///
  /// `this` must be a positive integer.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int16 uncheckedNextPowerOf2() => Int16.fromUnchecked(_.nextPowerOf2());

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
  /// Int16(3).tryNextPowerOf2(); // 4
  /// ```
  Int16? tryNextPowerOf2() => tryFrom(_.nextPowerOf2());

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
  /// Int16(3).wrappedNextPowerOf2(); // 4
  /// ```
  Int16 wrappedNextPowerOf2() => Int16.fromWrapped(_.nextPowerOf2());

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
  /// Int16(3).clampedNextPowerOf2(); // 4
  /// ```
  Int16 clampedNextPowerOf2() => Int16.fromClamped(_.nextPowerOf2());

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
  /// Int16(3).nextMultipleOf(2); // 4
  /// ```
  Int16 nextMultipleOf(Int16 n) => Int16(_.nextMultipleOf(n._));

  /// Calculates the smallest value greater than or equal to `this` that is
  ///
  /// a multiple of [n].
  ///
  /// `n` must be a positive integer.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int16 uncheckedNextMultipleOf(Int16 n) {
    return Int16.fromUnchecked(_.nextMultipleOf(n._));
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
  /// Int16(3).tryNextMultipleOf(2); // 4
  /// ```
  Int16? tryNextMultipleOf(Int16 n) => tryFrom(_.nextMultipleOf(n._));

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
  /// Int16(3).wrappedNextMultipleOf(2); // 4
  /// ```
  Int16 wrappedNextMultipleOf(Int16 n) {
    return Int16.fromWrapped(_.nextMultipleOf(n._));
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
  /// Int16(3).clampedNextMultipleOf(2); // 4
  /// ```
  Int16 clampedNextMultipleOf(Int16 n) {
    return Int16.fromClamped(_.nextMultipleOf(n._));
  }

  /// Returns the number of `1`s in the binary representation of `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(3).countOnes(); // 2
  /// ```
  int countOnes() => _descriptor.countOnes(_);

  /// Returns the number of trailing ones in the binary representation of `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(3).countTrailingOnes(); // 0
  /// ```
  int countTrailingOnes() => _descriptor.countTrailingOnes(_);

  /// Returns the number of `0`s in the binary representation of `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(3).countZeros(); // <width - 2>
  /// ```
  int countZeros() => _descriptor.countZeros(_);

  /// Returns the number of leading zeros in the binary representation of
  /// `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(3).countLeadingZeros(); // <width - 2>
  /// ```
  int countLeadingZeros() => _descriptor.countLeadingZeros(_);

  /// Returns the number of trailing zeros in the binary representation of
  /// `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(3).countTrailingZeros(); // 0
  /// ```
  int countTrailingZeros() => _descriptor.countTrailingZeros(_);

  /// Returns a new [Int16] with bits in [left] to [size].
  ///
  /// The result is left-padded with 0's.
  ///
  /// Both [left] and [size] must be in range.
  Int16 bitChunk(int left, [int? size]) {
    RangeError.checkValidRange(0, left, width - 1, 'left');
    if (size != null) {
      RangeError.checkValidRange(0, size, width - left, 'size');
    }
    return uncheckedBitChunk(left, size);
  }

  /// Returns a new [Int16] with bits in [left] to [size].
  ///
  /// The result is left-padded with 0's.
  ///
  /// If either [left] or [size] is out of range, the behavior is undefined.
  Int16 uncheckedBitChunk(int left, [int? size]) {
    return _descriptor.uncheckedBitChunk(_, left, size);
  }

  /// Returns a new instance with bits [left] to [right], inclusive.
  ///
  /// The result is left-padded with 0's.
  ///
  /// Both [left] and [right] must be in range.
  Int16 bitSlice(int left, [int? right]) {
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
  Int16 uncheckedBitSlice(int left, [int? right]) {
    return _descriptor.uncheckedBitSlice(_, left, right);
  }

  /// Returns a new instance with bits [left] to [right], inclusive, replaced
  /// with the same number of bits from [replacement].
  ///
  /// Additional bits in [replacement] are ignored.
  ///
  /// Both [left] and [right] must be in range.
  Int16 bitReplace(int left, int? right, int replacement) {
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
  Int16 uncheckedBitReplace(int left, int? right, int replacement) {
    return _descriptor.uncheckedBitReplace(_, left, right, replacement);
  }

  /// Rotates the bits in `this` to the left by [n] positions.
  ///
  /// The bits that are rotated out of the integer are rotated back in from the
  /// other side.
  Int16 rotateLeft(int n) => _descriptor.rotateLeft(_, n);

  /// Rotates the bits in `this` to the right by [n] positions.
  ///
  /// The bits that are rotated out of the integer are rotated back in from the
  /// other side.
  Int16 rotateRight(int n) => _descriptor.rotateRight(_, n);

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
  /// Int16(-3).abs(); // 3
  /// ```
  Int16 abs() => Int16(_.abs());

  /// Returns the absolute value of this integer.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int16 uncheckedAbs() => Int16.fromUnchecked(_.abs());

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
  /// Int16(-3).tryAbs(); // 3
  /// ```
  Int16? tryAbs() => tryFrom(_.abs());

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
  /// Int16(-3).wrappedAbs(); // 3
  /// ```
  Int16 wrappedAbs() => Int16.fromWrapped(_.abs());

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
  /// Int16(-3).clampedAbs(); // 3
  /// ```
  Int16 clampedAbs() => Int16.fromClamped(_.abs());

  /// Returns the _minimum_ number of bits required to store this integer.
  ///
  /// The result is always in the range of `0` to `width`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(0).bitLength(); // 0
  /// Int16(1).bitLength(); // 1
  /// Int16(2).bitLength(); // 2
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
  /// Int16(2).isEven; // true
  /// Int16(3).isEven; // false
  /// ```
  bool get isEven => _.isEven;

  /// Returns true if and only if this integer is odd.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(2).isOdd; // false
  /// Int16(3).isOdd; // true
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
  /// Int16(-3).sign; // -1
  /// Int16(0).sign; // 0
  /// Int16(3).sign; // 1
  /// ```
  Int16 get sign => Int16.fromUnchecked(_.sign);

  /// Returns true if and only if this integer is zero.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(0).isZero; // true
  /// Int16(3).isZero; // false
  /// ```
  bool get isZero => _ == 0;

  /// Returns true if and only if this integer is positive.
  ///
  /// A positive integer is greater than zero.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(0).isPositive; // false
  /// Int16(3).isPositive; // true
  /// ```
  bool get isPositive => _ > 0;

  /// Returns true if and only if this integer is negative.
  ///
  /// A negative integer is less than zero.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(-3).isNegative; // true
  /// Int16(0).isNegative; // false
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
  /// Int16(2).clamp(Int16(3), Int16(5)); // 3
  /// Int16(4).clamp(Int16(3), Int16(5)); // 4
  /// Int16(6).clamp(Int16(3), Int16(5)); // 5
  /// ```
  Int16 clamp(Int16 lowerLimit, Int16 upperLimit) {
    return Int16.fromUnchecked(_.clamp(lowerLimit._, upperLimit._));
  }

  /// The remainder of the truncating division of `this` by [other].
  ///
  /// The result r of this operation satisfies: `this == (this ~/ other) *`
  /// `other + r`. As a consequence, the remainder `r` has the same sign as the
  /// dividend `this`.
  Int16 remainder(Int16 other) {
    return Int16.fromUnchecked(_.remainder(other._));
  }

  /// This number as a [double].
  ///
  /// If an integer number is not precisely representable as a [double], an
  /// approximation is returned.
  double toDouble() => _.toDouble();

  /// This number as an [int].
  ///
  /// This is the underlying integer representation of a [Int16], and is
  /// effectively an identity function, but for consistency and completeness,
  /// it is provided as a method to discourage casting.
  int toInt() => _;

  /// Returns this integer split into two parts: high and low bits.
  ///
  /// The high bits are the most significant bits, and the low bits are the
  /// least significant bits. This is the inverse of [Int16.fromHiLo], and
  /// is useful for operations that require splitting an integer into two parts.
  (int hi, int lo) get hiLo => _descriptor.hiLo(_);

  /// Euclidean modulo of this number by other.
  ///
  /// The sign of the returned value is always positive.
  ///
  /// See [num.operator %] for more details.
  Int16 operator %(Int16 other) {
    return Int16.fromUnchecked(_ % other._);
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
  /// Int16(2) * Int16(3); // 6
  /// ```
  Int16 operator *(Int16 other) => Int16(_ * other._);

  /// Multiplies this number by other.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int16 uncheckedMultiply(Int16 other) => Int16.fromUnchecked(_ * other._);

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
  /// Int16(2).tryMultiply(Int16(3)); // 6
  /// ```
  Int16? tryMultiply(Int16 other) => tryFrom(_ * other._);

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
  /// Int16(2).wrappedMultiply(Int16(3)); // 6
  /// ```
  Int16 wrappedMultiply(Int16 other) => Int16.fromWrapped(_ * other._);

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
  /// Int16(2).clampedMultiply(Int16(3)); // 6
  /// ```
  Int16 clampedMultiply(Int16 other) => Int16.fromClamped(_ * other._);

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
  /// Int16(2) + Int16(3); // 5
  /// ```
  Int16 operator +(Int16 other) => Int16(_ + other._);

  /// Adds [other] to this number.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int16 uncheckedAdd(Int16 other) => Int16.fromUnchecked(_ + other._);

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
  /// Int16(2).tryAdd(Int16(3)); // 5
  /// ```
  Int16? tryAdd(Int16 other) => tryFrom(_ + other._);

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
  /// Int16(2).wrappedAdd(Int16(3)); // 5
  /// ```
  Int16 wrappedAdd(Int16 other) => Int16.fromWrapped(_ + other._);

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
  /// Int16(2).clampedAdd(Int16(3)); // 5
  /// ```
  Int16 clampedAdd(Int16 other) => Int16.fromClamped(_ + other._);

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
  /// Int16(3) - Int16(2); // 1
  /// ```
  Int16 operator -(Int16 other) => Int16(_ - other._);

  /// Subtracts [other] from this number.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int16 uncheckedSubtract(Int16 other) => Int16.fromUnchecked(_ - other._);

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
  /// Int16(3).trySubtract(Int16(2)); // 1
  /// ```
  Int16? trySubtract(Int16 other) => tryFrom(_ - other._);

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
  /// Int16(3).wrappedSubtract(Int16(2)); // 1
  /// ```
  Int16 wrappedSubtract(Int16 other) => Int16.fromWrapped(_ - other._);

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
  /// Int16(3).clampedSubtract(Int16(2)); // 1
  /// ```
  Int16 clampedSubtract(Int16 other) => Int16.fromClamped(_ - other._);

  /// Whether this number is numerically smaller than [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(2) < Int16(3); // true
  /// ```
  bool operator <(Int16 other) => _ < other._;

  /// Whether this number is numerically smaller than or equal to [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(2) <= Int16(3); // true
  /// Int16(3) <= Int16(3); // true
  /// ```
  bool operator <=(Int16 other) => _ <= other._;

  /// Whether this number is numerically greater than [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(3) > Int16(2); // true
  /// ```
  bool operator >(Int16 other) => _ > other._;

  /// Whether this number is numerically greater than or equal to [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(3) >= Int16(2); // true
  /// Int16(3) >= Int16(3); // true
  /// ```
  bool operator >=(Int16 other) => _ >= other._;

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
  /// -Int16(3); // -3
  /// ```
  Int16 operator -() => Int16(-_);

  /// The negation of `this`.
  ///
  /// If the result is out of range, the behavior is undefined.
  Int16 uncheckedNegate() => Int16.fromUnchecked(-_);

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
  /// Int16(3).tryNegate(); // -3
  /// ```
  Int16? tryNegate() => tryFrom(-_);

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
  /// Int16(3).wrappedNegate(); // -3
  /// ```
  Int16 wrappedNegate() => Int16.fromWrapped(-_);

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
  /// Int16(3).clampedNegate(); // -3
  /// ```
  Int16 clampedNegate() => Int16.fromClamped(-_);

  /// Truncating division operator.
  ///
  /// Performs truncating division of this number by [other]. Truncating
  /// division is division where a fractional result is converted to an integer
  /// by rounding towards zero.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Int16(10) ~/ Int16(3); // 3
  /// ```
  Int16 operator ~/(Int16 other) => Int16.fromUnchecked(_ ~/ other._);

  /// Bit-wise and operator.
  ///
  /// See [int.operator &] for more details.
  Int16 operator &(Int16 other) => Int16.fromUnchecked(_ & other._);

  /// Bit-wise or operator.
  ///
  /// See [int.operator |] for more details.
  Int16 operator |(Int16 other) => Int16.fromUnchecked(_ | other._);

  /// Shifts the bits of this integer to the right by [shiftAmount].
  ///
  /// Shifting to the right makes the number smaller and drops the least
  /// significant bits, effectively doing an integer division by
  /// `pow(2, shiftAmount)`.
  ///
  /// [shiftAmount] must be non-negative.
  Int16 operator >>(int shiftAmount) => Int16.fromUnchecked(_ >> shiftAmount);

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
  /// Int16(3) << 2; // 12
  /// ```
  Int16 operator <<(int shiftAmount) => Int16(_ << shiftAmount);

  /// Shifts the bits of this integer to the left by [shiftAmount].
  ///
  /// If the result is out of range, the behavior is undefined.
  Int16 uncheckedShiftLeft(int shiftAmount) {
    return Int16.fromUnchecked(_ << shiftAmount);
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
  /// Int16(3).tryShiftLeft(2); // 12
  /// ```
  Int16? tryShiftLeft(int shiftAmount) => tryFrom(_ << shiftAmount);

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
  /// Int16(3).wrappedShiftLeft(2); // 12
  /// ```
  Int16 wrappedShiftLeft(int shiftAmount) {
    return Int16.fromWrapped(_ << shiftAmount);
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
  /// Int16(3).clampedShiftLeft(2); // 12
  /// ```
  Int16 clampedShiftLeft(int shiftAmount) {
    return Int16.fromClamped(_ << shiftAmount);
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
  Int16 signedRightShift(int shiftAmount) {
    return _descriptor.signedRightShift(_, shiftAmount);
  }

  /// Bitwise unsigned right shift by [shiftAmount] bits.
  ///
  /// The least significant shiftAmount bits are dropped, the remaining bits (if
  /// any) are shifted down, and zero-bits are shifted in as the new most
  /// significant bits.
  ///
  /// The shiftAmount must be non-negative.
  Int16 operator >>>(int shiftAmount) => Int16.fromUnchecked(_ >>> shiftAmount);

  /// Bit-wise exclusive-or operator.
  ///
  /// See [int.operator ^] for more details.
  Int16 operator ^(Int16 other) => Int16.fromUnchecked(_ ^ other._);

  /// The bit-wise negate operator.
  ///
  /// The bitwise compliment of an unsigned integer is its two's complement,
  /// or the number inverted.
  Int16 operator ~() => Int16(~_);

  /// Returns `this` sign-extended to the full width, from the [startWidth].
  ///
  /// All bits to the left (inclusive of [startWidth]) are replaced as a result.
  Int16 signExtend(int startWidth) {
    return _descriptor.signExtend(_, startWidth);
  }

  /// Returns `this` as a binary string.
  String toBinaryString({bool padded = true}) {
    return _descriptor.toBinaryString(_, padded: padded);
  }
}