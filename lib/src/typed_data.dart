import 'dart:typed_data';

import 'package:binary/binary.dart';

/// Extensions that make [Uint8List] and [Uint8] work together.
extension Uint8ListExtension on Uint8List {
  /// Infallible cast that treats a [Uint8List] as a `List<Uint8>`.
  ///
  /// The same instance is returned.
  List<Uint8> asListUint8() => this as List<Uint8>;
}

/// Extensions that make [Uint16List] and [Uint16] work together.
extension Uint16ListExtension on Uint16List {
  /// Infallible cast that treats a [Uint16List] as a `List<Uint16>`.
  ///
  /// The same instance is returned.
  List<Uint16> asListUint16() => this as List<Uint16>;
}

/// Extensions that make [Uint32List] and [Uint32] work together.
extension Uint32ListExtension on Uint32List {
  /// Infallible cast that treats a [Uint32List] as a `List<Uint32>`.
  ///
  /// The same instance is returned.
  List<Uint32> asListUint32() => this as List<Uint32>;
}

/// Extensions that make [Int8List] and [Int8] work together.
extension Int8ListExtension on Int8List {
  /// Infallible cast that treats a [Int8List] as a `List<Int8>`.
  ///
  /// The same instance is returned.
  List<Int8> asListInt8() => this as List<Int8>;
}

/// Extensions that make [Int16List] and [Int16] work together.
extension Int16ListExtension on Int16List {
  /// Infallible cast that treats a [Int16List] as a `List<Int16>`.
  ///
  /// The same instance is returned.
  List<Int16> asListInt16() => this as List<Int16>;
}

/// Extensions that make [Int32List] and [Int32] work together.
extension Int32ListExtension on Int32List {
  /// Infallible cast that treats a [Int32List] as a `List<Int32>`.
  ///
  /// The same instance is returned.
  List<Int32> asListInt32() => this as List<Int32>;
}
