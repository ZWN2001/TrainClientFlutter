class DateUtil {
  static String weekday(DateTime dateTime) {
    List<String> list = ['一', '二', '三', '四', '五', '六', '日'];
    return '周${list[dateTime.weekday - 1]}';
  }

  static String date(DateTime dateTime) {
    return dateTime.toIso8601String().substring(0, 10);
  }

  static String dateMonthAndDay(DateTime dateTime) {
    return dateTime.toIso8601String().substring(5, 10);
  }

  static String dateDay(DateTime dateTime) {
    return dateTime.toIso8601String().substring(5, 10);
  }



  static int compareDay(DateTime dateTime1, DateTime dateTime2) {
    dateTime1 = DateTime.parse(dateTime1.toIso8601String().substring(0, 10));
    dateTime2 = DateTime.parse(dateTime2.toIso8601String().substring(0, 10));
    return dateTime1.compareTo(dateTime2);
  }

  // static String timeInterval(String time1, String time2) {
  //   DateTime dateTime1 = DateTime.parse('2000-01-01 $time1');
  //   DateTime dateTime2 = DateTime.parse('2000-01-01 $time2');
  //   int minute = (dateTime1.hour * 60 + dateTime1.minute) -
  //       (dateTime2.hour * 60 + dateTime2.minute);
  //   minute = minute.abs();
  //   String s = '${minute ~/ 60}小时';
  //   if (minute % 60 != 0) {
  //     s +=
  //         '${minute % 60 < 10 ? '0${minute % 60}' : minute % 60}分钟';
  //   }
  //   return s;
  // }
  //
  // static String dateTimeInterval(String time1, String time2) {
  //   DateTime dateTime1 = DateTime.parse(time1);
  //   DateTime dateTime2 = DateTime.parse(time2);
  //   int minute = (dateTime1.hour * 60 + dateTime1.minute) -
  //       (dateTime2.hour * 60 + dateTime2.minute);
  //   minute = minute.abs();
  //   String s = '${minute ~/ 60}小时';
  //   if (minute % 60 != 0) {
  //     s += '${minute % 60}分钟';
  //   }
  //   return s;
  // }
}
