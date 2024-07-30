import 'package:binary/src/descriptor.dart';
import 'package:binary/src/extension.dart';
import 'package:meta/meta.dart';

/// An {{DESCRIPTION}}.
/// 
/// This type is _not_ explicitly boxed, and uses [extension types][]; that
/// means that _any_ [int] value _can_ be used as an {{NAME}}, but only values
/// in the range of [min] and [max] are considered valid.
/// 
/// [extension types]: https://dart.dev/language/extension-types
/// 
/// ## Constructing
/// 
/// For most use cases, use the default [{{NAME}}.new] constructor:
/// ```dart
/// {{NAME}}(3); // 3
/// ```
/// 
/// In _debug_ mode, an assertion is made that the value is in a valid range;
/// otherwise, the value is wrapped, if necessary, to fit in the valid range.
/// This behavior can be used explicitly with [{{NAME}}.fromWrapped]:
/// 
/// ```dart
/// {{NAME}}.fromWrapped({{NAME}}.max + 1); // <min>
/// ```
/// 
/// See also:
/// - [{{NAME}}.fromClamped], which clamps the value if it is out of range.
/// - [{{NAME}}.tryFrom], which returns `null` if the value is out of range.
/// 
/// ## Operations
/// 
/// In most cases, every method available on [int] is also available on an
/// {{NAME}}; for example, [{{NAME}}.abs], [{{NAME}}.remainder], and so on.
/// 
/// Some methods that only make sense for unsigned integers are not available
/// for signed integers, and vice versa, and some methods that are typically
/// inherited from [num], but not useful for integers, are not available; these
/// can still be accessed through the underlying [int] value, using [toInt]:
/// 
/// ```dart
/// {{NAME}}(3).toInt().toStringAsExponential(); // "3e+0"
/// ```
/// 
/// ## Safety
/// 
/// Extension types are lightweight, but they are _not_ completely type-safe;
/// any [int] can be casted to an {{NAME}}, and will bypass the range checks;
/// we believe that the performance benefits outweigh the risks, but it is
/// important to be aware of this limitation.
/// 
/// This also applies to methods such as [List.cast] or [Iterable.whereType].
extension type const {{NAME}}._(int _) implements Comparable<num> {
  static const _descriptor = IntDescriptor<{{NAME}}>.{{CONSTRUCTOR}}(width: width);

  /// The minimum value that this type can represent.
  static const min = {{NAME}}.fromUnchecked({{MIN}});

  /// The maximum value that this type can represent.
  static const max = {{NAME}}.fromUnchecked({{MAX}});

  /// The number of bits used to represent values of this type.
  static const width = {{WIDTH}};

  /// Defines [v] as an {{DESCRIPTION}}, wrapping if necessary.
  ///
  /// In debug mode, an assertion is made that [v] is in a valid range.
  factory {{NAME}}(int v) => _descriptor.fit(v);

  /// Defines [v] as an {{DESCRIPTION}}.
  ///
  /// Behavior is undefined if [v] is not in a valid range.
  const factory {{NAME}}.fromUnchecked(int v) = {{NAME}}._;

  /// Defines [v] as an {{DESCRIPTION}}.
  ///
  /// Returns `null` if [v] is out of range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// {{NAME}}.tryFrom({{NAME}}.max); // <max>
  /// {{NAME}}.tryFrom({{NAME}}.max + 1); // null
  /// ```
  static {{NAME}}? tryFrom(int v) => _descriptor.fitChecked(v);

  /// Defines [v] as an {{DESCRIPTION}}.
  ///
  /// If [v] is out of range, it is _wrapped_ to fit, similar to modular
  /// arithmetic:
  /// - If [v] is less than [min], the result is `v % (max + 1) + (max + 1)`.
  /// - If [v] is greater than [max], the result is `v % (max + 1)`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// {{NAME}}.fromWrapped({{NAME}}.min - 3); // <max - 3>
  /// {{NAME}}.fromWrapped({{NAME}}.max + 3); // <min + 3>
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory {{NAME}}.fromWrapped(int v) => _descriptor.fitWrapped(v);

