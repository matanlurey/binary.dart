export 'package:checks/checks.dart';
export 'package:test/test.dart' show TestOn, group, test;

bool get assertionsEnabled {
  var enabled = false;
  assert(enabled = true, '');
  return enabled;
}
