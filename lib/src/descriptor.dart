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

  // OPERATIONS
  // ---------------------------------------------------------------------------

  /// Returns an iterable of bits in [v], from least to most significant.
  ///
  /// The iterable has a length of [width].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  Iterable<bool> bits(int v) => _BitIterable(v, width);

  /// Returns the number of zeros in the binary representation of [v].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int countZeros(int v) => width - v.countOnes();

  /// Returns the number of leading ones in the binary representation of [v].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  int countLeadingOnes(int v) {
    var count = 0;
    for (var i = width - 1; i >= 0; i--) {
      if (v.nthBit(i)) {
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
      if (!v.nthBit(i)) {
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
      if (v.nthBit(i)) {
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
      if (!v.nthBit(i)) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// Returns a new instance with bits in [left] to [size].
  ///
  /// The result is left-padded with 0s.
  ///
  /// Both [left] and [size] must be in the range of the integer descriptor
  /// or the behavior is undefined.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T uncheckedBitChunk(int v, int left, [int? size]) {
    var result = 0;
    size ??= width - left;
    for (var i = 0; i < size; i++) {
      if (v.nthBit(left + i)) {
        result |= 1 << i;
      }
    }
    return result as T;
  }

  /// Returns a new instance with bits [left] to [right], inclusive.
  ///
  /// The result is left-padded with 0s.
  ///
  /// Both [left] and [right] must be in the range of the integer descriptor
  /// or the behavior is undefined.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T uncheckedBitSlice(int v, int left, [int? right]) {
    // Convert to a chunk.
    right ??= width - 1;
    return uncheckedBitChunk(v, left, right - left + 1);
  }

  /// Replaces bits [left] to [right], inclusive, with the same number of bits
  /// from [source].
  ///
  /// Both [left] and [right] must be in the range of the integer descriptor
  /// or the behavior is undefined.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T uncheckedBitReplace(int target, int source, int left, [int? right]) {
    right ??= left + width - 1;
    var mask = 0;
    for (var i = left; i <= right; i++) {
      mask |= 1 << i;
    }
    return (target & ~mask | source << left) as T;
  }

  /// Rotates the bits in [v] to the left by [n] positions.
  ///
  /// The bits that are rotated out of the integer are rotated back in from the
  /// other side.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T rotateLeft(int v, int n) {
    n %= width;
    return (v << n | v >> (width - n)) & ((1 << width) - 1) as T;
  }

  /// Rotates the bits in [v] to the right by [n] positions.
  ///
  /// The bits that are rotated out of the integer are rotated back in from the
  /// other side.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T rotateRight(int v, int n) {
    n %= width;
    return (v >> n | v << (width - n)) & ((1 << width) - 1) as T;
  }

  /// Returns [v] arithmetically right-shifted by [n] bits.
  ///
  /// The sign bit is preserved, and the result is rounded towards negative
  /// infinity.
  ///
  /// This is intended to be roughly equivalent to JavaScript's `>>` operator.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  T signedRightShift(int v, int n) {
    if (v >= 0) {
      return v >> n as T;
    }
    return (v >> n) | ((1 << (width - n)) - 1) as T;
  }

  /// Returns the [v] split into two parts: the high and low bits.
  ///
  /// The high bits are the most significant bits, and the low bits are the
  /// least significant bits.
  (int, int) hiLo(int v) {
    return (v >> (width ~/ 2), v & ((1 << (width ~/ 2)) - 1));
  }

  /// Returns a [T] with the provided high and low bits.
  ///
  /// Bits out of range are ignored.
  T fromHiLo(int hi, int lo) {
    return (hi << (width ~/ 2) | lo) as T;
  }

  /// Returns [v] sign-extended to the full width, from the [startWidth].
  ///
  /// All bits to the left (inclusive of [startWidth]) are replaced as a result.
  T signExtend(int v, int startWidth) {
    if (startWidth >= width) {
      return v as T;
    }
    final mask = 1 << (startWidth - 1);
    if (v & mask == 0) {
      return v as T;
    }
    return v | ~((1 << startWidth) - 1) as T;
  }
}

final class _BitIterable extends Iterable<bool> {
  const _BitIterable(this._value, this.length);
  final int _value;

  @override
  final int length;

  @override
  bool elementAt(int index) => _value.nthBit(index);

  @override
  bool get first => _value.nthBit(0);

  @override
  bool get last => _value.nthBit(length - 1);

  @override
  bool get single {
    if (length != 1) {
      throw StateError('Iterable has more than one element');
    }
    return _value.nthBit(0);
  }

  @override
  bool contains(Object? element) {
    return element is bool && element ? _value != 0 : _value == 0;
  }

  @override
  bool get isEmpty => _value == 0;

  @override
  bool get isNotEmpty => _value != 0;

  @override
  Iterator<bool> get iterator => _BitIterator(_value, length);
}

final class _BitIterator implements Iterator<bool> {
  _BitIterator(this._value, this.length);
  final int _value;
  final int length;
  var _index = -1;

  @override
  bool moveNext() => ++_index < length;

  @override
  bool get current => _value.nthBit(_index);
}
