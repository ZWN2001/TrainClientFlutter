import 'dart:async';

import 'package:hive_flutter/adapters.dart';

/// Non-SQL K-V Storage
class Store {
  static late final Box _infoBox ;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox('info');
    _infoBox = Hive.box('info');
  }

  static String getString(String key, {String def = ""})  {
    return _infoBox.get(key, defaultValue: def) as String;
  }

  static int getInt(String key, {int def = 0}) {
    return _infoBox.get(key, defaultValue: def) as int;
  }

  static double getDouble(String key, {double def = 0.0}) {
    return _infoBox.get(key, defaultValue: def) as double;
  }

  static bool getBool(String key, {bool def = false})  {
    return _infoBox.get(key, defaultValue: def) as bool;
  }

  static Object get(String key) {
    return _infoBox.get(key);
  }

  static Future set(String key, Object value)  {
    return _infoBox.put(key, value);
  }

  static Future remove(String key) {
    return _infoBox.delete(key);
  }
}
