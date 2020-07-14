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

export 'src/bit_pattern.dart';
export 'src/boxed_int.dart';
export 'src/int.dart';
export 'src/list.dart';
export 'src/string.dart';
