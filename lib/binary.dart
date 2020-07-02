/// Utilities for working with binary data within Dart.
///
/// > NOTE: Unless otherwise noted, all functionality is based around treating
/// > bits as [little endian](https://en.wikipedia.org/wiki/Endianness), that
/// > is, in a 32-bit integer the leftmost bit is 31 and the rightmost bit is 0.
///
/// There are a few sets extension methods that are intended to be generally
/// useful for libraries and apps that need to access, manipulate, or visualize
/// binary data (and individual bits), and are intended to be as performant as
/// possible:
///
/// - [BinaryInt]: Provides `int` with methods to access/manipulate bytes.
/// - [BinaryList]: Assumes a `List<int>` of just `0` and `1`, provides methods.
/// - [BinaryString]: Assumes a `String` of just `'0'` and `1`, provides methods.
///
/// Do note that the built-in `dart:typed_data` representations, such as
/// [Uint8List] are _greatly_ preferred in terms of performance to creating your
/// own abstractions like `List<int>`. Extensions similar to [BinaryInt] are
/// also provided for the various typed list sub-types:
///
/// - [BinaryInt8List]
/// - [BinaryUint8List]
/// - ... and so on, up to `Int32List` and `Uint32List`.
///
/// > Notably, the above extension methods do _not_ know the underlying bit
/// > size and require a `length` parameter where the method would otherwise be
/// > ambiguous.
///
/// For users that desire more type safety (i.e. want to explicitly declare and
/// enforce size of binary data) at the cost of performance, there are also
/// boxed int representations:
///
/// - [Bit]
/// - [Int4], [Uint4]
/// - [Int8], [Uint8]
/// - [Int16], [Uint16]
/// - [Int32], [Uint32]
///
/// > Integers with a size greater than 32-bits are not explicitly supported
/// > due to the fact that compatibility varies based on the deployment
/// > platform (e.g. on the web/JavaScript).
/// >
/// > We could add limited forms of support with `BigInt`; file a request!
library binary;

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:meta/meta.dart';

part 'src/bit_pattern.dart';

bool get _assertionsEnabled {
  var enabled = false;
  assert(enabled = true);
  return enabled;
}

extension on Object {
  /// Casts the current object to type [T].
  ///
  /// In some production compilers, this cast is skipped.
  T unsafeCast<T>() => this; // ignore: return_of_invalid_type
}

/// A collection of unchecked binary methods to be applied to an [int].
///
/// > NOTE: There is limited range checking in this function. To verify
/// > accessing a valid bit use one of the [Integral.getBit] implementations,
/// > which knows both the minimum and maximum number of bits.
///
/// For example:
/// ```
/// // Unchecked. We assume 'bits' is meant to represent at least 7 bits.
/// void example1(int bits) {
///   print(bits.getBit(7));
/// }
///
/// // Checked. Will throw a RangeError because Int4 cannot have 7 bits.
/// void example2(Int4 bits) {
///   print(bits.getBit(7));
/// }
/// ```
extension BinaryInt on int {
  /// Returns boxed as a [Bit] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  Bit asBit() => Bit(this);

  /// Returns boxed as an [Int4] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  Int4 asInt4() => Int4(this);

  /// Returns boxed as an [Uint4] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  Uint4 asUint4() => Uint4(this);

  /// Returns boxed as an [Int8] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  Int8 asInt8() => Int8(this);

  /// Returns boxed as an [Uint8] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  Uint8 asUint8() => Uint8(this);

  /// Returns boxed as an [Int16] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  Int16 asInt16() => Int16(this);

  /// Returns boxed as an [Uint16] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  Uint16 asUint16() => Uint16(this);

  /// Returns boxed as an [Int32] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  Int32 asInt32() => Int32(this);

  /// Returns boxed as an [Uint32] instance.
  ///
  /// This is a convenience and should be avoided for perf-sensitive code.
  Uint32 asUint32() => Uint32(this);

  /// Returns [this] arithetically right-shifted by [n] bytes assuming [length].
  ///
  /// This is intended to be roughly equivalent to JavaScript's `>>>` operator.
  ///
  /// > NOTE: [length] is _not_ validated. See [Integral.shiftRight].
  int shiftRight(int n, int length) {
    final leftPadding = msb(length) ? math.pow(2, n).unsafeCast<int>() - 1 : 0;
    return (leftPadding << (length - n)) | (this >> n);
  }

