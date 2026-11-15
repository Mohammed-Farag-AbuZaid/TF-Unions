final Map<String, String> _memoryStorage = {};

String? readStorage(String key) => _memoryStorage[key];

void writeStorage(String key, String value) {
  _memoryStorage[key] = value;
}