  /// Defines [v] as an {{DESCRIPTION}}.
  ///
  /// If [v] is out of range, it is _clamped_ to fit:
  /// - If [v] is less than [min], the result is [min].
  /// - If [v] is greater than [max], the result is [max].
  ///
  /// ## Example
  ///
  /// ```dart
  /// {{NAME}}.fromClamped({{NAME}}.min - 3); // <min>
  /// {{NAME}}.fromClamped({{NAME}}.max + 3); // <max>
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory {{NAME}}.fromClamped(int v) => _descriptor.fitClamping(v);

  /// Creates a [{{NAME}}] using two integers as high and low bits.
  /// 
  /// Each integer should be in the range of `0` to `2^({{WIDTH}} / 2) - 1`;
  /// extra bits are ignored.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory {{NAME}}.fromHiLo(int hi, int lo) {
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
  /// {{NAME}}(2).pow(3); // 8
  /// ```
  {{NAME}} pow(int exponent) => {{NAME}}(_.pow(exponent));

  /// Returns the exponention of this integer with the given [exponent].
  /// 
  /// If the result is out of range, the behavior is undefined.
  {{NAME}} uncheckedPow(int exponent) => {{NAME}}.fromUnchecked(_.pow(exponent));

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
  /// {{NAME}}(2).tryPow(3); // 8
  /// ```
  {{NAME}}? tryPow(int exponent) => tryFrom(_.pow(exponent));

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
  /// {{NAME}}(2).wrappedPow(3); // 8
  /// ```
  {{NAME}} wrappedPow(int exponent) => {{NAME}}.fromWrapped(_.pow(exponent));

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
  /// {{NAME}}(2).clampedPow(3); // 8
  /// ```
  {{NAME}} clampedPow(int exponent) => {{NAME}}.fromClamped(_.pow(exponent));

  /// Returns the square root of this integer, rounded down.
  /// 
  /// `this` must be non-negative integer.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(9).sqrt(); // 3
  /// ```
  {{NAME}} sqrt() => {{NAME}}.fromUnchecked(_.sqrt());

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
  /// {{NAME}}(8).log(); // 2
  /// {{NAME}}(8).log(2); // 3
  /// ```
  {{NAME}} log([int base = 10]) => {{NAME}}.fromUnchecked(_.log(base));

  /// Returns the base 2 logarithm of this integer, rounded down.
  /// 
  /// This is equivalent to `log(2)`.
  /// 
  /// `this` must be positive integer.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(8).log2(); // 3
  /// ```
  {{NAME}} log2() => {{NAME}}.fromUnchecked(_.log2());

  /// Returns the base 10 logarithm of this integer, rounded down.
  /// 
  /// This is equivalent to `log(10)`.
  /// 
  /// `this` must be positive integer.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(8).log10(); // 2
  /// ```
  {{NAME}} log10() => {{NAME}}.fromUnchecked(_.log10());

  /// Returns the midpoint between this integer and [other].
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(2).midpoint({{NAME}}(4)); // 3
  /// ```
  {{NAME}} midpoint({{NAME}} other) => {{NAME}}.fromUnchecked(_.midpoint(other._));

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
  {{NAME}} setNthBit(int n, [bool value = true]) {
    RangeError.checkValidRange(n, 0, width - 1, 'n');
    return uncheckedSetNthBit(n, value);
  }

  /// Sets the n-th bit to [value], where `true` is `1` and `false` is `0`.
  /// 
  /// If [n] is out of range, the behavior is undefined.
  // ignore: avoid_positional_boolean_parameters
  {{NAME}} uncheckedSetNthBit(int n, [bool value = true]) {
    return {{NAME}}.fromUnchecked(_.setNthBit(n, value));
  }

  /// Toggles the n-th bit.
  /// 
  /// [n] must be in the range of `0` to `width - 1`.
  {{NAME}} toggleNthBit(int n) {
    RangeError.checkValidRange(n, 0, width - 1, 'n');
    return uncheckedToggleNthBit(n);
  }

