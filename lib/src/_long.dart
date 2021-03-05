import 'dart:math' as math;
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'int.dart';
import 'list.dart';

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
      return _max52Bits()!;
    }
    final bitWidth = 2.pow(n);
    final andHiLo = hiLo() & bitWidth.hiLo();
    return andHiLo.toInt() == 0 ? 0 : 1;
  }

  /// See [BinaryInt.setBit]; this is the version for >32-bit ints for JS.
  int setBitLong(int n) {
    if (n > _maxJs) {
      return _max52Bits()!;
    }
    final bitWidth = 2.pow(n);
    final orHiLo = hiLo() | bitWidth.hiLo();
    return orHiLo.toInt();
  }

  /// See [BinaryInt.clearBit]; this is the version for >32-bit ints for JS.
  int clearBitLong(int n) {
    if (n > _maxJs) {
      return _max52Bits()!;
    }
    final bitWidth = 2.pow(n);
    final andNotHiLo = hiLo() & ~bitWidth.hiLo();
    return andNotHiLo.toInt();
  }

  /// See [BinaryInt.bitChunk]; this is the version for >32-bits ints for JS.
  int bitChunkLong(int left, int size) {
    if (left > _maxJs) {
      return _max52Bits()!;
    }
    assert(left > 31, 'Should not have been used over normal bitChunk');
    final hiLeft = left - 32;
    final hiSize = math.min(hiLeft, size) + 1;
    final loLeft = 31;
    final loSize = size - hiSize;
    final hiLo = this.hiLo();
    final hiChunk = hiLo.hi.bitChunk(hiLeft, hiSize);
    if (loSize == 0) {
      return hiChunk;
    } else {
      final loChunk = hiLo.lo.bitChunk(loLeft, loSize);
      final hiUpper = 2.pow(math.max(loChunk.bitLength, 1));
      final loParts = Uint32List(2)..lo = loChunk;
      final result = (hiChunk * hiUpper).hiLo() | loParts;
      return result.toInt();
    }
  }
}
