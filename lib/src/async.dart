import 'dart:async';
import 'dart:typed_data';

/// Collects the bytes of a `Stream<List<int>>` into a [Uint8List].
///
/// This function returns a `Future<Uint8List>` that completes when the stream
/// is done, and a `Future<void> Function()` that can be used to cancel the
/// collection and underlying stream early.
(Future<Uint8List>, Future<void> Function() cancel) collectBytes(
  Stream<List<int>> stream,
) {
  final completer = Completer<Uint8List>.sync();
  final builder = BytesBuilder(copy: false);
  late final StreamSubscription<void> sub;
  sub = stream.listen(
    builder.add,
    onDone: () async {
      completer.complete(builder.toBytes());
      await sub.cancel();
    },
    onError: completer.completeError,
    cancelOnError: true,
  );
  return (completer.future, sub.cancel);
}
