import 'package:binary/binary.dart';

void main() {
  // Parse and reprsent a binary integer:
  final rawInt = int.parse('0111' '1111', radix: 2);
  final fixInt = Uint8(rawInt);
  print(fixInt); // 127

  // Works identically to the >>> operator in JavaScript:
  final shifted = fixInt.signedRightShift(5);
  print(shifted.toBinaryString()); // 00000011
}
