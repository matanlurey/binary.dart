import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'int.dart';

/// This is not an exposed interface because statically they are the same.
///
/// Instead, this extension is used an _utility_ by the `BinaryInt` extension.
extension BinaryLong on int {
  /// Represents the maximum amount of bits supported in a JS VM.
  static const _maxJs = 52;

  @alwaysThrows
  // ignore: prefer_void_to_null
  static Null _max52Bits() {
    throw UnsupportedError('Only up to 52-bits supported');
  }

  /// See [BinaryInt.getBit]; this is the version for >32-bit ints for JS.
  int getBitLong(int n) {
    if (n > _maxJs) {
      return _max52Bits();
    }
    final bitWidth = 2.pow(n);
    final andHiLo = hiLo() & bitWidth.hiLo();
    return andHiLo.toInt() == 0 ? 0 : 1;
  }

  /// See [BinaryInt.setBit]; this is the version for >32-bit ints for JS.
  int setBitLong(int n) {
    if (n > _maxJs) {
      return _max52Bits();
    }
    final bitWidth = 2.pow(n);
    final orHiLo = hiLo() | bitWidth.hiLo();
    return orHiLo.toInt();
  }

  /// See [BinaryInt.clearBit]; this is the version for >32-bit ints for JS.
  int clearBitLong(int n) {
    if (n > _maxJs) {
      return _max52Bits();
    }
    final bitWidth = 2.pow(n);
    final andNotHiLo = hiLo() & ~bitWidth.hiLo();
    return andNotHiLo.toInt();
  }
}

/// Extensions for the [BinaryLong.hiLo] resultant.
extension _BinaryHiLo on Uint32List {
  /// Represents `math.pow(2, 32)`, precomputed.
  static const _2p32 = 0x100000000;

  Uint32List operator ~() {
    return Uint32List(2)
      ..[0] = ~this[0]
      ..[1] = ~this[1];
  }

  Uint32List operator &(Uint32List b) {
    final a = this;
    return Uint32List(2)
      ..[0] = a[0] & b[0]
      ..[1] = a[1] & b[1];
  }

  Uint32List operator |(Uint32List b) {
    final a = this;
    return Uint32List(2)
      ..[0] = a[0] | b[0]
      ..[1] = a[1] | b[1];
  }

  int toInt() => this[0] * _2p32 + this[1];
}
