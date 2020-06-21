// ignore_for_file: avoid_print
import 'package:binary/binary.dart';

void main() {
  // Using extension methods.
  //                  String         int
  //                 vvvvvvvvvv   vvvvvvvvvv
  print('0111' '1111'.parseBits().shiftRight(5, 8));

  // Using boxed types.
  final int8 = Int8('0111' '1111'.parseBits());
  // Note we did not need to pass in the length, it is provided by the class.
  print(int8.shiftRight(5));

  // Using bit patterns.
  final $01V = BitPatternBuilder(const [
    BitPart(0),
    BitPart(1),
    BitPart.v(1, 'V'),
  ]).build();
  print($01V.matches('011'.parseBits())); // true
  print($01V.capture('011'.parseBits())); // [1]

  // Alternative bit pattern.
  final $01Vs = BitPatternBuilder.parse('01V').build();
  print($01V == $01Vs); // true
}
