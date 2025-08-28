import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static final FlutterSecureStorage flutterSecureStorage =
      FlutterSecureStorage();
  static  get AcessToken => "ACCESS_TOKEN";
  static Future<void> storeString(String key, String value) async =>
      await flutterSecureStorage.write(key: key, value: value);
  static Future<String?> getString(String key) async =>
      await flutterSecureStorage.read(key: key);
  static Future<void> deleteString(String key) async =>
      flutterSecureStorage.delete(key: key);
      
  static Future<void> clearAll() async =>
      flutterSecureStorage.deleteAll();
}
