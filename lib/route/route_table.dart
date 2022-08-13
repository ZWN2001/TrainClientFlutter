import 'package:flutter/material.dart';
import 'package:train_client_flutter/ui/order_all.dart';
import 'package:train_client_flutter/ui/order_unpaied.dart';

import '../ui/main_page.dart';
import '../ui/splash.dart';
import '../ui/order_paied.dart';

/// 路由表
class RouteTable {
  //路由界面a-z排序
  static final Map<String, WidgetBuilder> _routes = {
    // 开屏界面
    '/': (context) =>  const Splash(),
    // 主界面
    '/main_page': (context) => const MainPage(),
    '/order_unpaid':(context) => const OrderUnpaiedPage(),
    '/order_paid':(context) => const OrderPaiedPage(),
    '/order_all':(context) => const OrderAllPage(),
  };

  //鉴权拦截表
  // static Map<String, bool> _needLogin = {
  //   //主界面
  //   '/': false,
  //   //教务
  //   'academic_page': true,
  //   //近期活动
  //   'activity_page': false,
  //   //账单查询
  //   'account_bill_page': true,
  //   //蹭课助手
  //   'audit_course_page': false,
  //   //校车查询
  //   'bus_page': true,
  //   //校历
  //   'calendar_page': false,
  //   //下载中心
  //   'download_page': false,
  //   //教学计划
  //   'education_plan_page': true,
  //   //教学评估
  //   'evaluate_page': true,
  //   //考试安排
  //   'exam_page': true,
  //   //成绩查询
  //   'grade_page': true,
  //   //选课历史
  //   'history_page': true,
  //   //图书馆
  //   'library_page': true,
  //   //登录
  //   'login_page': false,
  //   //主界面
  //   'main_page': false,
  //   //校区地图
  //   'map_page': false,
  //   //辅修登录
  //   'minor_login': true,
  //   //辅修管理
  //   'minor_manage': true,
  //   //更多功能
  //   'more_page': false,
  //   //校内电话
  //   'phone_page': false,
  //   //自习室
  //   'study_room_page': true,
  //   //待办事项
  //   'todo_screen_page': false,
  //   //工具箱
  //   'tools_page': false,
  //   //志愿查询
  //   'volunteer_page': true,
  //   //宿舍电量
  //   'dorm_electric_page':false
  // };

  static Route generateRoute(RouteSettings settings) {
    // 路由名称未出现在路由表里,返回空界面
    if (!_routes.containsKey(settings.name)) {
      return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Not fount'),),
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ));
    }
    // if (UserAPI.curUser == null && (_needLogin[settings.name] ?? false)) {
    //   return MaterialPageRoute(
    //       builder: (context) => LoginPage(), settings: settings);
    // } else {
      return MaterialPageRoute(
          builder: _routes[settings.name]!, settings: settings);
    // }
  }
}
