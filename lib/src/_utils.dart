import 'package:meta/dart2js.dart' as dart2js;

/// Whether `assert` is currently enabled.
bool get assertionsEnabled {
  var enabled = false;
  assert(enabled = true, 'When assertions are disabled this will not run');
  return enabled;
}

/// Internal helpers for calling [unsafeCast].
extension UnsafeCast on Object? {
  /// Casts the current object to type [T].
  ///
  /// In some production compilers, this cast is skipped.
  @dart2js.tryInline
  @pragma('dart2js:as:trust')
  T unsafeCast<T>() => this as T;
}
