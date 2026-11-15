import 'dart:js_interop';

@JS('localStorage.getItem')
external String? _lsGetItem(String key);

@JS('localStorage.setItem')
external void _lsSetItem(String key, String value);

String? readStorage(String key) {
  try {
    return _lsGetItem(key);
  } catch (_) {
    return null;
  }
}

void writeStorage(String key, String value) {
  try {
    _lsSetItem(key, value);
  } catch (_) {}
}
