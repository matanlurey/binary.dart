/// Utilities for working with binary data and fixed-width integers within
/// Dart.
///
/// A spiritual successor to [`package:fixnum`][], or "what if fixnum still
/// received updates and used modern Dart features, with a focus on being able
/// to manipulate bits and bytes in a way that is both safe and efficient, using
/// [extension types][] heavily to avoid unnecessary object creation.
///
/// [package:fixnum]: https://pub.dev/packages/fixnum
/// [extension types]: https://dart.dev/language/extension-types
///
/// > [!NOTE]
/// > Unless otherwise noted, all functionality is based on treating bits as
/// > [little endian], that is, in a 32-bit integer the leftmost bit is 31 and
/// > the rightmost bit is 0. This is the same as the default behavior of the
/// > Dart SDK.
///
/// [little endian]: https://en.wikipedia.org/wiki/Endianness
library;

export 'src/as_bytes.dart';
export 'src/bit_list.dart';
export 'src/collect_bytes.dart';
export 'src/descriptor.dart';
export 'src/extension.dart';
export 'src/int16.dart';
export 'src/int32.dart';
export 'src/int8.dart';
export 'src/uint16.dart';
export 'src/uint32.dart';
export 'src/uint8.dart';
