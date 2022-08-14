import 'package:flutter/material.dart';
import 'package:train_client_flutter/route/route_table.dart';
import 'package:train_client_flutter/ui/splash.dart';
import 'package:train_client_flutter/util/sharedpreference_util.dart';

import 'api/api.dart';

Future<void> main() async {
  await initialize();
  runApp(const MyApp());
}

///初始化启动服务
Future<void> initialize() async {
  //并行初始化
  await Future.wait([
    SharedPreferenceUtil.initialize(),
  ]);
  Http.init(baseUrl: Server.baseHost, connectTimeout: 7500, receiveTimeout: 7500);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteTable.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
    );
  }
}


