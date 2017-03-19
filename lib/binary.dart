import 'dart:collection' show IterableBase;
import 'dart:math' show pow;

import 'package:binary/binary.dart' as binary;
import 'package:meta/meta.dart';

/// Returns [bits] sign-extended to [endSize] bits.
///
/// Sign extension is the operation of increasing the number of bits of a binary
/// number while preserving the number's sign. This is done by appending digits
/// to the most significant side of the number.  For example: if 6 bits are
/// used to represent the value `00 1010` (decimal +10) and the sign extend
/// operation increases the word length to 16 bits, the new representation is
/// `0b0000 0000 0000 1010`.   Similarly the 10 bit value `11 1111 0001` can
/// be sign extended to 16 bits as `1111 1111 1111 0001`
///
/// [bits] will be extended from [startSize] to [endSize] bits.
/// ```dart
/// signExtend(bits, 10, 32);
/// ```
int signExtend(int bits, int startSize, int endSize) {
  assert(endSize > startSize);
  int extendBit = getBit(bits, startSize - 1);
  if (extendBit == 1) {
    int newHighBits = pow(2, endSize - startSize) - 1;
    bits = (newHighBits << startSize) | bits;
  }
  return bits;
}

/// Returns a bit-wise right-rotation on [bits] by a specified [number] of bits.
int rotateRight(int bits, int number) {
  for (var i = 0; i < number; i++) {
    bits = bits >> 1 | bits & 0x01 << 31;
  }
  return bits;
}

/// Returns the number of set [bits], assuming a [length]-bit input value.
int areSet(int bits, int length) {
  var c = 0;
  for (var i = 0; i < length; i++) {
    if (bits & (1 << i) != 0) {
      c++;
    }
  }
  return c;
}

/// Returns whether the most-significant-bit in [bits] (of [length]) is set.
bool msb(int bits, int length) => isSet(bits, length - 1);

/// Returns the [n]th from [bits].
///
/// There is no range checking in this top-level function. To verify you are
/// accessing a valid bit in _checked_ mode use [Integral.get], for example:
/// ```dart
/// int8.get(bits, n);
/// ```
int getBit(int bits, int n) => bits >> n & 1;

/// Returns an integer with the [n]th bit in [bits] set.
///
/// There is no range checking in this top-level function. To verify you are
/// accessing a valid bit in _checked_ mode use [Integral.set], for example:
/// ```dart
/// int8.set(bits, n);
/// ```
int setBit(int bits, int n) => bits | (1 << n);

/// Returns whether the [n]th bit in [bits] is set.
///
/// There is no range checking in this top-level function. To verify you are
/// accessing a valid bit in _checked_ mode use [Integral.isSet], for example:
/// ```dart
/// int8.isSet(bits, n);
/// ```
bool isSet(int bits, int n) => getBit(bits, n) == 1;

/// Returns an integer with the [n]th bit in [bits] cleared.
///
/// There is no range checking in this top-level function. To verify you are
/// accessing a valid bit in _checked_ mode use [Integral.clear], for example:
/// ```dart
/// int8.clear(bits, n);
/// ```
int clearBit(int bits, int n) => bits & ~(1 << n);

/// Returns whether the [n]th bit in [bits] is set.
///
/// There is no range checking in this top-level function. To verify you are
/// accessing a valid bit in _checked_ mode use [Integral.isClear], for example:
/// ```dart
/// int8.isClear(bits, n);
/// ```
bool isClear(int bits, int n) => getBit(bits, n) == 0;

/// Returns an int containing bits in [left] to [left] + [size] from [bits].
///
/// The result is left-padded with 0's.
///
/// There is no range checking in this top-level function. To verify you are
/// accessing a valid bit in _checked_ mode use [Integral.chunk], for example:
/// ```dart
/// int8.chunk(bits, left, size);
/// ```
int bitChunk(int bits, int left, int size) {
  assert(() {
    if (left < 0) {
      throw new RangeError.value(left, 'left', 'Out of range. Must be > 0.');
    }
    if (size < 1) {
      throw new RangeError.value(size, 'size', 'Out of range. Must be >= 1.');
    }
    return true;
  });
  return (bits >> (left + 1 - size)) & ~(~0 << size);
}