  /// Returns [this] sign-extended to [endSize] bits.
  ///
  /// Sign extension is the operation of increasing the number of bits of a
  /// binary number while preserving the number's sign. This is done by
  /// appending digits to the most significant side of the number, i.e. if 6
  /// bits are used to represent the value `00 1010` (decimal +10) and the sign
  /// extend operation increases the word length to 16 bits, the new
  /// representation is `0b0000 0000 0000 1010`.
  ///
  /// Simiarily, the 10 bit value `11 1111 0001` can be sign extended to 16-bits
  /// as `1111 1111 1111 0001`. This method is provided as a convenience when
  /// converting between ints of smaller sizes to larger sizes.
  int signExtend(int startSize, int endSize) {
    if (endSize <= startSize) {
      throw RangeError.value(
        endSize,
        'endSize',
        'Expected endSize ($endSize) <= startSize ($startSize).',
      );
    }
    final extendBit = getBit(startSize - 1);
    if (extendBit == 1) {
      final highBits = math.pow(2, endSize - startSize).unsafeCast<int>() - 1;
      return (highBits << startSize) | this;
    } else {
      return this;
    }
  }

  /// Returns a bit-wise right-rotation on [this] by an [amount] of bits.
  int rotateRight(int amount) {
    var bits = this;
    for (var i = 0; i < amount; i++) {
      bits = bits >> 1 | bits & 0x01 << 31;
    }
    return bits;
  }

  /// Returns the number of set bits in [this], assuming a [length]-bit [this].
  ///
  /// > NOTE: [length] is _not_ validated. See [Integral.setBits].
  int countSetBits(int length) {
    var count = 0;
    for (var i = 0; i < length; i++) {
      if (this & (1 << i) != 0) {
        count++;
      }
    }
    return count;
  }

  /// Returns whether the most-significant-bit in [this] (of [length]) is set.
  ///
  /// > NOTE: [length] is _not_ validated. See [Integral.msb].
  bool msb(int length) {
    return isSet(length - 1);
  }

  /// Throws [RangeError] if [n] is not at least `0`.
  void _mustBeAtLeast0(int n) {
    RangeError.checkNotNegative(n);
  }

  int _getBit(int n) => this >> n & 1;

  /// Returns `1` if [n]th is bit set, else `0`.
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  int getBit(int n) {
    _mustBeAtLeast0(n);
    return _getBit(n);
  }

  int _setBit(int n) => this | (1 << n);

  /// Returns a new [int] with the [n]th bit set.
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  int setBit(int n) {
    _mustBeAtLeast0(n);
    return _setBit(n);
  }

  int _clearBit(int n) => this & ~(1 << n);

  /// Returns a new [int] with the [n]th bit cleared.
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  int clearBit(int n) {
    _mustBeAtLeast0(n);
    return _clearBit(n);
  }

  /// Returns whether bit [n] is set (i.e. `1`).
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  bool isSet(int n) => getBit(n) == 1;

  /// Returns whether bit [n] is cleared (i.e. `0`).
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  bool isClear(int n) => getBit(n) == 0;

  /// Returns an [int] containining bits _exclusive_ of the last bit.
  ///
  /// The result is left-padded with 0's.
  ///
  /// The current [int] instance is treated as bits of an unknown length.
  int bitChunk(int left, int size) {
    if (left < 0) {
      throw RangeError.value(left, 'left', 'Out of range. Must be > 0.');
    } else if (size < 1) {
      throw RangeError.value(size, 'size', 'Out of range. Must be >= 1.');
    } else if (left - size < -1) {
      throw RangeError.value(left - size, 'left - size', 'Expected >= -1');
    }
    return (this >> (left + 1 - size)) & ~(~0 << size);
  }

  /// Returns an [int] containining bits _inclusive_ of the last bit.
  ///
  /// The result is left-padded with 0's.
  int bitRange(int left, int right) => bitChunk(left, left - right + 1);

  /// Returns an [int] replacing the bits from [left] to [right] with [bits].
  int replaceBitRange(int left, int right, int bits) {
    final orig = this;
    final mask = ~(~0 << (left - right + 1));
    return (orig & ~mask) | (bits & mask);
  }

  /// Returns [this] as a binary string representation.
  String toBinary() => toRadixString(2);

  /// Returns [this] as a binary string representation, padded with `0`'s.
  String toBinaryPadded(int length) {
    return toUnsigned(length).toBinary().padLeft(length, '0');
  }
}

