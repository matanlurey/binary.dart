import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Whether some methods on fixed-width integers assert when out of range.
///
/// In debug mode, methods such as `Uint8.new`, and [IntDescriptor.fit] assert
/// that the value is in a valid range. This can be disabled by setting this
/// variable to `false`.
///
/// In release mode, these assertions are always disabled and cannot be enabled.
var debugCheckFixedWithInRange = true;

/// Whether `unchecked` methods on fixed-width integers assert when out of
/// range.
///
/// In debug mode, methods such as `Uint8.fromUnchecked` are checked to ensure
/// that the value is in a valid range. This can be disabled by setting this
/// variable to `false`, `-DdebugCheckUncheckedInRange=false`.
///
/// In release mode, these assertions are always disabled and cannot be enabled.
// ignore: do_not_use_environment
const debugCheckUncheckedInRange = bool.fromEnvironment(
  'debugCheckUncheckedInRange',
  defaultValue: true,
);

/// Whether the platform is JavaScript.
const _isJsNumerics = identical(1, 1.0);

/// A descriptor for a fixed-width integer type [T].
///
/// An integer descriptor is used to describe the properties of a fixed-width
/// integer type, such as the width of the integer in bits, whether it is signed
/// or unsigned, and the minimum and maximum values that can be represented by
/// the integer.
///
/// Default implementations of most of the methods that are exposed with the
/// underlying type [T] are provided, reducing the amount of boilerplate code
/// that needs to be written when working with fixed-width integers. In most
/// cases, the [T] type will be used directly in place of the descriptor,
/// but the descriptor can be used to create custom sized integers.
///
/// ## Example
///
/// ```dart
/// final int8 = IntDescriptor<int>.signed(width: 8);
/// ```
@immutable
final class IntDescriptor<T> {
  /// Creates a new descriptor for a fixed-width signed integer of type [T].
  // coverage:ignore-start
  @literal
  const IntDescriptor.signed(
    this._assertCast, {
    required this.width,
    required this.max,
  })  : signed = true,
        min = -max - 1;
  // coverage:ignore-end

  /// Creates a new descriptor for a fixed-width unsigned integer of type [T].
  // coverage:ignore-start
  @literal
  const IntDescriptor.unsigned(
    this._assertCast, {
    required this.width,
    required this.max,
  })  : signed = false,
        min = 0;
  // coverage:ignore-end

  final T Function(int) _assertCast;
  T _uncheckedCast(int v) {
    var assertions = false;
    assert(assertions = true, '');
    return assertions ? _assertCast(v) : v as T;
  }

  /// The width of the integer in bits.
  final int width;

  /// Whether the integer is signed.
  final bool signed;

  /// Whether the integer is unsigned.
  bool get unsigned => !signed;

  /// Represents the minimum integer value of type [T].
  final int min;

  /// Represents the maximum integer value of type [T], inclusive.
  final int max;

  @override
  bool operator ==(Object other) {
    if (other is! IntDescriptor<T>) {
      return false;
    }
    return width == other.width && signed == other.signed;
  }

  @override
  int get hashCode => Object.hash(width, signed);

  @override
  String toString() {
    return 'IntDescriptor <$width bits | ${signed ? 'signed' : 'unsigned'}>';
  }

  // CONVERSIONS
  // ---------------------------------------------------------------------------

