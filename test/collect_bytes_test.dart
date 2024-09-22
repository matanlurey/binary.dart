import 'package:binary/binary.dart' show collectBytes;
import 'package:test/test.dart';

import '_prelude.dart';

void main() {
  test('collect bytes', () async {
    final (bytes, _) = collectBytes(
      Stream.fromIterable([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]),
    );
    await check(bytes).completes((b) {
      b.deepEquals([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
  });

  test('cancel collect bytes', () async {
    final (bytes, cancel) = collectBytes(
      Stream.fromIterable([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]),
    );
    await cancel();
    await pumpEventQueue();
    check(bytes).doesNotComplete();
  });
}
