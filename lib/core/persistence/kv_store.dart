/// Abstract key-value store interface for lightweight persistence
///
/// This abstraction allows easy testing and potential implementation swaps.
abstract class KvStore {
  /// Store a string value
  Future<bool> setString(String key, String value);

  /// Retrieve a string value
  Future<String?> getString(String key);

  /// Store a boolean value
  Future<bool> setBool(String key, bool value);

  /// Retrieve a boolean value
  Future<bool?> getBool(String key);

  /// Store an integer value
  Future<bool> setInt(String key, int value);

  /// Retrieve an integer value
  Future<int?> getInt(String key);

  /// Store a list of strings
  Future<bool> setStringList(String key, List<String> value);

  /// Retrieve a list of strings
  Future<List<String>?> getStringList(String key);

  /// Remove a value by key
  Future<bool> remove(String key);

  /// Clear all stored values
  Future<bool> clear();

  /// Check if a key exists
  Future<bool> containsKey(String key);
}