/// Returns an int containing bits in [left] to [right] _inclusive_ from [bits].
///
/// The result is left-padded with 0's.
///
/// There is no range checking in this top-level function. To verify you are
/// accessing a valid bit in _checked_ mode use [Integral.range], for example:
/// ```dart
/// int8.range(bits, left, right);
/// ```
int bitRange(int bits, int left, int right) {
  return bitChunk(bits, left, left - right + 1);
}

/// Returns an int from [bits], in order to right-most to left-most.
///
/// ```dart
/// fromBits([1, 0, 0, 1]) // Returns `9`
/// ```
///
/// **NOTE**: This is _not_ compatible with [Integral.toIterable].
int fromBits(List<int> bits) {
  assert(() {
    if (bits == null) {
      throw new ArgumentError.notNull('bits');
    }
    if (bits.isEmpty) {
      throw new ArgumentError.value('Must be non-empty', 'bits');
    }
    return true;
  });
  var result = 0;
  for (var n = 0; n < bits.length; n++) {
    if (bits[n] == 1) {
      result += pow(2, bits.length - n - 1);
    } else {
      assert(bits[n] == 0);
    }
  }
  return result;
}

/// Parses a binary number made entirely of 1's and 0's.
///
/// ```dart
/// parseBits('1001') // Returns `9`
/// ```
int parseBits(String bits) {
  const $0 = 48;
  const $1 = 49;

  return fromBits(bits.codeUnits.map((codeUnit) {
    switch (codeUnit) {
      case $0:
        return 0;
      case $1:
        return 1;
      default:
        final char = new String.fromCharCode(codeUnit);
        throw new FormatException(
          'Invalid character: $char',
          bits,
          bits.indexOf(char),
        );
    }
  }).toList());
}

/// Returns true iff [bits] is exactly `0`.
bool isZero(int bits) => bits == 0;

/// Returns an int consisting of [bytes] packed left-to-right.
///
/// Every element of [bytes] is truncated as an 8-bit integer in the range
/// [0, [uint8.max]].  0 is returned if [bytes] is empty.
int pack(List<int> bytes) {
  int value = 0;

  for (int i = 0; i < bytes.length; i++) {
    int byte = uint8.mask(bytes[i]);
    int numBytesLeft = bytes.length - (i + 1);
    value = value | (byte << (8 * numBytesLeft));
  }
  return value;
}

/// Base class for common integral data types.
class Integral implements Comparable<Integral> {
  /// All _signed_ data types.
  static const List<Integral> signed = const <Integral>[
    int4,
    int8,
    int16,
    int32,
    int64,
    int128,
  ];

  /// All _unsigned_ data types.
  static const List<Integral> unsigned = const <Integral>[
    bit,
    uint4,
    uint8,
    uint16,
    uint32,
    uint64,
    uint128,
  ];

  /// Number of bits in this data type.
  final int length;

  /// Whether this data type supports negative integers.
  final bool isSigned;

  /// Creates an integral data type of [length].
  @literal
  const Integral._(this.length) : isSigned = true;

  /// Creates an unsigned integral data type of [length].
  @literal
  const Integral._unsigned(this.length) : isSigned = false;

  RangeError _rangeError(int value, [String name]) {
    return new RangeError.range(value, min, max, name);
  }

  /// Whether this data type is not signed (0 or positive integers only).
  bool get isUnsigned => !isSigned;

  /// Returns the [n]th from [bits].
  ///
  /// In _checked mode_, throws if [bits] or [n] not [inRange].
  int get(int bits, int n) {
    _assertInRange(bits, 'bits');
    _assertInRange(n, 'n');
    return getBit(bits, n);
  }

  /// Returns the result of setting the [n]th from [bits].
  ///
  /// In _checked mode_, throws if [bits] or [n] not [inRange].
  int set(int bits, int n) {
    _assertInRange(bits, 'bits');
    _assertInRange(n, 'n');
    return setBit(bits, n);
  }

  /// Returns if the [n]th from [bits] is set.
  ///
  /// In _checked mode_, throws if [bits] or [n] not [inRange].
  bool isSet(int bits, int n) {
    _assertInRange(bits, 'bits');
    _assertInRange(n, 'n');
    return binary.isSet(bits, n);
  }

  /// Returns the result of clearing the [n]th from [bits].
  ///
  /// In _checked mode_, throws if [bits] or [n] not [inRange].
  int clear(int bits, int n) {
    _assertInRange(bits, 'bits');
    _assertInRange(n, 'n');
    return clearBit(bits, n);
  }

