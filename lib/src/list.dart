import 'dart:typed_data';

import 'boxed_int.dart';
import 'int.dart';
import 'string.dart';

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
  Uint8 getBoxed(int index) => Uint8(this[index]);

  /// Returns the [index]-th [int] right-shifted by [n].
  ///
  /// See [BinaryInt.signedRightShift].
  int signedRightShift(int index, int n) {
    return this[index] = this[index].signedRightShift(n, _length);
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
  Int8 getBoxed(int index) => Int8(this[index]);

  /// Returns the [index]-th [int] right-shifted by [n].
  ///
  /// See [BinaryInt.signedRightShift].
  int signedRightShift(int index, int n) {
    return this[index] = this[index].signedRightShift(n, _length);
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
  Uint16 getBoxed(int index) => Uint16(this[index]);

  /// Returns the [index]-th [int] right-shifted by [n].
  ///
  /// See [BinaryInt.signedRightShift].
  int signedRightShift(int index, int n) {
    return this[index] = this[index].signedRightShift(n, _length);
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
  Int16 getBoxed(int index) => Int16(this[index]);

  /// Returns the [index]-th [int] right-shifted by [n].

  /// Returns the [index]-th [int] right-shifted by [n].
  ///
  /// See [BinaryInt.signedRightShift].
  int signedRightShift(int index, int n) {
    return this[index] = this[index].signedRightShift(n, _length);
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
  Uint32 getBoxed(int index) => Uint32(this[index]);

  /// Returns the [index]-th [int] right-shifted by [n].
  ///
  /// See [BinaryInt.signedRightShift].
  int signedRightShift(int index, int n) {
    return this[index] = this[index].signedRightShift(n, _length);
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

extension BinaryUint64HiLo on Uint32List {
  /// Represents `math.pow(2, 32)`, precomputed.
  static const _2p32 = 0x100000000;

  static Uint32List _new(int a, int b) => Uint32List(2)
    ..[0] = a
    ..[1] = b;

  /// "Hi" (upper) bits.
  ///
  /// This is an alias for `[0]` and [first].
  int get hi => this[0];
  set hi(int hi) => this[0] = hi;

  /// "Lo" (lower) bits.
  ///
  /// This is an alias for `[1]` and [last].
  int get lo => this[1];
  set lo(int lo) => this[1] = lo;

  /// Returns a new [Uint32List] with bits logically negated (`~`).
  Uint32List operator ~() => _new(~hi, ~lo);

  /// Returns a new [Uint32List] with bits compared with [b] logical and (`&`).
  Uint32List operator &(Uint32List b) => _new(hi & b.hi, lo & b.lo);

  /// Returns a new [Uint32List] with bits compared with [b] logical or (`|`).
  Uint32List operator |(Uint32List b) => _new(hi | b.hi, lo | b.lo);

  /// Returns a new [Uint32List] with bits added (`+`) to [b].
  ///
  /// Overflows are handled by moving bits from [lo] to [hi], or discard [hi].
  Uint32List operator +(Uint32List b) {
    final lo = (this.lo + b.lo).hiLo();
    final hi = (this.hi + b.hi + lo.hi).hiLo();
    return _new(hi.lo, lo.lo);
  }

  /// Returns whether structurally equal to [b].
  bool equals(Uint32List b) => lo == b.lo && hi == b.hi;

  /// Returns, truncated if necessary, to fit as an [int].
  int toInt() => this[0] * _2p32 + this[1];
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
  Int32 getBoxed(int index) => Int32(this[index]);

  /// Returns the [index]-th [int] right-shifted by [n].
  ///
  /// See [BinaryInt.signedRightShift].
  int signedRightShift(int index, int n) {
    return this[index] = this[index].signedRightShift(n, _length);
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
  int toBits() {
    ArgumentError.checkNotNull(this, 'this');
    if (isEmpty) {
      throw ArgumentError.value('Must be non-empty', 'bits');
    }
    return join('').bits;
  }

  /// Returns the [index]-th [int] with [BinaryInt.signExtend] applied.
  int signExtend(int index, int startSize, int endSize) {
    return this[index] = this[index].signExtend(startSize, endSize);
  }

  /// Returns the [index]-th [int] with [BinaryInt.rotateRightShift] applied.
  int rotateRightShift(int index, int amount, int bitWidth) {
    return this[index] = this[index].rotateRightShift(amount, bitWidth);
  }

  /// Returns the [index]-th [int] with [BinaryInt.countSetBits] applied.
  ///
  /// > NOTE: The [length] property is both required and not validated for
  /// > correctness. See [Uint8List.countSetBits] or [Integral.bitsSet].
  int countSetBits(int index, int bitWidth) {
    return this[index].countSetBits(bitWidth);
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

  /// Returns [BinaryInt.toggleBit] applied to the [index]-th [int].
  int toggleBit(int index, int n, [bool? v]) {
    v ??= !isSet(index, n);
    return v ? setBit(index, n) : clearBit(index, n);
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
