// ignore_for_file: avoid_print
import 'package:binary/binary.dart';

void main() {
  // Using extension methods.
  //                  String            int
  //                  vvvv vvvvvvvvvvvvvvvv
  print('0111' '1111'.bits.signedRightShift(5, 8));

  // Using boxed types.
  final int8 = Int8('0111' '1111'.bits);
  // Note we did not need to pass in the length, it is provided by the class.
  print(int8.signedRightShift(5));

  // Using bit patterns.
  final $01V = BitPatternBuilder(const [
    BitPart.zero,
    BitPart.one,
    BitPart.v(1, 'V'),
  ]).build();
  print($01V.matches('011'.bits)); // true
  print($01V.capture('011'.bits)); // [1]

  // Alternative bit pattern.
  final $01Vs = BitPatternBuilder.parse('01V').build();
  print($01V == $01Vs); // true
}
