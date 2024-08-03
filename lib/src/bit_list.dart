import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:binary/src/uint32.dart';

/// An variant of `List<bool>` that ensures each `bool` takes one bit of memory.
abstract interface class BitList implements List<bool> {
  /// Creates a list of booleans with the provided [length].
  ///
  /// The list is initially filled with `false` unless [fill] is set to `true`.
  ///
  /// If [growable] is `true`, the list will be able to grow beyond its initial
  /// length.
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  factory BitList(int length, {bool fill = false, bool growable = false}) {
    if (!growable) {
      if (length <= 32) {
        return _FixedUint32BitList._(
          fill ? Uint32.max : Uint32.min,
          length: length,
        );
      } else {
        return _FixedUint32ListBitList(length, fill: fill);
      }
    }
    return _GrowableUint32ListBitList(length, fill: fill);
  }

  /// Creates a list of booleans from the provided [bits].
  ///
  /// If [growable] is `true`, the list will be able to grow beyond its initial
  /// length.
  factory BitList.from(Iterable<bool> bits, {bool growable = false}) {
    var list = <Uint32>[];
    var size = 0;
    for (final bit in bits) {
      if (size % 32 == 0) {
        list.add(Uint32.min);
      }
      list[size ~/ 32] = list[size ~/ 32].setNthBit(size % 32, bit);
      size++;
    }
    if (!growable) {
      if (size <= 32) {
        return _FixedUint32BitList._(list.first, length: size);
      } else {
        list = Uint32List.fromList(list as List<int>) as List<Uint32>;
        return _FixedUint32ListBitList._(list, length: size);
      }
    } else {
      final bits = _GrowableUint32ListBitList(size, fill: false);
      bits._bytes = Uint32List.fromList(list as List<int>) as List<Uint32>;
      bits._length = size;
      return bits;
    }
  }

  /// Creates a list of booleans that uses the provided integer as initial bits.
  ///
  /// If [length] is not provided, it is assumed to be 32, and the top 32 bits
  /// are used; otherwise, the top [length] bits are used, which cannot exceed
  /// 32.
  ///
  /// If [growable] is `true`, the list will be able to grow beyond its initial
  /// length.
  factory BitList.fromInt(int bits, {int length = 32, bool growable = false}) {
    RangeError.checkValueInInterval(length, 0, 32, 'length');
    // Mask off the top {{length}} bits.
    bits &= (1 << length) - 1;
    if (!growable) {
      return _FixedUint32BitList._(Uint32.fromUnchecked(bits), length: length);
    }
    final list = _GrowableUint32ListBitList(length, fill: false);
    list._bytes[0] = Uint32.fromUnchecked(bits);
    return list;
  }

  /// Returns a reference to the underlying bytes.
  ///
  /// By default, a copy of the bytes is returned. If [copy] is set to `false`,
  /// the original bytes are returned; if so, if either the returned list, or
  /// the bit list is modified, the other should be considered invalid.
  Uint32List toUint32List({bool copy = true});
}

/// A fixed-length list of bits that is stored in a single 32-bit integer.
final class _FixedUint32BitList with ListBase<bool> implements BitList {
  _FixedUint32BitList._(
    this._bits, {
    required this.length,
  }) : assert(length > 0 && length <= 32, 'Length must be between 1 and 32.');

  /// Backing integer that stores the bits, up to [length] bits.
  Uint32 _bits;

  @override
  final int length;

  @override
  void add(bool value) {
    throw UnsupportedError('Cannot add to a fixed-length list.');
  }

  @override
  bool operator [](int index) => _bits.nthBit(index);

  @override
  void operator []=(int index, bool value) {
    _bits = _bits.setNthBit(index, value);
  }

  @override
  set length(int newLength) {
    throw UnsupportedError('Cannot change the length of a fixed-length list.');
  }

  @override
  Uint32List toUint32List({bool copy = true}) {
    return Uint32List(1)..[0] = _bits.toInt();
  }
}

List<Uint32> _createList(int length, {required bool fill}) {
  final list = Uint32List(math.max(1, (length / 32).ceil())) as List<Uint32>;
  for (var i = 0; i < list.length; i++) {
    list[i] = fill ? Uint32.max : Uint32.min;
  }
  return list;
}

/// A fixed-length list of bits that is stored in a fixed-length [Uint32List].
abstract final class _Uint32ListBitList with ListBase<bool> implements BitList {
  List<Uint32> get _bytes;

  @override
  void add(bool value) {
    throw UnsupportedError('Cannot add to a fixed-length list.');
  }

  @override
  bool operator [](int index) {
    final byteIndex = index ~/ 32;
    final bitIndex = index % 32;
    return _bytes[byteIndex].nthBit(bitIndex);
  }

  @override
  void operator []=(int index, bool value) {
    final byteIndex = index ~/ 32;
    final bitIndex = index % 32;
    _bytes[byteIndex] = _bytes[byteIndex].setNthBit(bitIndex, value);
  }

  @override
  Uint32List toUint32List({bool copy = true}) {
    final bytes = _bytes as Uint32List;
    return copy ? Uint32List.fromList(bytes) : bytes;
  }
}

/// A fixed-length list of bits that is stored in a fixed-length [Uint32List].
final class _FixedUint32ListBitList extends _Uint32ListBitList {
  _FixedUint32ListBitList(
    int length, {
    bool fill = false,
  }) : this._(_createList(length, fill: fill), length: length);

  _FixedUint32ListBitList._(
    this._bytes, {
    required this.length,
  }) : assert(length > 32, 'Length must be greater than 32.');

  @override
  final List<Uint32> _bytes;

  @override
  final int length;

  @override
  set length(int newLength) {
    throw UnsupportedError('Cannot change the length of a fixed-length list.');
  }
}

/// A growable list of bits that is stored in a list of integers.
final class _GrowableUint32ListBitList extends _Uint32ListBitList {
  _GrowableUint32ListBitList(
    this._length, {
    required bool fill,
  }) : _bytes = _createList(_length, fill: fill);

  @override
  int get length => _length;
  int _length;

  @override
  set length(int newLength) {
    if (newLength < _length) {
      _length = newLength;
      _shrinkIfNeeded();
    } else if (newLength > _length) {
      _length = newLength;
      _growIfNeeded(newLength);
    }
  }

  @override
  List<Uint32> _bytes;
  int get _capacity => _bytes.length * 32;

  void _growIfNeeded(int index) {
    if (index < _capacity) {
      return;
    }
    final newBytes = _createList(index, fill: false);
    newBytes.setAll(0, _bytes);
    _bytes = newBytes;
  }

  void _shrinkIfNeeded() {
    final newLength = (_length / 32).ceil();
    if (newLength == _bytes.length) {
      return;
    }
    final newBytes = Uint32List(newLength) as List<Uint32>;
    newBytes.setRange(0, newLength, _bytes);
    _bytes = newBytes;
  }

  @override
  void add(bool value) {
    length++;
    this[length - 1] = value;
  }

  @override
  void addAll(Iterable<bool> bits) {
    if (bits is! List<bool>) {
      bits = List.of(bits);
    }
    final newLength = length + bits.length;
    length = newLength;
    for (var i = 0; i < bits.length; i++) {
      this[length - bits.length + i] = bits[i];
    }
  }

  @override
  Uint32List toUint32List({bool copy = true}) {
    final bytes = _bytes as Uint32List;
    if (copy) {
      return bytes.sublist(0, _capacity ~/ 32);
    }
    return bytes.buffer.asUint32List(0, _capacity ~/ 32);
  }
}