/// A collection of binary methods to be applied to elements of [Uint8List].
///
/// The methods here are roughly the same as those on [BinaryInt], except that
/// they operate on an [index] of the underlying list, and infer the `length`
/// property based on the data type of the underlying list (i.e. `Uint8List` has
/// a `length` of `8`).
///
/// See [BinaryList] for more extension methods that operate on any `List<int>`.
extension BinaryUint8List on Uint8List {
  static const _length = 8;

  /// Returns the [index]-th [int] boxed as a [Uint8].
  Uint8 getBoxed(int index) => this[index].asUint8();

  /// Returns the [index]-th [int] right-shifted by [n].
  ///
  /// See [BinaryInt.shiftRight].
  int shiftRight(int index, int n) {
    return this[index] = this[index].shiftRight(n, _length);
  }

  /// Returns [BinaryInt.countSetBits] applied to the [index]-th [int].
  int countSetBits(int index) {
    return this[index].countSetBits(_length);
  }

  /// Returns [BinaryInt.msb] applied to the [index]-th [int].
  bool msb(int index) {
    return this[index].msb(_length);
  }
}

/// A collection of binary methods to be applied to elements of [Int8List].
///
/// The methods here are roughly the same as those on [BinaryInt], except that
/// they operate on an [index] of the underlying list, and infer the `length`
/// property based on the data type of the underlying list (i.e. `Int8List` has
/// a `length` of `8`).
///
/// See [BinaryList] for more extension methods that operate on any `List<int>`.
extension BinaryInt8List on Int8List {
  static const _length = 8;

  /// Returns the [index]-th [int] boxed as a [Int8].
  Int8 getBoxed(int index) => this[index].asInt8();

  /// Returns the [index]-th [int] right-shifted by [n].
  ///
  /// See [BinaryInt.shiftRight].
  int shiftRight(int index, int n) {
    return this[index] = this[index].shiftRight(n, _length);
  }

  /// Returns [BinaryInt.countSetBits] applied to the [index]-th [int].
  int countSetBits(int index) {
    return this[index].countSetBits(_length);
  }

  /// Returns [BinaryInt.msb] applied to the [index]-th [int].
  bool msb(int index) {
    return this[index].msb(_length);
  }
}

/// A collection of binary methods to be applied to elements of [Uint16List].
///
/// The methods here are roughly the same as those on [BinaryInt], except that
/// they operate on an [index] of the underlying list, and infer the `length`
/// property based on the data type of the underlying list (i.e. `Uint16List`
/// has a `length` of `16`).
///
/// See [BinaryList] for more extension methods that operate on any `List<int>`.
extension BinaryUint16List on Uint16List {
  static const _length = 16;

  /// Returns the [index]-th [int] boxed as a [Uint16].
  Uint16 getBoxed(int index) => this[index].asUint16();

  /// Returns the [index]-th [int] right-shifted by [n].
  ///
  /// See [BinaryInt.shiftRight].
  int shiftRight(int index, int n) {
    return this[index] = this[index].shiftRight(n, _length);
  }

  /// Returns [BinaryInt.countSetBits] applied to the [index]-th [int].
  int countSetBits(int index) {
    return this[index].countSetBits(_length);
  }

  /// Returns [BinaryInt.msb] applied to the [index]-th [int].
  bool msb(int index) {
    return this[index].msb(_length);
  }
}

/// A collection of binary methods to be applied to elements of [Int16List].
///
/// The methods here are roughly the same as those on [BinaryInt], except that
/// they operate on an [index] of the underlying list, and infer the `length`
/// property based on the data type of the underlying list (i.e. `Int16List`
/// has a `length` of `16`).
///
/// See [BinaryList] for more extension methods that operate on any `List<int>`.
extension BinaryInt16List on Int16List {
  static const _length = 16;

  /// Returns the [index]-th [int] boxed as a [Int16].
  Int16 getBoxed(int index) => this[index].asInt16();

  /// Returns the [index]-th [int] right-shifted by [n].
  ///
  /// See [BinaryInt.shiftRight].
  int shiftRight(int index, int n) {
    return this[index] = this[index].shiftRight(n, _length);
  }

  /// Returns [BinaryInt.countSetBits] applied to the [index]-th [int].
  int countSetBits(int index) {
    return this[index].countSetBits(_length);
  }

  /// Returns [BinaryInt.msb] applied to the [index]-th [int].
  bool msb(int index) {
    return this[index].msb(_length);
  }
}

