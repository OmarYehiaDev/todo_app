import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show PlatformException;

class SharedPrefsUtils {
  static SharedPreferences _preferences;
  static SharedPrefsUtils _instance;

  static SharedPrefsUtils getInstance() {
    if (_instance == null) {
      _instance = SharedPrefsUtils();
    }
    return _instance;
  }

  static Future<void> init() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }

  /// T is the  `runTimeType` data which you are trying to save (bool - String - double)
  // ignore: missing_return
  Future<bool> saveData<T>(String key, T value) async {
    print("SharedPreferences: [Saving data] -> key: $key, value: $value");
    assert(_instance != null);
    assert(_preferences != null);
    if (value is String) {
      return await _preferences.setString(key, value);
    } else if (value is bool) {
      return await _preferences.setBool(key, value);
    } else if (value is double) {
      return await _preferences.setDouble(key, value);
    } else if (value is int) {
      return await _preferences.setInt(key, value);
    }
  }

  // Future<bool> saveBool(String key, bool value) {
  //   print("SharedPreferences: [Save data] -> key: $key, value: $value");
  //   return _preferences.setBool(key, value);
  // }

  getData(String key, {bool bypassValueChecking = true}) {
    assert(_preferences != null);
    assert(_instance != null);
    var value = _preferences.get(key);
    if (value == null && !bypassValueChecking) {
      throw PlatformException(
          code: "SHARED_PREFERENCES_VALUE_CAN'T_BE_NULL",
          message:
              "you have ordered a value which doesn't exist in Shared Preferences",
          details:
              "make sure you have saved the value in advance in order to get it back");
    }
    print("SharedPreferences: [Reading data] -> key: $key, value: $value");
    return value;
  }

  Future<bool> clearData(String key) async {
    assert(_preferences != null);
    assert(_instance != null);
    try {
      return await _preferences.remove(key);
    } on Exception catch (e) {
      throw e;
    }
  }
}
