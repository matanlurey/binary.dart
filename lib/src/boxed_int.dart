import 'package:meta/meta.dart';

import '_utils.dart';
import 'int.dart';

/// Encapsulates a common integral data type of declared [size] and [signed].
///
/// These data structures are _easier_ to use than [BinaryInt], but come at a
/// cost of needing to box (wrap) [int] values in a class, and the overhead that
/// comes with that in the Dart and JavaScript VMs, and should be avoided in
/// perf-sensitive code.
///
/// You can also _extend_ this class to create a custom implementation:
///
/// ```
/// class Uint3 extends Integral<Uint3> {
///   // Implement toDebugString(), wrapSafeValue(), and constructors.
/// }
/// ```
///
/// See [Int4] and [Uint4] for examples!
///
/// **WARNING**: Do not implement or mix-in this class.
@immutable
abstract class Integral<T extends Integral<T>> implements Comparable<Integral> {
  /// Value wrapped by the [Integral].
  @nonVirtual
  final int value;

  /// Numbers of bits in this data type.
  @nonVirtual
  final int size;

  /// Whether this data type supports negative numbers.
  @nonVirtual
  final bool _supportsSigns;

  /// Used for implementing sub-types.
  Integral.checked({
    required this.value,
    required this.size,
    required bool signed,
  })   : assert(value != null),
        _supportsSigns = signed {
    RangeError.checkValueInInterval(this.value, _min, _max);
  }

  /// An unsafe constructor that does not verify if the values are within range.
  const Integral.unchecked({
    required this.value,
    required this.size,
    required bool signed,
  }) : _supportsSigns = signed;

  /// Implement to create an instance of self around [value].
  @protected
  @visibleForOverriding
  T wrapSafeValue(int value);

  /// Wraps [value], careful to normalize (unsign) if necessary.
  T _wrapSignAware(int value) {
    if (!_supportsSigns) {
      value = value.toUnsigned(size);
    } else {
      value = value.toSigned(size);
    }
    return wrapSafeValue(value);
  }

  @override
  @nonVirtual
  int compareTo(Integral o) => value.compareTo(o.value);

  @override
  @nonVirtual
  bool operator ==(Object o) {
    return o is Integral &&
        value == o.value &&
        size == o.size &&
        _supportsSigns == o._supportsSigns;
  }

  @override
  @nonVirtual
  int get hashCode => value.hashCode;

  /// Greater than comparison.
  @nonVirtual
  bool operator >(T other) => value > other.value;

  /// Greater than or equal comparison.
  @nonVirtual
  bool operator >=(T other) => value >= other.value;

  /// Less than comparison.
  @nonVirtual
  bool operator <(T other) => value < other.value;

  /// Less than or equal comparison.
  @nonVirtual
  bool operator <=(T other) => value <= other.value;

  /// Bitwise OR operator.
  @nonVirtual
  T operator |(T other) => _wrapSignAware(value | other.value);

  /// Bitwise AND operator.
  @nonVirtual
  T operator &(T other) => _wrapSignAware(value & other.value);

  /// Bitwise XOR operator.
  @nonVirtual
  T operator ^(T other) => _wrapSignAware(value ^ other.value);

  /// Bitwise NOT operator.
  @nonVirtual
  T operator ~() {
    return _wrapSignAware(~value);
  }

  /// Left-shift operator.
  @nonVirtual
  T operator <<(T other) => _wrapSignAware(value << other.value);

  /// Right-shift operator.
  @nonVirtual
  T operator >>(T other) => _wrapSignAware(value >> other.value);

  /// Minimum value representable by this type.
  int get _min {
    if (_supportsSigns) {
      return -2.pow(size - 1);
    } else {
      return 0;
    }
  }

  /// Maximum value representable by this type.
  int get _max {
    if (_supportsSigns) {
      return 2.pow(size - 1) - 1;
    } else {
      return 2.pow(size) - 1;
    }
  }

  void _assertMaxBits(int value, [String? name]) {
    RangeError.checkValueInInterval(value, 0, size - 1, name);
  }

  /// Returns the [n]th bit from [value].
  ///
  /// Throws [RangeError] if [n] is out of range.
  @nonVirtual
  int getBit(int n) {
    _assertMaxBits(n, 'n');
    return value.getBit(n);
  }

  /// Returns with the [n]th bit from [value] set.
  ///
  /// Throws [RangeError] if [n] is out of range.
  @nonVirtual
  T setBit(int n) {
    _assertMaxBits(n, 'n');
    return wrapSafeValue(value.setBit(n));
  }

  /// Returns whether the [n]th bit from [value] is set.
  ///
  /// Throws [RangeError] if [n] is out of range.
  @nonVirtual
  bool isSet(int n) {
    _assertMaxBits(n);
    return value.isSet(n);
  }