/// A collection of binary methods to be applied to elements of [Uint32List].
///
/// The methods here are roughly the same as those on [BinaryInt], except that
/// they operate on an [index] of the underlying list, and infer the `length`
/// property based on the data type of the underlying list (i.e. `Uint32List`
/// has a `length` of `32`).
///
/// See [BinaryList] for more extension methods that operate on any `List<int>`.
extension BinaryUint32List on Uint32List {
  static const _length = 32;

  /// Returns the [index]-th [int] boxed as a [Uint32].
  Uint32 getBoxed(int index) => this[index].asUint32();

  /// Returns the [index]-th [int] right-shifted by [n].
  ///
  /// See [BinaryInt.shiftRight].
  int shiftRight(int index, int n) {
    return this[index] = this[index].shiftRight(n, _length);
  }

  /// Returns [BinaryInt.countSetBits] applied to the [index]-th [int].
  int countSetBits(int index) {
    return this[index].countSetBits(_length);
  }

  /// Returns [BinaryInt.msb] applied to the [index]-th [int].
  bool msb(int index) {
    return this[index].msb(_length);
  }
}

/// A collection of binary methods to be applied to elements of [Int32List].
///
/// The methods here are roughly the same as those on [BinaryInt], except that
/// they operate on an [index] of the underlying list, and infer the `length`
/// property based on the data type of the underlying list (i.e. `Int32List`
/// has a `length` of `32`).
///
/// See [BinaryList] for more extension methods that operate on any `List<int>`.
extension BinaryInt32List on Int32List {
  static const _length = 32;

  /// Returns the [index]-th [int] boxed as a [Int32].
  Int32 getBoxed(int index) => this[index].asInt32();

  /// Returns the [index]-th [int] right-shifted by [n].
  ///
  /// See [BinaryInt.shiftRight].
  int shiftRight(int index, int n) {
    return this[index] = this[index].shiftRight(n, _length);
  }

  /// Returns [BinaryInt.countSetBits] applied to the [index]-th [int].
  int countSetBits(int index) {
    return this[index].countSetBits(_length);
  }

  /// Returns [BinaryInt.msb] applied to the [index]-th [int].
  bool msb(int index) {
    return this[index].msb(_length);
  }
}

/// A collection of binary methods to be applied to any `List<int>` instance.
extension BinaryList on List<int> {
  /// Converts a list of individual bytes to bits represented as an [int].
  ///
  /// Bytes are represented in order to right-most to left-most.
  int parseBits() {
    ArgumentError.checkNotNull(this, 'this');
    if (isEmpty) {
      throw ArgumentError.value('Must be non-empty', 'bits');
    }
    return join('').parseBits();
  }

  /// Returns the [index]-th [int] with [BinaryInt.signExtend] applied.
  int signExtend(int index, int startSize, int endSize) {
    return this[index] = this[index].signExtend(startSize, endSize);
  }

  /// Returns the [index]-th [int] with [BinaryInt.rotateRight] applied.
  int rotateRight(int index, int amount) {
    return this[index] = this[index].rotateRight(amount);
  }

  /// Returns the [index]-th [int] with [BinaryInt.countSetBits] applied.
  ///
  /// > NOTE: The [length] property is both required and not validated for
  /// > correctness. See [Uint8List.countSetBits] or [Integral.setBits].
  int countSetBits(int index, int length) {
    return this[index].countSetBits(length);
  }

  /// Returns [BinaryInt.getInt] applied to the [index]-th [int].
  int getBit(int index, int n) {
    return this[index].getBit(n);
  }

  /// Returns [BinaryInt.setBit] applied to the [index]-th [int].
  int setBit(int index, int n) {
    return this[index] = this[index].setBit(n);
  }

  /// Returns [BinaryInt.clearBit] applied to the [index]-th [int].
  int clearBit(int index, int n) {
    return this[index] = this[index].clearBit(n);
  }

  /// Returns [BinaryInt.isSet] applied to the [index]-th [int].
  bool isSet(int index, int n) {
    return this[index].isSet(n);
  }

  /// Returns [BinarytInt.isClear] applied to the [index]-th [int].
  bool isClear(int index, int n) {
    return this[index].isClear(n);
  }

  /// Returns [BinaryInt.bitChunk] applied to the [index]-th [int].
  int bitChunk(int index, int left, int size) {
    return this[index].bitChunk(left, size);
  }

  /// Returns [BinaryInt.bitRange] applied to the [index]-th [int].
  int bitRange(int index, int left, int right) {
    return this[index].bitRange(left, right);
  }

  /// Returns [BinaryInt.replaceBitRange] applied to the [index]-th [int].
  int replaceBitRange(int index, int left, int right, int bits) {
    return this[index].replaceBitRange(left, right, bits);
  }
}

