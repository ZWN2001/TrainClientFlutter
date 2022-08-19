import 'package:flutter/material.dart';
import 'package:train_client_flutter/ui/passenger/add_passenger.dart';
import 'package:train_client_flutter/ui/passenger/my_passengers.dart';
import 'package:train_client_flutter/ui/order/my_tickets.dart';
import 'package:train_client_flutter/ui/order/order_all.dart';
import 'package:train_client_flutter/ui/timetable.dart';

import '../api/api.dart';
import '../ui/login.dart';
import '../ui/main_page.dart';
import '../ui/order/order_paied.dart';
import '../ui/order/order_unpaied.dart';
import '../ui/splash.dart';

/// 路由表
class RouteTable {
  static final Map<String, WidgetBuilder> _routes = {
    // 开屏界面
    '/': (context) =>  const Splash(),
    MainPage.routeName: (context) => const MainPage(),
    OrderUnpaiedPage.routeName: (context) => const OrderUnpaiedPage(),
    OrderPaiedPage.routeName: (context) => const OrderPaiedPage(),
    OrderAllPage.routeName: (context) => const OrderAllPage(),
    MyTicketPage.routeName: (context) => const MyTicketPage(),
    MyPassengerPage.routeName: (context) => const MyPassengerPage(),
    AddPassengerPage.routeName: (context) => const AddPassengerPage(),
    LoginPage.routeName: (context) => const LoginPage(),
    TimeTablePage.routeName: (context) => const TimeTablePage(),
  };

//  鉴权拦截表
  static final Map<String, bool> _needLogin = {
    OrderUnpaiedPage.routeName: true,
    OrderPaiedPage.routeName: true,
    OrderAllPage.routeName: true,
    MyTicketPage.routeName: true,
    MyPassengerPage.routeName: true,
  };

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
    if (UserApi.curUser == null && (_needLogin[settings.name] ?? false)) {
      return MaterialPageRoute(
          builder: (context) => const LoginPage(), settings: settings);
    } else {
      return MaterialPageRoute(
          builder: _routes[settings.name]!, settings: settings);
    }
  }
}
