import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  final storage = const FlutterSecureStorage();

// retrieve stored value
  Future<String> get({required String key}) async {
    return (await storage.read(key: key)).toString();
  }

// retrieve all stored values
  Future<Map<String, String>> getAll({required String key}) async {
    return await storage.readAll();
  }

// delete stored value
  Future delete({required String key}) async {
    await storage.delete(key: key);
  }

// delete all stored value
  Future deleteAll({required String key}) async {
    await storage.deleteAll();
  }

// store value
  Future store({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }
}
