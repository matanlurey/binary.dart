import 'package:binary/src/descriptor.dart';

/// An signed 32-bit integer.
extension type const Int32._(int _) implements Comparable<num> {
  static const _descriptor = IntDescriptor<Int32>.unsigned(width: width);

  /// {@template binary.IntExtensionType.min}
  /// The minimum value that this type can represent.
  /// {@endtemplate}
  static const min = Int32.fromUnchecked(-2147483648);

  /// {@template binary.IntExtensionType.max}
  /// The maximum value that this type can represent.
  /// {@endtemplate}
  static const max = Int32.fromUnchecked(2147483647);

  /// {@template binary.IntExtensionType.width}
  /// The number of bits used to represent values of this type.
  /// {@endtemplate}
  static const width = 32;

  /// Defines [v] as an signed 32-bit integer, wrapping if necessary.
  ///
  /// {@template binary.IntExtensionType:defaultConstructor}
  /// In debug mode, an assertion is made that [v] is in a valid range.
  /// {@endtemplate}
  factory Int32(int v) => _descriptor.fit(v);

  /// Defines [v] as an signed 32-bit integer.
  ///
  /// {@template binary.IntExtensionType.fromUnchecked}
  /// Behavior is undefined if [v] is not in a valid range.
  /// {@endtemplate}
  const factory Int32.fromUnchecked(int v) = Int32._;

  /// Defines [v] as an signed 32-bit integer.
  ///
  /// {@template binary.IntExtensionType.tryFrom}
  /// Returns `null` if [v] is out of range.
  /// {@endtemplate}
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
  /// {@template binary.IntExtensionType.fromWrapped}
  /// If [v] is out of range, it is _wrapped_ to fit, similar to modular
  /// arithmetic:
  /// - If [v] is less than [min], the result is `v % (max + 1) + (max + 1)`.
  /// - If [v] is greater than [max], the result is `v % (max + 1)`.
  /// {@endtemplate}
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
  /// {@template binary.IntExtensionType.fromClamped}
  /// If [v] is out of range, it is _clamped_ to fit:
  /// - If [v] is less than [min], the result is [min].
  /// - If [v] is greater than [max], the result is [max].
  /// {@endtemplate}
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

  /// Returns the raw value of the integer.
  int get value => _;

  /// Returns the exponention of this integer with the given [exponent].
}
