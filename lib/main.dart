import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:train_client_flutter/constant.dart';
import 'package:train_client_flutter/route/route_table.dart';
import 'package:train_client_flutter/ui/splash.dart';
import 'package:train_client_flutter/util/store.dart';

import 'api/api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  runApp(const MyApp());
}

///初始化启动服务
Future<void> initialize() async {
  Http.init(baseUrl: Server.baseHost, connectTimeout: 7500, receiveTimeout: 7500);
  //并行初始化
  await Future.wait([
    Store.initialize(),
    Constant.initStationInfo(),
    Constant.initSeatInfo()
  ]);
  // UserApi.initUserFromCache();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onGenerateRoute: RouteTable.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
    );
  }
}


