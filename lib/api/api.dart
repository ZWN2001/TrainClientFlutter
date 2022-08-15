import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../bean/bean.dart';
import '../util/store.dart';

class Http{
  static Dio? _dio;
  static Dio? get dio {
    if (_dio == null) {
      BaseOptions options = BaseOptions();
      _dio = Dio(options);
    }
    return _dio;
  }

  static void init({
    required String baseUrl,
    int connectTimeout = 15000,
    int receiveTimeout = 15000,
  }) {
    dio!.options = dio!.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
  }

  static Future<Response> get<T>(
      String path, {
        Map<String, dynamic>? params,
        required Options options ,
        bool refresh = false,
        String cacheKey = '',
        bool cacheDisk = false,
        bool needRetry = false,
      }) async {
    Options requestOptions = options;
    requestOptions = requestOptions.copyWith(
      extra: {
        "refresh": refresh,
        "cacheKey": cacheKey,
        "cacheDisk": cacheDisk,
        "needRetry": needRetry,
      },
    );
    Response response;
    response = await dio!.get<T>(
      path,
      queryParameters: params,
      options: requestOptions,
    );
    return response;
  }

  static Future<Response<T>> post<T>(
      String path, {
        data,
        Map<String, dynamic>? params,
        Options? options,
      }) async {
    var response = await dio!.post<T>(
      path,
      data: data,
      queryParameters: params,
      options: options,
    );
    return response;
  }
}

class Server{
  static String baseHost = "http://10.0.2.2:8081";
  static String query = "/query";
  static String command = "/command";
  static String hostPay = "/alipay";
  static String hostPassenger = "/passenger";
  static String hostTicket = "/ticket";
  static String hostUser = "/user";
  static String hostTrainRoute = "/trainRoute";
  static String hostStation = "/station";
  static String hostSeatType = "/seatType";
}

class UserApi{
  static String urlPostRegister = "${Server.hostUser}/register";
  static String urlPostLogin = "${Server.hostUser}/login";
  static String urlPostLogout = "${Server.hostUser}/logout";
  static String urlPostRefresh = "${Server.hostUser}/refresh";
  static String urlGetUserInfo = "${Server.hostUser}/getUserInfo";

  static bool get isLogin => _curUser == null;


  static User? _curUser;

  static User? get curUser => _curUser;

  static Future<ResultEntity> login(String userId, String pwd) async {
    String token;
    try{
      Response response = await Http.post(urlPostLogin, data: FormData.fromMap(
          {'userId': userId, 'loginKey': pwd}));
      Map<String, dynamic> data = json.decode(response.data);
      if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }else{
          token = data['data'];
          await _getUserInformationAndStore(token);
          return ResultEntity.name( true, 0, "登录成功",null);
        }
    }catch(e){
      return ResultEntity.name(false, -2, '登录失败',null);
    }
  }

  static Future<ResultEntity> register(User user) async {
    try{
      Response response = await Http.post(urlPostRegister, data: FormData.fromMap(
          {'userId': user.userId, 'password':user.pwd}));
      Map<String, dynamic> data = json.decode(response.data);
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '服务器异常',null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '失败,请稍后重试',null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'],null);
        }
        return ResultEntity.name( true, 0, "注册成功",null);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '注册失败,请检查网络或重试',null);
    }
  }

  static Future _getUserInformationAndStore(String token) async {
    Map<String, dynamic> info = await _getUserInfo(token);
    try {
      await _storeUserLoginCache(User.fromJson(info), token);
    } catch (e) {debugPrint(e.toString());}
  }

  static Future<Map<String, dynamic>> _getUserInfo(String token) async {
    try {
      Response response = await Http.get(urlGetUserInfo,options: Options(headers: {'Token': token}));
      if (response.data == null || response.data['code'] != 0) {
        return {};
      } else {
        return response.data['data'];
      }
    } catch (e) {
      debugPrint(e.toString());
      return {};
    }
  }

  /// 储存用户登录信息
  static Future _storeUserLoginCache(User userInfo,
      [String? token]) async {
    //使用sp存储用户role，用于在原生的桌面小组件处调用
    // SharedPreferences s = SharedPreferenceUtil.instance;
    if (token != null) {
      await Store.set('token', token);
    }
    await Store.set('user_userId', userInfo.userId!);
    await Store.set('user_userName', userInfo.userName ?? 'unKnown');
    await Store.set('user_role', userInfo.role!);
    await Store.set('user_gender', userInfo.gender ?? false);
    await Store.set('user_email', userInfo.email ?? 'unKnown');
    _curUser = userInfo;
  }


}

class PayApi{
  String urlGetPay = "${Server.hostPay}/pay";
}

class DataApi{
  String urlGetAllStationDetail = "${Server.hostStation}${Server.query}/allStationDetail";
  String urlGetAllSeatType = "${Server.hostSeatType}${Server.query}/allSeatType";
}

class PassengerApi{
  String urlPostAdd = "${Server.hostPassenger}${Server.command}/add";
  String urlPostModify = "${Server.hostPassenger}${Server.command}/modify";
  String urlPostDelete = "${Server.hostPassenger}${Server.command}/delete";
  String urlGetQueryAll = "${Server.hostPassenger}${Server.query}/all";
  String urlGetQuerySingle = "${Server.hostPassenger}${Server.query}/single";
}

class TicketAndOrderApi{
  ///订票
  String urlPostBooking = "${Server.hostTicket}${Server.command}/booking";
  ///退票
  String urlPostRefund = "${Server.hostTicket}${Server.command}/refund";
  ///改签
  String urlPostRebook = "${Server.hostTicket}${Server.command}/rebook";
  ///取票
  String urlPostGet = "${Server.hostTicket}${Server.command}/get";
  String urlPostBookingCancel = "${Server.hostTicket}${Server.command}/bookingCancel";
  ///余票
  String urlGetTicketRemain = "${Server.hostTicket}${Server.query}/ticketRemain";
  ///票价
  String urlGetTicketPrice = "${Server.hostTicket}${Server.query}/ticketPrice";
  String urlGetSelfTicket = "${Server.hostTicket}${Server.query}/selfTicket";
  String urlGetSelfOrder = "${Server.hostTicket}${Server.query}/selfOrder";
  String urlGetSelfPaiedOrder = "${Server.hostTicket}${Server.query}/selfPaiedOrder";
  String urlGetTicketInfo = "${Server.hostTicket}${Server.query}/ticketInfo";
  String urlGetTicketSeatInfo = "${Server.hostTicket}${Server.query}/ticketSeatInfo";
  String urlGetTicketToPayDetail = "${Server.hostTicket}${Server.query}/ticketToPayDetail";
}

class TrainRouteApi{
  String urlGetQueryTrainRoute = "${Server.hostTrainRoute}${Server.query}/trainRoute";
  String urlGetQueryDetail = "${Server.hostTrainRoute}${Server.query}/trainRouteDetail";
}