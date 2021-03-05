/// Whether `assert` is currently enabled.
bool get assertionsEnabled {
  var enabled = false;
  assert(enabled = true);
  return enabled;
}

extension ObjectX on Object {
  /// Casts the current object to type [T].
  ///
  /// In some production compilers, this cast is skipped.
  T unsafeCast<T>() => this as T; // ignore: return_of_invalid_type
}
