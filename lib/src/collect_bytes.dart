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
  final builder = BytesBuilder(copy: false);
  final sub = stream.listen(builder.add);

  // Intentionally don't await, the goal is to return the future.
  // ignore: discarded_futures
  return (sub.asFuture(builder).then((b) => b.takeBytes()), sub.cancel);
}
