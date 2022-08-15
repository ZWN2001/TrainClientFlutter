class StringUtil{

  /// 验证是否为数字
  static bool isNumber(String str) {
    final reg = RegExp(r'^-?[0-9]+');
    return reg.hasMatch(str);
  }
}