abstract class LocalStorageDataSource {
  String getStringWithKey(String key);

  void setStringWithKey(String key, String value, {Duration duration});
}