  /// Returns with the [n]th bit from [value] cleared.
  ///
  /// Throws [RangeError] if [n] is not [inRange].
  @nonVirtual
  T clearBit(int n) {
    _assertMaxBits(n, 'n');
    return wrapSafeValue(value.clearBit(n));
  }

  /// Returns whether the [n]th bit from [value] is cleared.
  ///
  /// Throws [RangeError] if [n] is out of range.
  @nonVirtual
  bool isClear(int n) {
    _assertMaxBits(n, 'n');
    return value.isClear(n);
  }

  /// Sets the [n]th bit if [v] is `true`, otherwise clears.
  ///
  /// If [v] is not provided defaults to the opposit of the current value.
  ///
  /// Returns the new value.
  @nonVirtual
  T toggleBit(int n, [bool? v]) {
    v ??= !isSet(n);
    return v ? setBit(n) : clearBit(n);
  }

  /// Returns a new instance with bits in [left] to [size].
  ///
  /// The result is left-padded with 0's.
  ///
  /// Throws [RangeError] if [left] or [size] is out of range.
  @nonVirtual
  T bitChunk(int left, int size) {
    _assertMaxBits(left, 'left');
    return wrapSafeValue(value.bitChunk(left, size));
  }

  /// Returns a new instance with bits [left] to [right], inclusive.
  ///
  /// The result is left-padded with 0's.
  ///
  /// Throws [RangeError] if [left] or [right] is out of range.
  @nonVirtual
  T bitRange(int left, int right) {
    _assertMaxBits(left, 'left');
    return wrapSafeValue(value.bitRange(left, right));
  }

  /// Returns a new instance with bits [left] to [right], inclusive, replaced.
  ///
  /// Throws [RangeError] if [left] or [right] is out of range.
  @nonVirtual
  T replaceBitRange(int left, int right, int bits) {
    _assertMaxBits(left, 'left');
    return wrapSafeValue(value.replaceBitRange(left, right, bits));
  }

  /// Returns `true` iff [value] represents a negative number, else `false`.
  @nonVirtual
  bool get isNegative => _supportsSigns ? msb : false;

  /// Returns `true` iff [value] represents a positive number, else `false`.
  @nonVirtual
  bool get isPositive => !isNegative;

  /// Returns [value] arithmetically right-shifted [n] bits.
  ///
  /// See [BinaryInt.signedRightShift].
  @nonVirtual
  T signedRightShift(int n) {
    return wrapSafeValue(value.signedRightShift(n, size));
  }

  /// Returns a bit-wise right rotation on [value] by [number] of bits.
  ///
  /// See [BinaryInt.rotateRightShift].
  @nonVirtual
  T rotateRightShift(int number) {
    return wrapSafeValue(value.rotateRightShift(number, size));
  }

  /// Returns the current value [Binaryint.signExtend]-ed to the full size.
  ///
  /// All bits to the left (inclusive of [startSize]) are replaced as a result.
  @nonVirtual
  T signExtend(int startSize) {
    return wrapSafeValue(value.signExtend(startSize, size));
  }

  /// Returns the number of set bits in [value].
  @nonVirtual
  int get bitsSet {
    return value.countSetBits(size);
  }

  /// Returns whether the most-significant-bit in [value] is set.
  @nonVirtual
  bool get msb => isSet(size - 1);

  @override
  @nonVirtual
  String toString() {
    if (assertionsEnabled) {
      return toDebugString();
    } else {
      return super.toString();
    }
  }

  /// Returns [value] as a binary string representation.
  @nonVirtual
  String toBinary() => value.toBinary();

  /// Returns [value] as a binary string representation, padded with `0`'s.
  @nonVirtual
  String toBinaryPadded() => value.toBinaryPadded(size);

  /// Returns a debug-friendly representation of [toString].
  @protected
  @visibleForOverriding
  String toDebugString();
}

