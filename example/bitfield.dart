import 'package:binary/binary.dart' show Uint8;

/// Let's assume we have the following format:
/// ```txt
/// 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
/// - | ----- | - | -------------
/// P | Level | S | Kind
/// ```
void main() {
  // Create a bit field with the format.
  final field = Uint8.zero
      .replace(0, 3, int.parse('1101', radix: 2)) // Kind
      .replace(4, 4, int.parse('1', radix: 2)) // S
      .replace(5, 6, int.parse('10', radix: 2)) // Level
      .replace(7, 7, int.parse('1', radix: 2)); // P

  //                                P  S
  //                                vv v
  print(field.toBinaryString()); // 11011101
  //                                 ^^ ^^^^
  //                              Level Kind

  // Now, read it back.
  final (kind, s, level, p) = (
    field.slice(0, 3),
    field.slice(4, 4),
    field.slice(5, 6),
    field.slice(7, 7),
  );

  print('');
  print('Kind:  ${kind.toBinaryString()}');
  print('S:     ${s.toBinaryString()}');
  print('Level: ${level.toBinaryString()}');
  print('P:     ${p.toBinaryString()}');
}
