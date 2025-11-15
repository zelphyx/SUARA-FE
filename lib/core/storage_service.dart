import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    await init();
    return await _prefs!.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    await init();
    return _prefs!.getString(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    await init();
    return await _prefs!.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    await init();
    return _prefs!.getBool(key);
  }

  static Future<bool> remove(String key) async {
    await init();
    return await _prefs!.remove(key);
  }

  static Future<bool> clear() async {
    await init();
    return await _prefs!.clear();
  }
}