/// Encapsulates a single (unsigned) bit, i.e. either `0` or `1`.
@sealed
class Bit extends Integral<Bit> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Bit(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Bit';
  static const _size = 1;
  static const _signed = false;

  /// A pre-computed instance of `Bit(0)`.
  static const zero = Bit._(0);

  /// A pre-computed instance of `Bit(1)`.
  static const one = Bit._(1);

  /// Wraps a value of either `0` or `1`.
  ///
  /// This is considered a convenience for [Bit.zero] and [Bit.one].
  factory Bit(int value) {
    if (value == 0) return zero;
    if (value == 1) return one;
    throw RangeError.range(value, 0, 1);
  }

  const Bit._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Bit wrapSafeValue(int value) => Bit(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates a signed 4-bit aggregation.
///
/// Also commonly known as:
/// - A signed _nibble_
/// - A _half-octet_
/// - A _semi-octet_
/// - A _half-byte_
///
/// Commonly used to represent:
/// - Binary-coded decimal
/// - Single decimal digits
@sealed
class Int4 extends Integral<Int4> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Int4(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Int4';
  static const _size = 4;
  static const _signed = true;

  /// A pre-computed instance of `Int4(0)`.
  static const zero = Int4._(0);

  /// Wraps a [value] that is otherwise a valid 4-bit signed integer.
  Int4(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Int4._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Int4 wrapSafeValue(int value) => Int4(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates an unsigned 4-bit aggregation.
///
/// Also commonly known as:
/// - An unsigned _nibble_
/// - A _half-octet_
/// - A _semi-octet_
/// - A _half-byte_
///
/// Commonly used to represent:
/// - Binary-coded decimal
/// - Single decimal digits
@sealed
class Uint4 extends Integral<Uint4> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Uint4(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Uint4';
  static const _size = 4;
  static const _signed = false;

  /// A pre-computed instance of `Uint4(0)`.
  static const zero = Uint4._(0);

  /// Wraps a [value] that is otherwise a valid 4-bit unsigned integer.
  Uint4(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Uint4._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Uint4 wrapSafeValue(int value) => Uint4(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates a signed 8-bit aggregation.
///
/// Also commonly known as:
/// - An _octet_
/// - A _byte_
///
/// Commonly used to represent:
/// - ASCII characters
@sealed
class Int8 extends Integral<Int8> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Int8(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Int8';
  static const _size = 8;
  static const _signed = true;

  /// A pre-computed instance of `Int8(0)`.
  static const zero = Int8._(0);

  /// Wraps a [value] that is otherwise a valid 8-bit signed integer.
  Int8(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Int8._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Int8 wrapSafeValue(int value) => Int8(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates an unsigned 8-bit aggregation.
///
/// Also commonly known as:
/// - An _octet_
/// - A _byte_
///
/// Commonly used to represent:
/// - ASCII characters
@sealed
class Uint8 extends Integral<Uint8> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Uint8(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Uint8';
  static const _size = 8;
  static const _signed = false;

  /// A pre-computed instance of `Uint8(0)`.
  static const zero = Uint8._(0);

  /// Wraps a [value] that is otherwise a valid 8-bit unsigned integer.
  Uint8(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Uint8._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Uint8 wrapSafeValue(int value) => Uint8(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates a signed 16-bit aggregation.
///
/// Also commonly known as a _short_.
///
/// Commonly used to represent:
/// - USC-2 characters
@sealed
class Int16 extends Integral<Int16> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Int16(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Int16';
  static const _size = 16;
  static const _signed = true;

  /// A pre-computed instance of `Int16(0)`.
  static const zero = Int16._(0);

  /// Wraps a [value] that is otherwise a valid 16-bit signed integer.
  Int16(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Int16._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Int16 wrapSafeValue(int value) => Int16(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates an unsigned 16-bit aggregation.
///
/// Also commonly known as a _short_.
///
/// Commonly used to represent:
/// - USC-2 characters
@sealed
class Uint16 extends Integral<Uint16> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Uint16(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Uint16';
  static const _size = 16;
  static const _signed = false;

  /// A pre-computed instance of `Uint16(0)`.
  static const zero = Uint16._(0);

  /// Wraps a [value] that is otherwise a valid 16-bit unsigned integer.
  Uint16(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Uint16._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Uint16 wrapSafeValue(int value) => Uint16(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates a signed 32-bit aggregation.
///
/// Also commonly known as a _word_ or _long_.
///
/// Commonly used to represent:
/// - UTF-32 characters
/// - True color with alpha
/// - Pointers in 32-bit computing
@sealed
class Int32 extends Integral<Int32> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Int32(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Int32';
  static const _size = 32;
  static const _signed = true;

  /// A pre-computed instance of `Int32(0)`.
  static const zero = Int32._(0);

  /// Wraps a [value] that is otherwise a valid 32-bit signed integer.
  Int32(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Int32 wrapSafeValue(int value) => Int32(value);

  const Int32._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates an unsigned 32-bit aggregation.
///
/// Also commonly known as a _word_ or _long_.
///
/// Commonly used to represent:
/// - UTF-32 characters
/// - True color with alpha
/// - Pointers in 32-bit computing
@sealed
class Uint32 extends Integral<Uint32> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Uint32(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Uint32';
  static const _size = 32;
  static const _signed = false;

  /// A pre-computed instance of `Uint32(0)`.
  static const zero = Uint32._(0);

  /// Wraps a [value] that is otherwise a valid 32-bit unsigned integer.
  Uint32(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Uint32._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Uint32 wrapSafeValue(int value) => Uint32(value);

  @override
  String toDebugString() => '$_name {$value}';
}
