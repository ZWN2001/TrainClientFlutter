class StringUtil{

  /// 验证是否为数字
  static bool isNumber(String str) {
    final reg = RegExp(r'^-?[0-9]+');
    return reg.hasMatch(str);
  }

  /// 验证全是中文
  static bool allChinese(String str){
    final regex3 = RegExp("[\\u4e00-\\u9fa5]+");
    return regex3.hasMatch(str);
  }

  ///手机号合法
  static bool verifyPhoneNum(String str) {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(str);
  }


  /// 校验身份证合法性
  static bool verifyCardId(String cardId) {
    const Map city = {11: "北京", 12: "天津", 13: "河北", 14: "山西", 15: "内蒙古",
      21: "辽宁", 22: "吉林", 23: "黑龙江 ", 31: "上海", 32: "江苏", 33: "浙江",
      34: "安徽", 35: "福建", 36: "江西", 37: "山东", 41: "河南", 42: "湖北 ",
      43: "湖南", 44: "广东", 45: "广西", 46: "海南", 50: "重庆", 51: "四川",
      52: "贵州", 53: "云南", 54: "西藏 ", 61: "陕西", 62: "甘肃", 63: "青海",
      64: "宁夏", 65: "新疆", 71: "台湾", 81: "香港", 82: "澳门", 91: "国外 "};
    bool pass = true;

    RegExp cardReg = RegExp(r'^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$');
    if(cardId.isEmpty || !cardReg.hasMatch(cardId)) {
      pass = false;
      return pass;
    }
    if(city[int.parse(cardId.substring(0,2))] == null) {
      pass = false;
      return pass;
    }
    // 18位身份证需要验证最后一位校验位，15位不检测了，现在也没15位的了
    if (cardId.length == 18) {
      List numList = cardId.split('');
      //∑(ai×Wi)(mod 11)
      //加权因子
      List factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      //校验位
      List parity = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
      int sum = 0;
      int ai = 0;
      int wi = 0;
      for (var i = 0; i < 17; i++) {
        ai = int.parse(numList[i]);
        wi = factor[i];
        sum += ai * wi;
      }
      if (parity[sum % 11].toString() != numList[17]) {
        pass = false;
      }
    }else {
      pass = false;
    }
    return pass;
  }


}