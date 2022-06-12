import 'dart:typed_data';

/// A collection of binary methods to be applied to any [String] instance.
extension BinaryString on String {
  int _parseCodeUnit(int index) {
    const $0 = 48;
    const $1 = 49;
    final codeUnit = codeUnitAt(index);
    switch (codeUnit) {
      case $0:
        return 0;
      case $1:
        return 1;
      default:
        final char = String.fromCharCode(codeUnit);
        throw FormatException('Invalid character: $char.', this, index);
    }
  }

  static final _left0s = RegExp('^0+');

  /// Parses a binary number made entirely of `0`'s and `1`'s into an [int].
  ///
  /// Unlike [int.parse], this getter allows `0` as a starting character.
  int get bits {
    var s = this;
    if (s.isEmpty) {
      throw const FormatException('Non-empty string required.');
    }
    if (s.codeUnitAt(0) == 48) {
      s = s.replaceAll(_left0s, '');
    }
    if (s.isEmpty) {
      return 0;
    } else {
      return int.parse(replaceAll(_left0s, ''), radix: 2);
    }
  }

  /// Parses a binary number made entirely of `0`'s and `1`'s into a list.
  ///
  /// Each element in the resulting `List<int>` is either `0` or `1`.
  List<int> toBitList() {
    if (isEmpty) {
      throw const FormatException('Cannot parse an empty string.');
    }
    final output = Uint8List(length);
    for (var i = 0; i < length; i++) {
      output[i] = _parseCodeUnit(i);
    }
    return output;
  }
}
