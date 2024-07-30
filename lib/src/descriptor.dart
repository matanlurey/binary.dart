import 'package:meta/meta.dart';

/// Whether some methods on fixed-width integers assert when out of range.
///
/// In debug mode, methods such as `Uint8.new`, and [IntDescriptor.fit] assert
/// that the value is in a valid range. This can be disabled by setting this
/// variable to `false`.
///
/// In release mode, these assertions are always disabled and cannot be enabled.
var debugCheckFixedWithInRange = true;

/// A descriptor for a fixed-width integer of type [T].
///
/// An integer descriptor is used to describe the properties of a fixed-width
/// integer type, such as the width of the integer in bits, whether it is signed
/// or unsigned, and the minimum and maximum values that can be represented by
/// the integer.
///
/// Default implementations of most of the methods that are exposed with the
/// underlying type [T] are provided, reducing the amount of boilerplate code
/// that needs to be written when working with fixed-width integers.
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
  const IntDescriptor.signed({
    required this.width,
  })  : signed = true,
        min = -1 << (width - 1),
        max = (1 << (width - 1)) - 1;
  // coverage:ignore-end

  /// Creates a new descriptor for a fixed-width unsigned integer of type [T].
  // coverage:ignore-start
  @literal
  const IntDescriptor.unsigned({
    required this.width,
  })  : signed = false,
        min = 0,
        max = (1 << width) - 1;
  // coverage:ignore-end

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
  T fitWrapped(int v) => v & ((1 << width) - 1) as T;

  /// Clamps [v] to fit within the range of the integer descriptor.
  ///
  /// If [v] is out of range, it is _clamped_ to fit:
  /// - If [v] is less than [min], the result is [min].
  /// - If [v] is greater than [max], the result is [max].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T fitClamping(int v) => v.clamp(min, max) as T;

  /// Checks if [v] fits within the range of the integer descriptor.
  ///
  /// If [v] is out of range, `null` is returned.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T? fitChecked(int v) {
    if (v < min || v > max) {
      return null;
    }
    return v as T;
  }

  /// Asserts that [v] fits within the range of the integer descriptor.
  ///
  /// In production mode, this method uses [fitWrapped] instead of asserting.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T fit(int v) {
    assert(
      !debugCheckFixedWithInRange || v >= min && v <= max,
      '$v is out of range',
    );
    return fitWrapped(v);
  }
}
