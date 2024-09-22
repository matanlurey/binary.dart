import 'dart:typed_data';

import 'package:binary/binary.dart';

import '_prelude.dart';

void main() {
  test('view a Uint8List', () {
    final buffer = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    final view = viewOrCopyAsBytes(buffer);
    check(view).deepEquals(buffer);

    // Change the view to see if the buffer is modified.
    view[0] = 0;
    check(buffer).deepEquals([0, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  test('view a Uint16List', () {
    final buffer = Uint16List.fromList([
      0x0102,
      0x0304,
      0x0506,
      0x0708,
      0x090A,
    ]);

    final view = viewOrCopyAsBytes(buffer);
    check(view).deepEquals([
      0x02,
      0x01,
      0x04,
      0x03,
      0x06,
      0x05,
      0x08,
      0x07,
      0x0A,
      0x09,
    ]);

    // Change the view to see if the buffer is modified.
    view[0] = 0;
    view[1] = 0;

    check(buffer).deepEquals([
      0x0000,
      0x0304,
      0x0506,
      0x0708,
      0x090A,
    ]);
  });

  test('copy a List<int>', () {
    final buffer = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    final copy = viewOrCopyAsBytes(buffer);
    check(copy).deepEquals(buffer);

    // Change the copy to see the buffer is *not* modified.
    copy[0] = 0;
    check(buffer).deepEquals([1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });
}
