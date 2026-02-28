abstract class KvStore {
  Future<bool> setString(String key, String value);
  Future<String?> getString(String key);
  Future<bool> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<bool> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<bool> setStringList(String key, List<String> value);
  Future<List<String>?> getStringList(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
  Future<bool> containsKey(String key);
}
