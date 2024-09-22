import 'dart:typed_data';

/// Returns a [Uint8List] representation of the given [bytesOrBuffer].
///
/// This method attempts to avoid unnecessary copying of the buffer, and will
/// return the buffer as-is if it is already a [Uint8List], or a type that can
/// be viewed as a [Uint8List] (such as a [Uint8ClampedList] or [Uint16List]).
@pragma('vm:always-consider-inlining')
Uint8List viewOrCopyAsBytes(List<int> bytesOrBuffer) {
  // View the buffer as a Uint8List if possible.
  if (bytesOrBuffer case final TypedData data) {
    return data.buffer.asUint8List();
  }

  // Otherwise, copy the buffer into a new Uint8List.
  return Uint8List.fromList(bytesOrBuffer);
}
