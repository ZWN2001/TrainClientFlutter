import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {
  static const USER_ID = 'userId';


  static SharedPreferences? _instance;

  static Future initialize() async {
    _instance = await SharedPreferences.getInstance();
  }

  ///必须先进行初始化
  static SharedPreferences? get instance {
    assert(_instance != null);
    return _instance;
  }
}
