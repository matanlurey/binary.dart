/// Utilities for working with binary data and fixed-width integers within
/// Dart.
///
/// > [!NOTE]
/// > Unless otherwise noted, all functionality is based on treating bits as
/// > [little endian], that is, in a 32-bit integer the leftmost bit is 31 and
/// > the rightmost bit is 0.
///
/// [little endian]: https://en.wikipedia.org/wiki/Endianness
///
/// TODO: Further document.
library;

export 'src/descriptor.dart';
export 'src/extension.dart';
export 'src/int16.dart';
export 'src/int32.dart';
export 'src/int8.dart';
export 'src/uint16.dart';
export 'src/uint32.dart';
export 'src/uint8.dart';