  /// Returns if the [n]th from [bits] is cleared.
  ///
  /// In _checked mode_, throws if [bits] or [n] not [inRange].
  bool isClear(int bits, int n) {
    _assertInRange(bits, 'bits');
    _assertInRange(n, 'n');
    return binary.isClear(bits, n);
  }

  /// Returns an int containing bits in [left] to [left] + [size] from [bits].
  ///
  /// The result is left-padded with 0's.
  ///
  /// In _checked mode_, throws if [bits], [left], or [size] out of range.
  int chunk(int bits, int left, int size) {
    _assertInRange(bits, 'bits');
    _assertInRange(left, 'left');
    _assertInRange(size, 'size');
    return bitChunk(bits, left, size);
  }

  /// Returns an int containing bits in [left] to [right] inclusive from [bits].
  ///
  /// The result is left-padded with 0's.
  ///
  /// In _checked mode_, throws if [bits], [left], or [right] out of range.
  int range(int bits, int left, int right) {
    return bitRange(bits, left, right);
  }

  /// Returns an int from [bits], in order to left-most to right-most.
  ///
  /// In _checked mode_, throws if the result is out of range.
  int fromBits(Iterable<int> bits) {
    final result = binary.fromBits(bits);
    _assertInRange(result);
    return result;
  }

  /// Parses a binary number made entirely of 1's and 0's.
  ///
  /// In _checked mode_, throws if the result is out of range.
  int parseBits(String bits) {
    final result = binary.parseBits(bits);
    _assertInRange(result);
    return result;
  }

  /// Returns true iff [number] is negative, else false.
  bool isNegative(int number) =>
      isSigned ? getBit(number, length - 1) == 1 : false;

  /// Returns [bits] sign-extended to [endSize] bits (defaults to [length]).
  ///
  /// See the top-level [binary.signExtend] method.
  int signExtend(int bits, int startSize, [int endSize]) {
    _assertInRange(bits);
    return binary.signExtend(bits, startSize, endSize ?? length);
  }

  /// Returns a bit-wise right rotation on [bits] by [number] of bits.
  ///
  /// See [binary.rotateRight].
  int rotateRight(int bits, int number) {
    _assertInRange(bits);
    return binary.rotateRight(bits, number);
  }

  /// Returns the number of set bits in [bits].
  ///
  /// See [binary.areSet].
  int areSet(int bits) {
    _assertInRange(bits);
    return binary.areSet(bits, length);
  }

  /// Returns whether the most-significant-bit in [bits] is set.
  bool msb(int bits) {
    _assertInRange(bits);
    return binary.msb(bits, length);
  }

  /// Returns true if the [result] of an addition produced a carry bit.
  ///
  /// A carry bit is produced during a two's compliment addition if the unmasked
  /// result is greater than [Integral.max].
  bool hasCarryBit(int result) => result > max;

  /// Returns true if [op1] + [op2] produced a signed overflow in [result].
  bool doesAddOverflow(int op1, int op2, int result) =>
      isNegative(op1) == isNegative(op2) &&
      isNegative(result) != isNegative(op1);

  /// Returns true if [op1] - [op2] produced a signed overflow in [result].
  bool doesSubOverflow(int op1, int op2, int result) =>
      isNegative(op1) != isNegative(op2) &&
      isNegative(result) != isNegative(op1);

  /// Returns an int containing only bits [0, [length]) from [bits].
  int mask(int bits) => bits & ~(~0 << length);

  /// Compares to another [Integral] data type, comparing [length].
  ///
  /// Whether [isSigned] or not is ignored.
  @override
  int compareTo(Integral other) => length.compareTo(other.length);

  void _assertInRange(int value, [String name]) {
    assert(() {
      if (!inRange(value)) {
        throw _rangeError(value, name);
      }
      return true;
    });
  }

  /// Returns whether [value] falls in the range of representable by this type.
  bool inRange(int value) => value >= min && value <= max;

  /// Minimum value representable by this type.
  int get min => isSigned ? (-pow(2, length - 1)) : 0;

  /// Maximum value representable by this type.
  int get max => isSigned ? pow(2, length - 1) - 1 : pow(2, length) - 1;

