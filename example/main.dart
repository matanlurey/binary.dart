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
}
