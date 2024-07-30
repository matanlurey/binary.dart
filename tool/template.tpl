import 'package:binary/src/descriptor.dart';

/// An {{DESCRIPTION}}.
extension type const {{NAME}}._(int _) implements Comparable<num> {
  static const _descriptor = IntDescriptor<{{NAME}}>.unsigned(width: width);

  /// {@template binary.IntExtensionType.min}
  /// The minimum value that this type can represent.
  /// {@endtemplate}
  static const min = {{NAME}}.fromUnchecked({{MIN}});

  /// {@template binary.IntExtensionType.max}
  /// The maximum value that this type can represent.
  /// {@endtemplate}
  static const max = {{NAME}}.fromUnchecked({{MAX}});

  /// {@template binary.IntExtensionType.width}
  /// The number of bits used to represent values of this type.
  /// {@endtemplate}
  static const width = {{WIDTH}};

  /// Defines [v] as an {{DESCRIPTION}}, wrapping if necessary.
  ///
  /// {@template binary.IntExtensionType:defaultConstructor}
  /// In debug mode, an assertion is made that [v] is in a valid range.
  /// {@endtemplate}
  factory {{NAME}}(int v) => _descriptor.fit(v);

  /// Defines [v] as an {{DESCRIPTION}}.
  ///
  /// {@template binary.IntExtensionType.fromUnchecked}
  /// Behavior is undefined if [v] is not in a valid range.
  /// {@endtemplate}
  const factory {{NAME}}.fromUnchecked(int v) = {{NAME}}._;

  /// Defines [v] as an {{DESCRIPTION}}.
  ///
  /// {@template binary.IntExtensionType.tryFrom}
  /// Returns `null` if [v] is out of range.
  /// {@endtemplate}
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
  /// {{NAME}}.fromWrapped({{NAME}}.min - 3); // <max - 3>
  /// {{NAME}}.fromWrapped({{NAME}}.max + 3); // <min + 3>
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory {{NAME}}.fromWrapped(int v) => _descriptor.fitWrapped(v);

  /// Defines [v] as an {{DESCRIPTION}}.
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
  /// {{NAME}}.fromClamped({{NAME}}.min - 3); // <min>
  /// {{NAME}}.fromClamped({{NAME}}.max + 3); // <max>
  /// ```
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory {{NAME}}.fromClamped(int v) => _descriptor.fitClamping(v);

  /// Returns the raw value of the integer.
  int get value => _;

  /// Returns the exponention of this integer with the given [exponent].
}