  /// Returns [bits] as a binary string representation.
  ///
  /// In _checked mode_, throws if [bits] not [inRange].
  String toBinary(int bits) {
    _assertInRange(bits);
    return bits.toRadixString(2);
  }

  /// Returns [bits] as a binary string representation, padded with `0`'s.
  ///
  /// In _checked_ mode, throws if [bits] not [inRange].
  String toBinaryPadded(int bits) {
    _assertInRange(bits);
    return bits.toRadixString(2).padLeft(length, '0');
  }

  /// Returns an iterable over [bits].
  Iterable<int> toIterable(int bits) => new _IterableBits(this, bits);

  @override
  String toString() => '#$Integral {${isSigned ? '' : 'u'}$length}';
}

class _Bit extends Integral {
  const _Bit() : super._unsigned(1);

  @override
  final int min = 0;

  @override
  final int max = 1;
}

class _BitIterator implements Iterator<int> {
  final Integral _type;

  int _bits;
  int _position = -1;

  _BitIterator(this._type, this._bits);

  @override
  int get current => _type.get(_bits, _position);

  @override
  bool moveNext() => ++_position < _type.length;
}

class _IterableBits extends IterableBase<int> {
  final Integral _type;
  final int _bits;

  const _IterableBits(this._type, this._bits);

  @override
  Iterator<int> get iterator => new _BitIterator(_type, _bits);
}

/// A single (unsigned) bit.
const Integral bit = const _Bit();

/// A (signed) 4-bit aggregation.
///
/// Also known as a signed _nibble_, _half-octet_, _semioctet_, _half-byte_.
///
/// Commonly used to represent:
/// * Binary-coded decimal
/// * Single decimal digits
const Integral int4 = const Integral._(4);

/// An unsigned 4-bit aggregation.
///
/// Also known as an unsigned _nibble_, _half-octet_, _semioctet_, _half-byte_.
///
/// Commonly used to represent:
/// * Binary-coded decimal
/// * Single decimal digits
const Integral uint4 = const Integral._unsigned(4);

/// A (signed) 8-bit aggregation.
///
/// Also known as an _octet_, _byte_.
///
/// Commonly used to represent:
/// * ASCII characters
const Integral int8 = const Integral._(8);

/// An unsigned 8-bit aggregation.
///
/// Also known as an _octet_, _byte_.
///
/// Commonly used to represent:
/// * ASCII characters
const Integral uint8 = const Integral._unsigned(8);

/// A (signed) 16-bit aggregation.
///
/// Also known as a _short_.
///
/// Commonly used to represent:
/// * UCS-2 characters
const Integral int16 = const Integral._(16);

/// An unsigned 16-bit aggregation.
///
/// Also known a _short_.
///
/// Commonly used to represent:
/// * UCS-2 characters
const Integral uint16 = const Integral._unsigned(16);

/// A (signed) 32-bit aggregation.
///
/// Also known as a _word_, _long_.
///
/// Commonly used to represent:
/// * UTF-32 characters
/// * True color with alpha
/// * Pointers in 32-bit computing
const Integral int32 = const Integral._(32);

/// An unsigned 32-bit aggregation.
///
/// Also known as a _word_, _long_.
///
/// Commonly used to represent:
/// * UTF-32 characters
/// * True color with alpha
/// * Pointers in 32-bit computing
const Integral uint32 = const Integral._unsigned(32);

/// A (signed) 64-bit aggregation.
///
/// Also known as a _double word_, _long long_.
///
/// Commonly used to represent:
/// * Time (milliseconds since the Unix epoch)
/// * Pointers in 64-bit computing
const Integral int64 = const Integral._(64);

/// An unsigned 64-bit aggregation.
///
/// Also known as a _double word_, _long long_.
///
/// Commonly used to represent:
/// * Time (milliseconds since the Unix epoch)
/// * Pointers in 64-bit computing
const Integral uint64 = const Integral._unsigned(64);

/// A (signed) 128-bit aggregation.
///
/// Also known as a _octa word_.
///
/// Commonly used to represent:
/// * Complicated scientific calculations
/// * IPv6 addresses GUIDs
const Integral int128 = const Integral._(128);

/// An unsigned 128-bit aggregation.
///
/// Also known as a _octa word_.
///
/// Commonly used to represent:
/// * Complicated scientific calculations
/// * IPv6 addresses GUIDs
const Integral uint128 = const Integral._unsigned(128);
