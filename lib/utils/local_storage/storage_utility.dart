import 'package:get_storage/get_storage.dart';

class CLocalStorage {
  GetStorage _storage = GetStorage();

  // singleton instance
  static CLocalStorage? _instance;

  CLocalStorage._internal();

  factory CLocalStorage.instance() {
    _instance ??= CLocalStorage._internal();
    return _instance!;
  }

  static Future<void> init(String bucketName) async {
    await GetStorage.init(bucketName);
    _instance = CLocalStorage._internal();
    _instance!._storage = GetStorage(bucketName);
  }

  // -- generic method to save data
  Future<void> writeData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  // -- generic method to read data
  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  // -- generic method to remove data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // -- generic method to clear all data in storage
  Future<void> clearAll() async {
    await _storage.erase();
  }
}