/// A collection of binary methods to be applied to any [String] instance.
extension BinaryString on String {
  int _parseCodeUnit(int index) {
    const $0 = 48;
    const $1 = 49;
    final codeUnit = this.codeUnitAt(index);
    switch (codeUnit) {
      case $0:
        return 0;
      case $1:
        return 1;
      default:
        final char = String.fromCharCode(codeUnit);
        throw FormatException('Invalid character: $char.', this, index);
    }
  }

  static final _left0s = RegExp(r'^0+');

  /// Parses a binary number made entirely of `0`'s and `1`'s into an [int].
  ///
  /// Unlike [int.parse], this function allows `0` as a starting character.
  int parseBits() {
    var s = this;
    if (s.isEmpty) {
      throw FormatException('Non-empty string required.');
    }
    if (s.codeUnitAt(0) == 48) {
      s = s.replaceAll(_left0s, '');
    }
    if (s.isEmpty) {
      return 0;
    } else {
      return int.parse(replaceAll(_left0s, ''), radix: 2);
    }
  }

  /// Parses a binary number made entirely of `0`'s and `1`'s into a list.
  ///
  /// Each element in the resulting `List<int>` is either `0` or `1`.
  List<int> toBitList() {
    if (isEmpty) {
      throw FormatException('Cannot parse an empty string.');
    }
    final output = Uint8List(length);
    for (var i = 0; i < length; i++) {
      output[i] = _parseCodeUnit(i);
    }
    return output;
  }
}

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
  final bool signed;

  /// Used for implementing sub-types.
  Integral.checked({
    @required this.value,
    @required this.size,
    @required this.signed,
  }) : assert(value != null) {
    RangeError.checkValueInInterval(this.value, _min, _max);
  }

  /// An unsafe constructor that does not verify if the values are within range.
  const Integral.unchecked({
    @required this.value,
    @required this.size,
    @required this.signed,
  });

  /// Implement to create an instance of self around [value].
  @protected
  @visibleForOverriding
  T wrapSafeValue(int value);

  /// Wraps [value], careful to normalize (unsign) if necessary.
  T _wrapSignAware(int value) {
    if (unsigned) {
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
        signed == o.signed;
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
    if (signed) {
      return (-math.pow(2, size - 1)).unsafeCast();
    } else {
      return 0;
    }
  }

  /// Maximum value representable by this type.
  int get _max {
    if (signed) {
      return (math.pow(2, size - 1) - 1).unsafeCast();
    } else {
      return (math.pow(2, size) - 1).unsafeCast();
    }
  }

  void _assertMaxBits(int value, [String name]) {
    RangeError.checkValueInInterval(value, 0, size - 1, name);
  }

  /// Where this data type is not signed (0 or positive integers only).
  @nonVirtual
  bool get unsigned => !signed;

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
  bool get isNegative => signed ? msb : false;

  /// Returns `true` iff [value] represents a positive number, else `false`.
  @nonVirtual
  bool get isPositive => !isNegative;

  /// Returns [value] arithmetically right-shifted [n] bits.
  ///
  /// See [BinaryInt.shiftRight].
  @nonVirtual
  T shiftRight(int n) {
    return wrapSafeValue(value.shiftRight(n, size));
  }

  /// Returns a bit-wise right rotation on [value] by [number] of bits.
  ///
  /// See [BinaryInt.rotateRight].
  @nonVirtual
  T rotateRight(int number) {
    return wrapSafeValue(value.rotateRight(number));
  }

  /// Returns the number of set bits in [value].
  @nonVirtual
  int get setBits {
    return value.countSetBits(size);
  }

  /// Returns whether the most-significant-bit in [value] is set.
  @nonVirtual
  bool get msb => isSet(size - 1);

  @override
  @nonVirtual
  String toString() {
    if (_assertionsEnabled) {
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
    return _assertionsEnabled ? checkRange(value) : value;
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
    return _assertionsEnabled ? checkRange(value) : value;
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
    return _assertionsEnabled ? checkRange(value) : value;
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
    return _assertionsEnabled ? checkRange(value) : value;
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
    return _assertionsEnabled ? checkRange(value) : value;
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
    return _assertionsEnabled ? checkRange(value) : value;
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
    return _assertionsEnabled ? checkRange(value) : value;
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
    return _assertionsEnabled ? checkRange(value) : value;
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
    return _assertionsEnabled ? checkRange(value) : value;
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
