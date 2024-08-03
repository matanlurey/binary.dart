import 'dart:convert' show utf8;
import 'dart:typed_data';

import 'package:binary/binary.dart';

/// Examples of commom checksum algorithms using `package:binary`.
void main() {
  // Calculate the CRC32 checksum of a list of bytes.
  final data = Uint8List.fromList(utf8.encode('Hello, World!'));
  final checksum = crc32(data);
  print('CRC32 checksum: ${checksum.toRadixString(16)}');
}

/// Calculate the CRC32 checksum of a list of bytes using `CRC-32/JAMCRC`.
int crc32(Uint8List data, [Uint32 initialCrc = Uint32.max]) {
  var crc = initialCrc;
  for (final byte in data) {
    final index = (crc.toInt() ^ byte) & 0xFF;
    crc = (crc >> 8) ^ _crc32Table[index];
  }
  return crc.toInt();
}

final List<Uint32> _crc32Table = (() {
  // We can freely cast a Uint32List to a List<Uint32> (zero-cost).
  final table = Uint32List(256) as List<Uint32>;

  // Precompute the CRC32 table.
  for (var i = 0; i < 256; i++) {
    // Cost-free conversion from int to Uint32.
    var crc = Uint32.fromUnchecked(i);
    for (var j = 0; j < 8; j++) {
      if (crc.nthBit(0)) {
        crc = (crc >> 1) ^ const Uint32.fromUnchecked(0xEDB88320);
      } else {
        crc >>= 1;
      }
    }
    table[i] = crc;
  }
  return table;
})();