  /// Wraps [v] to fit within the range of the integer descriptor.
  ///
  /// If [v] is out of range, it is _wrapped_ to fit, similar to modular
  /// arithmetic:
  /// - If [v] is less than [min], the result is `v % (max + 1) + (max + 1)`.
  /// - If [v] is greater than [max], the result is `v % (max + 1)`.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T fitWrapped(int v) {
    if (signed) {
      return _uncheckedCast((v - min) % (max - min + 1) + min);
    } else {
      return _uncheckedCast(v & ((1 << width) - 1));
    }
  }

  /// Clamps [v] to fit within the range of the integer descriptor.
  ///
  /// If [v] is out of range, it is _clamped_ to fit:
  /// - If [v] is less than [min], the result is [min].
  /// - If [v] is greater than [max], the result is [max].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T fitClamping(int v) {
    return _uncheckedCast(v.clamp(min, max));
  }

  /// Checks if [v] fits within the range of the integer descriptor.
  ///
  /// If [v] is out of range, `null` is returned.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T? fitChecked(int v) {
    if (v < min || v > max) {
      return null;
    }
    return _uncheckedCast(v);
  }

  /// Asserts that [v] fits within the range of the integer descriptor.
  ///
  /// In production mode, this method uses [fitWrapped] instead of asserting.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T fit(int v) {
    assert(
      !debugCheckFixedWithInRange || v >= min && v <= max,
      '$v is out of range: $min <= $v <= $max',
    );
    return fitWrapped(v);
  }

  // OPERATIONS
  // ---------------------------------------------------------------------------

  /// Returns a list of bits representing [v].
  ///
  /// The list has a length of [width].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  BitList toBitList(int v, {bool growable = false}) {
    return BitList.fromInt(v, length: width, growable: growable);
  }

  /// Returns the number of zeros in the binary representation of [v].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int countZeros(int v) => width - countOnes(v);

  /// Returns the number of ones in the binary representation of [v].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int countOnes(int v) {
    var count = 0;
    for (var i = 0; i < width; i++) {
      if (nthBit(v, i)) {
        count++;
      }
    }
    return count;
  }

  /// Returns the number of leading ones in the binary representation of [v].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int countLeadingOnes(int v) {
    var count = 0;
    for (var i = width - 1; i >= 0; i--) {
      if (nthBit(v, i)) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// Returns the number of leading zeros in the binary representation of [v].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int countLeadingZeros(int v) {
    var count = 0;
    for (var i = width - 1; i >= 0; i--) {
      if (!nthBit(v, i)) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// Returns the number of trailing ones in the binary representation of [v].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int countTrailingOnes(int v) {
    var count = 0;
    for (var i = 0; i < width; i++) {
      if (nthBit(v, i)) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// Returns the number of trailing zeros in the binary representation of [v].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int countTrailingZeros(int v) {
    var count = 0;
    for (var i = 0; i < width; i++) {
      if (!nthBit(v, i)) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// Sets and returns the [n]th bit in [v] to [value].
  // ignore: avoid_positional_boolean_parameters
  T uncheckedSetNthBit(int v, int n, [bool value = true]) {
    if (signed) {
      v = v.toUnsigned(width);
    }
    if (value) {
      v |= 1 << n;
    } else {
      v &= ~(1 << n);
    }
    if (signed) {
      v = v.toSigned(width);
    }
    return _uncheckedCast(v);
  }

  /// Toggles and returns the [n]th bit in [v].
  T uncheckedToggleNthBit(int v, int n) {
    if (signed) {
      v = v.toUnsigned(width);
    }
    v ^= 1 << n;
    if (signed) {
      v = v.toSigned(width);
    }
    return _uncheckedCast(v);
  }

  /// Returns a new instance with bits in [left] to [size].
  ///
  /// The result is left-padded with 0s.
  ///
  /// Both [left] and [size] must be in the range of the integer descriptor
  /// or the behavior is undefined.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T uncheckedChunk(int v, int left, [int? size]) {
    size ??= width - left; // If size is null, use width - left

    // Calculate mask with 'size' number of 1 bits
    final mask = (1 << size) - 1;

    // Shift and mask to extract the desired bits
    return _uncheckedCast((v >> left) & mask);
  }

  /// Returns a new instance with bits [left] to [right], inclusive.
  ///
  /// The result is left-padded with 0s.
  ///
  /// Both [left] and [right] must be in the range of the integer descriptor
  /// or the behavior is undefined.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T uncheckedSlice(int v, int left, [int? right]) {
    // Convert to a chunk.
    right ??= width - 1;
    return uncheckedChunk(v, left, right - left + 1);
  }

  /// Replaces bits [left] to [right], inclusive, with the same number of bits
  /// from [replacement].
  ///
  /// Both [left] and [right] must be in the range of the integer descriptor
  /// or the behavior is undefined.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T uncheckedReplace(int target, int left, int? right, int replacement) {
    right ??= width - 1;
    final mask = ((1 << (right - left + 1)) - 1) << left;
    final result = (target & ~mask) | ((replacement << left) & mask);
    return _uncheckedCast(result);
  }

  /// Rotates the bits in [v] to the left by [n] positions.
  ///
  /// The bits that are rotated out of the integer are rotated back in from the
  /// other side.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T rotateLeft(int v, int n) {
    if (signed) {
      v = v.toUnsigned(width);
    }
    n %= width;
    var result = (v << n | v >> (width - n)) & ((1 << width) - 1);
    if (signed) {
      result = result.toSigned(width);
    }
    return _uncheckedCast(result);
  }

  /// Rotates the bits in [v] to the right by [n] positions.
  ///
  /// The bits that are rotated out of the integer are rotated back in from the
  /// other side.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T rotateRight(int v, int n) {
    if (signed) {
      v = v.toUnsigned(width);
    }
    n %= width;
    var result = (v >> n | v << (width - n)) & ((1 << width) - 1);
    if (signed) {
      result = result.toSigned(width);
    }
    return _uncheckedCast(result);
  }

  /// Returns [v] arithmetically right-shifted by [n] bits.
  ///
  /// The sign bit is preserved, and the result is rounded towards negative
  /// infinity.
  ///
  /// This is intended to be equivalent to JavaScript's `>>` operator.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T signedRightShift(int v, int n) {
    if (v >= 0) {
      return _uncheckedCast(v >> n);
    }
    // coverage:ignore-start
    if (_isJsNumerics) {
      final mask = -1 << (width - n);
      final result = (v.toUnsigned(width) >> n) | mask;
      return _uncheckedCast(result.toSigned(width));
    }
    // coverage:ignore-end
    final mask = -1 << (width - n);
    final result = (v >> n) | mask;
    return _uncheckedCast(result);
  }

  /// Returns the [v] split into two parts: the high and low bits.
  ///
  /// The high bits are the most significant bits, and the low bits are the
  /// least significant bits.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  (int, int) hiLo(int v) {
    return (v >> (width ~/ 2), v & ((1 << (width ~/ 2)) - 1));
  }

  /// Returns a [T] with the provided high and low bits.
  ///
  /// Bits out of range are ignored.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T fromHiLo(int hi, int lo) {
    // Bring both hi and lo into range.
    hi &= (1 << (width ~/ 2)) - 1;
    lo &= (1 << (width ~/ 2)) - 1;
    final result = hi << (width ~/ 2) | lo;
    return _uncheckedCast(signed ? result.toSigned(width) : result);
  }

  /// Similar to [int.operator &], but consistent across platforms.
  ///
  /// See <https://dart.dev/guides/language/numbers#bitwise-operations>.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T uncheckedBinaryAnd(int a, int b) {
    return _uncheckedCast(_overflowingBinaryAnd(a, b));
  }

  int _overflowingBinaryAnd(int a, int b) {
    // coverage:ignore-start
    if (!_isJsNumerics || unsigned) {
      // coverage:ignore-end
      return a & b;
    }
    // coverage:ignore-start
    final result = a.toUnsigned(width) & b.toUnsigned(width);
    return result.toSigned(width);
    // coverage:ignore-end
  }

  /// Similar to [int.operator |], but consistent across platforms.
  ///
  /// See <https://dart.dev/guides/language/numbers#bitwise-operations>.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T uncheckedBinaryOr(int a, int b) {
    // coverage:ignore-start
    if (!_isJsNumerics || unsigned) {
      // coverage:ignore-end
      return _uncheckedCast(a | b);
    }
    // coverage:ignore-start
    final result = a.toUnsigned(width) | b.toUnsigned(width);
    return _uncheckedCast(result.toSigned(width));
    // coverage:ignore-end
  }

  /// Similar to [int.operator ^], but consistent across platforms.
  ///
  /// See <https://dart.dev/guides/language/numbers#bitwise-operations>.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T uncheckedBinaryXor(int a, int b) {
    // coverage:ignore-start
    if (!_isJsNumerics || unsigned) {
      // coverage:ignore-end
      return _uncheckedCast(a ^ b);
    }
    // coverage:ignore-start
    final result = a.toUnsigned(width) ^ b.toUnsigned(width);
    return _uncheckedCast(result.toSigned(width));
    // coverage:ignore-end
  }

  /// Similar to [int.operator ~], but consistent across platforms.
  ///
  /// See <https://dart.dev/guides/language/numbers#bitwise-operations>.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T uncheckedBinaryNot(int v) {
    // coverage:ignore-start
    if (!_isJsNumerics || unsigned) {
      // coverage:ignore-end
      return _uncheckedCast(~v);
    }
    // coverage:ignore-start
    final result = ~v.toUnsigned(width);
    return _uncheckedCast(result.toSigned(width));
    // coverage:ignore-end
  }

  /// Similar to [int.operator >>], but consistent across platforms.
  ///
  /// See <https://dart.dev/guides/language/numbers#bitwise-operations>.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T uncheckedShiftRight(int v, int n) {
    // coverage:ignore-start
    if (!_isJsNumerics || v >= 0) {
      // coverage:ignore-end
      return _uncheckedCast(v >> n);
    }
    // coverage:ignore-start
    final result = v / 2.pow(n);
    return _uncheckedCast(result.floor());
    // coverage:ignore-end
  }

  /// Similar to [int.operator <<], but consistent across platforms.
  ///
  /// See <https://dart.dev/guides/language/numbers#bitwise-operations>.
  ///
  /// The result may have overflowed the integer width and should be fitted.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int overflowingShiftLeft(int v, int n) {
    // coverage:ignore-start
    if (!_isJsNumerics || v >= 0) {
      // coverage:ignore-end
      return v << n;
    }
    // coverage:ignore-start
    final result = v * 2.pow(n);
    return result;
    // coverage:ignore-end
  }

  /// Returns whether the n-th bit is set.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  bool nthBit(int v, int n) {
    // Same as `v & (1 << n) != 0`.
    return _overflowingBinaryAnd(v, overflowingShiftLeft(1, n)) != 0;
  }

  /// Returns `true` iff `value == 2^n` for some integer `n`.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  bool isPowerOf2(int v) {
    // Same as `v > 0 && (v & (v - 1)) == 0`.
    return v > 0 && uncheckedBinaryAnd(v, v - 1) == 0;
  }

  /// Returns the smallest power of two greater than or equal to `v`.
  ///
  /// If `v` is already a power of two, it is returned.
  ///
  /// `v` must be a positive integer.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int overflowingNextPowerOf2(int v) {
    if (isPowerOf2(v)) {
      return v;
    }
    return overflowingShiftLeft(1, v.log2() + 1);
  }

  /// Calculates the smallest value greater than or equal to `this` that is
  /// a multiple of [n].
  ///
  /// `n` must be a positive integer.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int overflowingNextMultipleOf(int v, int n) {
    return ((v + n - 1) ~/ RangeError.checkNotNegative(n)) * n;
  }

  /// Returns [v] as a binary string.
  String toBinaryString(int v, {bool padded = true}) {
    var result = v.toUnsigned(width).toRadixString(2);
    if (padded) {
      result = result.padLeft(width, '0');
    }
    return result;
  }
}
