import 'local_storage_data_source.dart';

class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  Function(String) read;
  Function(String, String) write;
  Function getMillisecondsSinceEpoch;

  LocalStorageDataSourceImpl({required this.read, required this.write, required this.getMillisecondsSinceEpoch});

  @override
  String getStringWithKey(String key) {
    // if (key == TOKEN_KEY_SAVE_IN_LOCAL) {
    //   return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNjQ5NjU3MTA4LCJleHAiOjE2NTIyNDkxMDh9.uzLxGFQubyEDW5xsPWhZszl5YwNRyRuNeZ44H2C0Q64";
    // }
    return read(key) ?? "";
  }

  @override
  void setStringWithKey(String key, String value, {Duration? duration}) {
    write(key, value);
    int currentTime = getMillisecondsSinceEpoch();
    if (duration != null) write("$key expireDate", (currentTime + duration.inMilliseconds).toString());
  }
}