  /// Toggles the n-th bit.
  /// 
  /// If [n] is out of range, the behavior is undefined.
  {{NAME}} uncheckedToggleNthBit(int n) {
    return {{NAME}}.fromUnchecked(_.toggleNthBit(n));
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
  /// {{NAME}}(3).nextPowerOf2(); // 4
  /// ```
  {{NAME}} nextPowerOf2() => {{NAME}}(_.nextPowerOf2());

  /// Returns the smallest power of two greater than or equal to `this`.
  /// 
  /// If `this` is already a power of two, it is returned.
  /// 
  /// `this` must be a positive integer.
  /// 
  /// If the result is out of range, the behavior is undefined.
  {{NAME}} uncheckedNextPowerOf2() => {{NAME}}.fromUnchecked(_.nextPowerOf2());

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
  /// {{NAME}}(3).tryNextPowerOf2(); // 4
  /// ```
  {{NAME}}? tryNextPowerOf2() => tryFrom(_.nextPowerOf2());

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
  /// {{NAME}}(3).wrappedNextPowerOf2(); // 4
  /// ```
  {{NAME}} wrappedNextPowerOf2() => {{NAME}}.fromWrapped(_.nextPowerOf2());

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
  /// {{NAME}}(3).clampedNextPowerOf2(); // 4
  /// ```
  {{NAME}} clampedNextPowerOf2() => {{NAME}}.fromClamped(_.nextPowerOf2());

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
  /// {{NAME}}(3).nextMultipleOf(2); // 4
  /// ```
  {{NAME}} nextMultipleOf({{NAME}} n) => {{NAME}}(_.nextMultipleOf(n._));

  /// Calculates the smallest value greater than or equal to `this` that is
  /// 
  /// a multiple of [n].
  /// 
  /// `n` must be a positive integer.
  /// 
  /// If the result is out of range, the behavior is undefined.
  {{NAME}} uncheckedNextMultipleOf({{NAME}} n) {
    return {{NAME}}.fromUnchecked(_.nextMultipleOf(n._));
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
  /// {{NAME}}(3).tryNextMultipleOf(2); // 4
  /// ```
  {{NAME}}? tryNextMultipleOf({{NAME}} n) => tryFrom(_.nextMultipleOf(n._));

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
  /// {{NAME}}(3).wrappedNextMultipleOf(2); // 4
  /// ```
  {{NAME}} wrappedNextMultipleOf({{NAME}} n) {
    return {{NAME}}.fromWrapped(_.nextMultipleOf(n._));
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
  /// {{NAME}}(3).clampedNextMultipleOf(2); // 4
  /// ```
  {{NAME}} clampedNextMultipleOf({{NAME}} n) {
    return {{NAME}}.fromClamped(_.nextMultipleOf(n._));
  }

  /// Returns the number of `1`s in the binary representation of `this`.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(3).countOnes(); // 2
  /// ```
  int countOnes() => _.countOnes();

  /// Returns the number of leading ones in the binary representation of `this`.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(3).countLeadingOnes(); // <width - 2>
  /// ```
  int countLeadingOnes() => _descriptor.countLeadingOnes(_);

  /// Returns the number of trailing ones in the binary representation of `this`.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(3).countTrailingOnes(); // 0
  /// ```
  int countTrailingOnes() => _descriptor.countTrailingOnes(_);

  /// Returns the number of `0`s in the binary representation of `this`.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(3).countZeros(); // <width - 2>
  /// ```
  int countZeros() => _descriptor.countZeros(_);

  /// Returns the number of leading zeros in the binary representation of
  /// `this`.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(3).countLeadingZeros(); // <width - 2>
  /// ```
  int countLeadingZeros() => _descriptor.countLeadingZeros(_);

  /// Returns the number of trailing zeros in the binary representation of
  /// `this`.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(3).countTrailingZeros(); // 0
  /// ```
  int countTrailingZeros() => _descriptor.countTrailingZeros(_);

  /// Returns a new [{{NAME}}] with bits in [left] to [size].
  /// 
  /// The result is left-padded with 0's.
  /// 
  /// Both [left] and [size] must be in range.
  {{NAME}} bitChunk(int left, [int? size]) {
    RangeError.checkValidRange(left, 0, width - 1, 'left');
    if (size != null) {
      RangeError.checkValidRange(size, 0, width - left, 'size');
    }
    return _descriptor.uncheckedBitChunk(_, left, size);
  }

  /// Returns a new [{{NAME}}] with bits in [left] to [size].
  /// 
  /// The result is left-padded with 0's.
  /// 
  /// If either [left] or [size] is out of range, the behavior is undefined.
  {{NAME}} uncheckedBitChunk(int left, [int? size]) {
    return _descriptor.uncheckedBitChunk(_, left, size);
  }

  /// Returns a new instance with bits [left] to [right], inclusive.
  /// 
  /// The result is left-padded with 0's.
  /// 
  /// Both [left] and [right] must be in range.
  {{NAME}} bitSlice(int left, [int? right]) {
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
  {{NAME}} uncheckedBitSlice(int left, [int? right]) {
    return _descriptor.uncheckedBitSlice(_, left, right);
  }

  /// Returns a new instance with bits [left] to [right], inclusive, replaced
  /// with the same number of bits from [value].
  ///
  /// Additional bits in [value] are ignored.
  ///
  /// Both [left] and [right] must be in range.
  {{NAME}} bitReplace(int value, int left, [int? right]) {
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
  {{NAME}} uncheckedBitReplace(int value, int left, [int? right]) {
    return _descriptor.uncheckedBitReplace(_, value, left, right);
  }

  /// Rotates the bits in `this` to the left by [n] positions.
  ///
  /// The bits that are rotated out of the integer are rotated back in from the
  /// other side.
  {{NAME}} rotateLeft(int n) => _descriptor.rotateLeft(_, n);

  /// Rotates the bits in `this` to the right by [n] positions.
  /// 
  /// The bits that are rotated out of the integer are rotated back in from the
  /// other side.
  {{NAME}} rotateRight(int n) => _descriptor.rotateRight(_, n);

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
  /// {{NAME}}(-3).abs(); // 3
  /// ```
  {{NAME}} abs() => {{NAME}}(_.abs());

  /// Returns the absolute value of this integer.
  /// 
  /// If the result is out of range, the behavior is undefined.
  {{NAME}} uncheckedAbs() => {{NAME}}.fromUnchecked(_.abs());

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
  /// {{NAME}}(-3).tryAbs(); // 3
  /// ```
  {{NAME}}? tryAbs() => tryFrom(_.abs());

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
  /// {{NAME}}(-3).wrappedAbs(); // 3
  /// ```
  {{NAME}} wrappedAbs() => {{NAME}}.fromWrapped(_.abs());

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
  /// {{NAME}}(-3).clampedAbs(); // 3
  /// ```
  {{NAME}} clampedAbs() => {{NAME}}.fromClamped(_.abs());

  /// Returns the _minimum_ number of bits required to store this integer.
  /// 
  /// The result is always in the range of `0` to `width`.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(0).bitLength(); // 0
  /// {{NAME}}(1).bitLength(); // 1
  /// {{NAME}}(2).bitLength(); // 2
  /// ```
  int get bitLength => _.bitLength;

  /// Returns true if and only if this integer is even.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(2).isEven; // true
  /// {{NAME}}(3).isEven; // false
  /// ```
  bool get isEven => _.isEven;

  /// Returns true if and only if this integer is odd.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(2).isOdd; // false
  /// {{NAME}}(3).isOdd; // true
  /// ```
  bool get isOdd => _.isOdd;

  {{#SIGNED}}
  /// Returns the sign of this integer.
  /// 
  /// Returns 0 for zero, -1 for values less than zero and +1 for values greater
  /// than zero.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(-3).sign; // -1
  /// {{NAME}}(0).sign; // 0
  /// {{NAME}}(3).sign; // 1
  /// ```
  {{NAME}} get sign => {{NAME}}.fromUnchecked(_.sign);
  {{/SIGNED}}

  /// Returns true if and only if this integer is zero.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(0).isZero; // true
  /// {{NAME}}(3).isZero; // false
  /// ```
  bool get isZero => _ == 0;

  /// Returns true if and only if this integer is positive.
  /// 
  /// A positive integer is greater than zero.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(0).isPositive; // false
  /// {{NAME}}(3).isPositive; // true
  /// ```
  bool get isPositive => _ > 0;

  {{#SIGNED}}
  /// Returns true if and only if this integer is negative.
  /// 
  /// A negative integer is less than zero.
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(-3).isNegative; // true
  /// {{NAME}}(0).isNegative; // false
  /// ```
  bool get isNegative => _ < 0;
  {{/SIGNED}}

  /// Returns `this` clamped to be in the range of [lowerLimit] and
  /// [upperLimit].
  /// 
  /// The arguments [lowerLimit] and [upperLimit] must form a valid range.
  ///
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(2).clamp({{NAME}}(3), {{NAME}}(5)); // 3
  /// {{NAME}}(4).clamp({{NAME}}(3), {{NAME}}(5)); // 4
  /// {{NAME}}(6).clamp({{NAME}}(3), {{NAME}}(5)); // 5
  /// ```
  {{NAME}} clamp({{NAME}} lowerLimit, {{NAME}} upperLimit) {
    return {{NAME}}.fromUnchecked(_.clamp(lowerLimit._, upperLimit._));
  }

  /// The remainder of the truncating division of `this` by [other].
  /// 
  /// The result r of this operation satisfies: `this == (this ~/ other) *`
  /// `other + r`. As a consequence, the remainder `r` has the same sign as the
  /// dividend `this`.
  {{NAME}} remainder({{NAME}} other) {
    return {{NAME}}.fromUnchecked(_.remainder(other._));
  }

  /// This number as a [double].
  /// 
  /// If an integer number is not precisely representable as a [double], an
  /// approximation is returned.
  double toDouble() => _.toDouble();

  /// This number as an [int].
  /// 
  /// This is the underlying integer representation of a [{{NAME}}], and is
  /// effectively an identity function, but for consistency and completeness,
  /// it is provided as a method to discourage casting.
  int toInt() => _;

  /// Returns this integer split into two parts: high and low bits.
  /// 
  /// The high bits are the most significant bits, and the low bits are the
  /// least significant bits. This is the inverse of [{{NAME}}.fromHiLo], and
  /// is useful for operations that require splitting an integer into two parts.
  (int hi, int lo) get hiLo => _descriptor.hiLo(_);

  /// Euclidean modulo of this number by other.
  /// 
  /// The sign of the returned value is always positive.
  /// 
  /// See [num.operator %] for more details.
  {{NAME}} operator %({{NAME}} other) {
    return {{NAME}}.fromUnchecked(_ % other._);
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
  /// {{NAME}}(2) * {{NAME}}(3); // 6
  /// ```
  {{NAME}} operator *({{NAME}} other) => {{NAME}}(_ * other._);

  /// Multiplies this number by other.
  /// 
  /// If the result is out of range, the behavior is undefined.
  {{NAME}} uncheckedMultiply({{NAME}} other) => {{NAME}}.fromUnchecked(_ * other._);

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
  /// {{NAME}}(2).tryMultiply({{NAME}}(3)); // 6
  /// ```
  {{NAME}}? tryMultiply({{NAME}} other) => tryFrom(_ * other._);

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
  /// {{NAME}}(2).wrappedMultiply({{NAME}}(3)); // 6
  /// ```
  {{NAME}} wrappedMultiply({{NAME}} other) => {{NAME}}.fromWrapped(_ * other._);

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
  /// {{NAME}}(2).clampedMultiply({{NAME}}(3)); // 6
  /// ```
  {{NAME}} clampedMultiply({{NAME}} other) => {{NAME}}.fromClamped(_ * other._);

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
  /// {{NAME}}(2) + {{NAME}}(3); // 5
  /// ```
  {{NAME}} operator +({{NAME}} other) => {{NAME}}(_ + other._);

  /// Adds [other] to this number.
  /// 
  /// If the result is out of range, the behavior is undefined.
  {{NAME}} uncheckedAdd({{NAME}} other) => {{NAME}}.fromUnchecked(_ + other._);

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
  /// {{NAME}}(2).tryAdd({{NAME}}(3)); // 5
  /// ```
  {{NAME}}? tryAdd({{NAME}} other) => tryFrom(_ + other._);

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
  /// {{NAME}}(2).wrappedAdd({{NAME}}(3)); // 5
  /// ```
  {{NAME}} wrappedAdd({{NAME}} other) => {{NAME}}.fromWrapped(_ + other._);

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
  /// {{NAME}}(2).clampedAdd({{NAME}}(3)); // 5
  /// ```
  {{NAME}} clampedAdd({{NAME}} other) => {{NAME}}.fromClamped(_ + other._);

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
  /// {{NAME}}(3) - {{NAME}}(2); // 1
  /// ```
  {{NAME}} operator -({{NAME}} other) => {{NAME}}(_ - other._);

  /// Subtracts [other] from this number.
  /// 
  /// If the result is out of range, the behavior is undefined.
  {{NAME}} uncheckedSubtract({{NAME}} other) => {{NAME}}.fromUnchecked(_ - other._);

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
  /// {{NAME}}(3).trySubtract({{NAME}}(2)); // 1
  /// ```
  {{NAME}}? trySubtract({{NAME}} other) => tryFrom(_ - other._);

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
  /// {{NAME}}(3).wrappedSubtract({{NAME}}(2)); // 1
  /// ```
  {{NAME}} wrappedSubtract({{NAME}} other) => {{NAME}}.fromWrapped(_ - other._);

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
  /// {{NAME}}(3).clampedSubtract({{NAME}}(2)); // 1
  /// ```
  {{NAME}} clampedSubtract({{NAME}} other) => {{NAME}}.fromClamped(_ - other._);

  /// Whether this number is numerically smaller than [other].
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(2) < {{NAME}}(3); // true
  /// ```
  bool operator <({{NAME}} other) => _ < other._;

  /// Whether this number is numerically smaller than or equal to [other].
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(2) <= {{NAME}}(3); // true
  /// {{NAME}}(3) <= {{NAME}}(3); // true
  /// ```
  bool operator <=({{NAME}} other) => _ <= other._;

  /// Whether this number is numerically greater than [other].
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(3) > {{NAME}}(2); // true
  /// ```
  bool operator >({{NAME}} other) => _ > other._;

  /// Whether this number is numerically greater than or equal to [other].
  /// 
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(3) >= {{NAME}}(2); // true
  /// {{NAME}}(3) >= {{NAME}}(3); // true
  /// ```
  bool operator >=({{NAME}} other) => _ >= other._;

  {{#SIGNED}}
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
  /// -{{NAME}}(3); // -3
  /// ```
  {{NAME}} operator -() => {{NAME}}(-_);

  /// The negation of `this`.
  /// 
  /// If the result is out of range, the behavior is undefined.
  {{NAME}} uncheckedNegate() => {{NAME}}.fromUnchecked(-_);

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
  /// {{NAME}}(3).tryNegate(); // -3
  /// ```
  {{NAME}}? tryNegate() => tryFrom(-_);

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
  /// {{NAME}}(3).wrappedNegate(); // -3
  /// ```
  {{NAME}} wrappedNegate() => {{NAME}}.fromWrapped(-_);

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
  /// {{NAME}}(3).clampedNegate(); // -3
  /// ```
  {{NAME}} clampedNegate() => {{NAME}}.fromClamped(-_);
  {{/SIGNED}}

  /// Truncating division operator.
  /// 
  /// Performs truncating division of this number by [other]. Truncating
  /// division is division where a fractional result is converted to an integer
  /// by rounding towards zero.
  ///
  /// ## Example
  /// 
  /// ```dart
  /// {{NAME}}(10) ~/ {{NAME}}(3); // 3
  /// ```
  {{NAME}} operator ~/(int other) => {{NAME}}.fromUnchecked(_ ~/ other);

  /// Bit-wise and operator.
  /// 
  /// See [int.operator &] for more details.
  {{NAME}} operator &({{NAME}} other) => {{NAME}}.fromUnchecked(_ & other._);

  /// Bit-wise or operator.
  /// 
  /// See [int.operator |] for more details.
  {{NAME}} operator |({{NAME}} other) => {{NAME}}.fromUnchecked(_ | other._);

  /// Shifts the bits of this integer to the right by [shiftAmount].
  /// 
  /// Shifting to the right makes the number smaller and drops the least
  /// significant bits, effectively doing an integer division by
  /// `pow(2, shiftAmount)`.
  /// 
  /// [shiftAmount] must be non-negative.
  {{NAME}} operator >>(int shiftAmount) => {{NAME}}.fromUnchecked(_ >> shiftAmount);

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
  /// {{NAME}}(3) << 2; // 12
  /// ```
  {{NAME}} operator <<(int shiftAmount) => {{NAME}}(_ << shiftAmount);

  /// Shifts the bits of this integer to the left by [shiftAmount].
  /// 
  /// If the result is out of range, the behavior is undefined.
  {{NAME}} uncheckedShiftLeft(int shiftAmount) {
    return {{NAME}}.fromUnchecked(_ << shiftAmount);
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
  /// {{NAME}}(3).tryShiftLeft(2); // 12
  /// ```
  {{NAME}}? tryShiftLeft(int shiftAmount) => tryFrom(_ << shiftAmount);

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
  /// {{NAME}}(3).wrappedShiftLeft(2); // 12
  /// ```
  {{NAME}} wrappedShiftLeft(int shiftAmount) {
    return {{NAME}}.fromWrapped(_ << shiftAmount);
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
  /// {{NAME}}(3).clampedShiftLeft(2); // 12
  /// ```
  {{NAME}} clampedShiftLeft(int shiftAmount) {
    return {{NAME}}.fromClamped(_ << shiftAmount);
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
  {{NAME}} signedRightShift(int shiftAmount) {
    return _descriptor.signedRightShift(_, shiftAmount);
  }

  /// Bitwise unsigned right shift by [shiftAmount] bits.
  /// 
  /// The least significant shiftAmount bits are dropped, the remaining bits (if
  /// any) are shifted down, and zero-bits are shifted in as the new most
  /// significant bits.
  ///
  /// The shiftAmount must be non-negative.
  {{NAME}} operator >>>(int shiftAmount) => {{NAME}}.fromUnchecked(_ >>> shiftAmount);

  /// Bit-wise exclusive-or operator.
  /// 
  /// See [int.operator ^] for more details.
  {{NAME}} operator ^({{NAME}} other) => {{NAME}}.fromUnchecked(_ ^ other._);

  /// The bit-wise negate operator.
  /// 
  /// See [int.operator ~] for more details.
  {{NAME}} operator ~() => {{NAME}}.fromUnchecked(~_);

  /// Returns `this` sign-extended to the full width, from the [startWidth].
  /// 
  /// All bits to the left (inclusive of [startWidth]) are replaced as a result.
  {{NAME}} signExtend(int startWidth) {
    return {{NAME}}.fromUnchecked(_.signExtend(startWidth));
  }

  /// Returns `this` as a binary string.
  String toStringBinary({bool padded = true}) {
    final result = _.toRadixString(2);
    if (padded) {
      return result.padLeft(width, '0');
    }
    return result;
  }
}
