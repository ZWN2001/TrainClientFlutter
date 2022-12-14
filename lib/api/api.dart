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
        Options? options ,
        bool refresh = false,
        String cacheKey = '',
        bool cacheDisk = false,
        bool needRetry = false,
      }) async {
    Options requestOptions;
    if(options != null){
      requestOptions = options;
    }else{
      requestOptions = Options();
    }
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
  // static const String baseHost = "http://10.0.2.2:8081";
  static const String baseHost = "http://192.168.0.5:8081";
  static const String query = "/query";
  static const String command = "/command";
  static const String hostPay = "/alipay";
  static const String hostPassenger = "/passenger";
  static const String hostTicket = "/ticket";
  static const String hostUser = "/user";
  static const String hostTrainRoute = "/trainRoute";
  static const String hostStation = "/station";
  static const String hostSeatType = "/seatType";
}

class UserApi{
  static const String _urlPostRegister = "${Server.hostUser}/register";
  static const String _urlPostLogin = "${Server.hostUser}/login";
  static const String _urlPostLogout = "${Server.hostUser}/logout";
  // static const String _urlPostRefresh = "${Server.hostUser}/refresh";
  static const String _urlGetUserInfo = "${Server.hostUser}/getUserInfo";

  static bool get isLogin => _curUser != null;


  static User? _curUser;

  static User? get curUser => _curUser;

  static String? getToken(){
    String? token =  Store.getString('token');
    return token;
  }

  static int? getUserId(){
    String? s = Store.getString('user_userId');
    return int.parse(s);
  }

  static Future<ResultEntity> login(String userId, String pwd) async {
    String token;
    try{
      Response response = await Http.post(_urlPostLogin, data: FormData.fromMap(
          {'userId': userId, 'loginKey': pwd}));
      Map<String, dynamic> data = response.data;
      if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }else{
          token = data['data'];
          await _getUserInformationAndStore(token);
          return ResultEntity.name( true, 0, "????????????",null);
        }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????',null);
    }
  }

  static Future<ResultEntity> register(User user) async {
    try{
      Response response = await Http.post(_urlPostRegister, data: FormData.fromMap(
          {'userId': user.userId, 'password':user.pwd}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????',null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????',null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'],null);
        }
        return ResultEntity.name( true, 0, "????????????",null);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????',null);
    }
  }

  static Future<ResultEntity> logout() async {
    try{
      Response response = await Http.post(_urlPostLogout, data: FormData.fromMap(
          {'token': getToken()}),
          options: Options(headers: {'Token': 'Bearer:${getToken()}'}));
      Map<String, dynamic> data = response.data;
      if(data['code'] != 200){
        return ResultEntity.name(false, data['code'], data['message'], null);
      }else{
        _deleteUserInfo();
        return ResultEntity.name(true, 0, "??????", null);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '??????', null);
    }
  }

  static void _deleteUserInfo(){
    Store.remove('token');
    Store.remove('user_userId');
    Store.remove('user_userName');
    Store.remove('user_role');
    Store.remove('user_gender');
    Store.remove('user_email');
    _curUser = null;
  }

  static Future _getUserInformationAndStore(String token) async {
    Map<String, dynamic> info = await _getUserInfo(token);
    try {
      _storeUserLoginCache(User.fromJson(info), token);
    } catch (e) {debugPrint(e.toString());}
  }

  static Future<Map<String, dynamic>> _getUserInfo(String token) async {
    try {
      Response response = await Http.get(_urlGetUserInfo,
          options: Options(headers: {'Token': 'Bearer:$token'}));
      Map<String, dynamic> data = response.data;
      if (data['code'] != 200) {
        return {};
      } else {
        return data['data'];
      }
    } catch (e) {
      debugPrint(e.toString());
      return {};
    }
  }

  /// ????????????????????????
  static void _storeUserLoginCache(User userInfo,
      [String? token]) {
    if (token != null) {
      Store.set('token', token);
    }
    Store.set('user_userId', userInfo.userId!);
    Store.set('user_userName', userInfo.userName ?? 'unKnown');
    Store.set('user_role', userInfo.role!);
    Store.set('user_gender', userInfo.gender ?? false);
    Store.set('user_email', userInfo.email ?? 'unKnown');
    _curUser = userInfo;
  }

  static void initUserFromCache() {
    if (Store.get('token') != '') {
      User user = User.name(
          userId: Store.getString('user_userId'),
          userName: Store.getString('user_userName'),
          role: Store.getString('user_role'),
          gender: Store.getBool('user_gender'),
          email: Store.getString('user_email')
      );
      _curUser = user;
    }
  }
}

class PayApi{
  static const String _urlGetPay = "${Server.hostPay}/pay";
  static const String _urlGetPayRebook = "${Server.hostPay}/payRebook";
  static const String _urlGetOrderPayStatus = "${Server.hostTicket}${Server.query}/orderPayStatus";
  static const String _urlGetOrderRebookStatus = "${Server.hostTicket}${Server.query}/orderRebookStatus";

  static Future<ResultEntity> ticketPay(String orderId, List<String> passengerId, int payMethod) async {
    try{
      Response response = await Http.get(_urlGetPay,
          params: {'orderId' : orderId, 'passengerIdString' : passengerId.toString(),
          'payMethod' : payMethod},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        // PayResult result = PayResult.fromJson(data['data']);
        return ResultEntity.name( true, 0, "??????", data['data']);
      }
    }catch(e){
      debugPrint(e.toString());
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> ticketPayRebook(String orderId) async {
    try{
      Response response = await Http.get(_urlGetPayRebook,
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        return ResultEntity.name( true, 0, "??????", data['data']);
      }
    }catch(e){
      debugPrint(e.toString());
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> getOrderPayStatus(String orderId) async {
    try{
      Response response = await Http.get(_urlGetOrderPayStatus,
          params: {'orderId' : orderId,},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        return ResultEntity.name( true, 0, "??????", data['data']);
      }
    }catch(e){
      debugPrint(e.toString());
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> getOrderRebookStatus(String orderId) async {
    try{
      Response response = await Http.get(_urlGetOrderRebookStatus,
          params: {'orderId' : orderId,},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        return ResultEntity.name( true, 0, "??????", data['data']);
      }
    }catch(e){
      debugPrint(e.toString());
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

}

class DataApi{
  static const String _urlGetAllStationDetail = "${Server.hostStation}${Server.query}/allStationDetail";
  static const String _urlGetAllSeatType = "${Server.hostSeatType}${Server.query}/allSeatType";

  static Future<List<SeatType>> getAllSeatMap() async {
    try{
      Response response = await Http.get(_urlGetAllSeatType);
      Map<String, dynamic> data = response.data;
      if(data['code'] != 200){
        return [];
      }else{
        List list = data['data'];
        return list.map((e) => SeatType.fromJson(e)).toList();
      }
    }catch(e){
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<List<Station>> getAllStationList() async {
    try{
      Response response = await Http.get(_urlGetAllStationDetail);
      Map<String, dynamic> data = response.data;
      if(data['code'] != 200){
        return [];
      }else{
        List list = data['data'];
        return list.map((e) => Station.fromJson(e)).toList();
      }
    }catch(e){
      debugPrint(e.toString());
      return [];
    }

  }
}

class PassengerApi{
  static const String _urlPostAdd = "${Server.hostPassenger}${Server.command}/add";
  static const String _urlPostModify = "${Server.hostPassenger}${Server.command}/modify";
  static const String _urlPostDelete = "${Server.hostPassenger}${Server.command}/delete";
  static const String _urlGetQueryAll = "${Server.hostPassenger}${Server.query}/all";
  static const String _urlGetQuerySingle = "${Server.hostPassenger}${Server.query}/single";
  static const String _urlGetRandom = "${Server.hostPassenger}${Server.command}/random";

  static Future<ResultEntity> getAllPassenger() async {
    try{
      Response response = await Http.get(_urlGetQueryAll,
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      print(response);
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        List list = data['data'];
        List<Passenger> result =  list.map((e) => Passenger.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", result);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '??????????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> getSinglePassenger(String passengerId) async {
    try{
      Response response = await Http.get(_urlGetQuerySingle,
          params: {'userId' : UserApi.getUserId(), 'passengerId' : passengerId},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        PassengerToPay p = PassengerToPay.fromJson(data['data']);
        return ResultEntity.name( true, 0, "??????", p);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '??????????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> modifyPassenger(Passenger passenger) async {
    try{
      Response response = await Http.post( _urlPostModify,
          params: {'passengerJSON' : jsonEncode(passenger)},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        return ResultEntity.name( true, 0, "????????????", null);
      }
    }catch(e){
      debugPrint(e.toString());
      return ResultEntity.name(false, -2, '??????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> addPassenger(Passenger passenger) async {
    try{
      Response response = await Http.post( _urlPostAdd,
          params: {'passengerJSON' : jsonEncode(passenger)},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        return ResultEntity.name( true, 0, "????????????", null);
      }
    }catch(e){
      debugPrint(e.toString());
      return ResultEntity.name(false, -2, '??????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> deletePassenger(Passenger passenger) async {
    try{
      Response response = await Http.post( _urlPostDelete,
          params: {'passengerJSON' : jsonEncode(passenger)},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        return ResultEntity.name( true, 0, "????????????", null);
      }
    }catch(e){
      debugPrint(e.toString());
      return ResultEntity.name(false, -2, '??????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> randomPassenger() async {
    try{
      Response response = await Http.get( _urlGetRandom,
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        return ResultEntity.name( true, 0, "??????", data['data']);
      }
    }catch(e){
      debugPrint(e.toString());
      return ResultEntity.name(false, -2, '??????,????????????????????????', null);
    }
  }
}

class TicketAndOrderApi{
  ///??????
  static const String _urlPostBooking = "${Server.hostTicket}${Server.command}/booking";
  static const String _urlPostBookingTansfer = "${Server.hostTicket}${Server.command}/bookingTansfer";
  ///??????
  static const String _urlPostRefund = "${Server.hostTicket}${Server.command}/refund";
  ///??????
  static const String _urlPostRebook = "${Server.hostTicket}${Server.command}/rebook";
  static const String _urlPostBookingCancel = "${Server.hostTicket}${Server.command}/bookingCancel";
  ///??????
  // static const String _urlGetTicketRemain = "${Server.hostTicket}${Server.query}/ticketRemain";
  ///??????
  static const String _urlGetTicketPrices = "${Server.hostTicket}${Server.query}/ticketPrices";
  static const String _urlGetSelfTicket = "${Server.hostTicket}${Server.query}/selfTicket";
  static const String _urlGetSelfOrder = "${Server.hostTicket}${Server.query}/selfOrder";
  static const String _urlGetSelfPaiedOrder = "${Server.hostTicket}${Server.query}/selfPaiedOrder";
  static const String _urlGetOrderInfo = "${Server.hostTicket}${Server.query}/orderInfo";
  static const String _urlGetTicketSeatInfo = "${Server.hostTicket}${Server.query}/ticketSeatInfo";
  static const String _urlGetTicketToPayDetail = "${Server.hostTicket}${Server.query}/ticketToPayDetail";
  static const String _urlGetOrderById = "${Server.hostTicket}${Server.query}/orderById";
  static const String _urlGetOrderToRebook = "${Server.hostTicket}${Server.query}/orderToRebook";//
  static const String _urlPostRebookCancel = "${Server.hostTicket}${Server.command}/rebookCancel";
  static Future<ResultEntity> ticketBooking(Order order,
      List<String> passengerIds, List<int> seatSelects) async {
    try{
      Response response = await Http.post(_urlPostBooking,
          params: {'orderString' : jsonEncode(order),'passengerIdsString' : passengerIds.toString(),
          'seatLocationListString':seatSelects.toString()},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        List list = data['data'];
        List<OrderGeneral> result =  list.map((e) => OrderGeneral.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", result);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> ticketRebook(RebookOrder order,
      List<String> passengerIds, List<int> seatSelects) async {
    try{
      Response response = await Http.post(_urlPostRebook,
          params: {'orderString' : jsonEncode(order),'passengerIdsString' : passengerIds.toString(),
            'seatLocationListString':seatSelects.toString()},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        // List list = data['data'];
        // List<OrderGeneral> result =  list.map((e) => OrderGeneral.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", null);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> ticketRebookCancel(String orderId) async {
    try{
      Response response = await Http.post(_urlPostRebookCancel,
          params: {'orderId' : orderId},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        return ResultEntity.name( true, 0, "??????", null);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> ticketBookingTransfer(Order order1, Order order2,
      List<String> passengerIds, List<int> seatSelects, List<int> seatSelectsNext) async {
    try{
      Response response = await Http.post(_urlPostBookingTansfer,
          params: {'orderString1' : jsonEncode(order1),
            'orderString2' : jsonEncode(order2),
            'passengerIdsString' : passengerIds.toString(),
            'seatLocationListString1':seatSelects.toString(),
            'seatLocationListString2':seatSelectsNext.toString()
          },
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        List list = data['data'];
        List<OrderGeneral> result = list.map((e) => OrderGeneral.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", result);
      }
    }catch(e){
      debugPrint(e.toString());
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> ticketBookingCancel(String departureDate,
      String trainRouteId, List<String> passengetIds) async {
    try{
      Response response = await Http.post(_urlPostBookingCancel,
          params: {'departureDate' : departureDate, 'trainRouteId': trainRouteId,
            'passengetIdString' : passengetIds.toString()},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        return ResultEntity.name( true, 0, "??????", null);
      }
    }catch(e){
      debugPrint(e.toString());
      return ResultEntity.name(false, -2, '??????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> ticketRefund(String orderId) async {
    try{
      Response response = await Http.post(_urlPostRefund,
          params: {'orderId' : orderId},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        return ResultEntity.name( true, 0, "??????", null);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> getOrderPaied() async {
    try{
      Response response = await Http.get(_urlGetSelfPaiedOrder,
          params: {'userId' : UserApi.getUserId()},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        List list = data['data'];
        List<OrderGeneral> result =  list.map((e) => OrderGeneral.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", result);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> getOrderAll() async {
    try{
      Response response = await Http.get(_urlGetSelfOrder,
          params: {'userId' : UserApi.getUserId()},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        List list = data['data'];
        List<OrderGeneral> result =  list.map((e) => OrderGeneral.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", result);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> getMyTicket() async {
    try{
      Response response = await Http.get(_urlGetSelfTicket,
          params: {'userId' : UserApi.getUserId()},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        List list = data['data'];
        List<OrderGeneral> result =  list.map((e) => OrderGeneral.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", result);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> getTicketToPayDetail() async {
    try{
      Response response = await Http.get(_urlGetTicketToPayDetail,
          params: {'userId' : UserApi.getUserId()},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        List list = data['data'];
        List<Order> result =  list.map((e) => Order.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", result);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> getOrderInfo(String orderId,String? passengerId) async {
    try{
      Response response = await Http.get(_urlGetOrderInfo,
          params: {'userId' : UserApi.getUserId(), 'orderId' : orderId,
            'passengerId' : passengerId},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        List list = data['data'];
        List<Order> result =  list.map((e) => Order.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", result);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> getTicketPrices(String trainRouteId,
      String fromStationId, String toStationId) async {
    try{
      Response response = await Http.get(_urlGetTicketPrices,
          params: {'trainRouteId' : trainRouteId, 'fromStationId': fromStationId,
          'toStationId' : toStationId},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        List list = data['data'];
        List<TicketPrice> result =  list.map((e) => TicketPrice.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", result);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> getOrderById(String orderId) async {
    try{
      Response response = await Http.get(_urlGetOrderById,
          params: {'userId' : UserApi.getUserId(), 'orderId' : orderId},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        List list = data['data'];
        List<Order> result =  list.map((e) => Order.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", result);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> getOrderToRebook() async {
    try{
      Response response = await Http.get(_urlGetOrderToRebook,
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        List list = data['data'];
        List<RebookOrder> result =  list.map((e) => RebookOrder.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", result);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }

  static Future<ResultEntity> getTicketSeatInfo(String orderId,List<String> pids) async {
    try{
      Response response = await Http.get(_urlGetTicketSeatInfo,
          params: {'orderId' : orderId, 'passengerIds' : pids.toString()},
          options: Options(headers: {'Token': 'Bearer:${UserApi.getToken()}'}));
      Map<String, dynamic> data = response.data;
      if (response.statusCode != 200) {
        if (response.statusCode! >= 500) {
          return ResultEntity.name(false, response.statusCode!, '???????????????', null);
        } else {
          return ResultEntity.name(false,  response.statusCode!,  '??????,???????????????', null);
        }
      }else{
        if(data['code'] != 200){
          return ResultEntity.name(false, data['code'], data['message'], null);
        }
        List list = data['data'];
        List<SeatInfo> result =  list.map((e) => SeatInfo.fromJson(e)).toList();
        return ResultEntity.name( true, 0, "??????", result);
      }
    }catch(e){
      return ResultEntity.name(false, -2, '????????????,????????????????????????', null);
    }
  }
}

class TrainRouteApi{
  static const String _urlGetQueryTrainRoute = "${Server.hostTrainRoute}${Server.query}/trainRoute";
  static const String _urlGetQueryTrainRouteTransfer = "${Server.hostTrainRoute}${Server.query}/trainRouteTransfer";
  static const String _urlGetQueryTrainRouteDetail = "${Server.hostTrainRoute}${Server.query}/trainRouteDetail";
  static const String _urlGetQueryTicketRouteTimeInfo = "${Server.hostTrainRoute}${Server.query}/ticketRouteTimeInfo";

  static Future<ResultEntity> getTrainRoute(String from, String to, String date) async {
    try {
      Response response = await Http.get(_urlGetQueryTrainRoute,
          params: {'from' : from, 'to' : to, 'date' : date});
      Map<String, dynamic> data = response.data;
      if (data['code'] != 200) {
        return ResultEntity.name(false, data['code'], data['message'], null);
      } else {
        List list = data['data'];
        List<TrainRoute> result = list.map((e) => TrainRoute.fromJson(e)).toList();
        return ResultEntity.name(true, data['code'], data['message'], result);
      }
    } catch (e) {
      debugPrint(e.toString());
      return ResultEntity.name(false, -1, '', null);
    }
  }

  static Future<ResultEntity> getTrainRouteTransfer(String from, String to, String date) async {
    try {
      Response response = await Http.get(_urlGetQueryTrainRouteTransfer,
          params: {'from' : from, 'to' : to, 'date' : date});
      Map<String, dynamic> data = response.data;
      if (data['code'] != 200) {
        return ResultEntity.name(false, data['code'], data['message'], null);
      } else {
        List list = data['data'];
        List<TrainRouteTransfer> result = list.map((e) => TrainRouteTransfer.fromJson(e)).toList();
        return ResultEntity.name(true, data['code'], data['message'], result);
      }
    } catch (e) {
      debugPrint(e.toString());
      return ResultEntity.name(false, -1, '', null);
    }
  }

  static Future<ResultEntity> getTrainRouteDetail(String trainRouteId) async {
    try {
      Response response = await Http.get(_urlGetQueryTrainRouteDetail,
          params: {'trainRouteId' : trainRouteId});
      Map<String, dynamic> data = response.data;
      if (data['code'] != 200) {
        return ResultEntity.name(false, data['code'], data['message'], null);
      } else {
        List list = data['data'];
        List<TrainRouteAtom> result = list.map((e) => TrainRouteAtom.fromJson(e)).toList();
        return ResultEntity.name(true, data['code'], data['message'], result);
      }
    } catch (e) {
      debugPrint(e.toString());
      return ResultEntity.name(false, -1, '', null);
    }
  }

  static Future<ResultEntity> getTrainRouteTimeInfo(String trainRouteId, String fromStationId, String toStationId) async {
    try {
      Response response = await Http.get(_urlGetQueryTicketRouteTimeInfo,
          params: {'trainRouteId' : trainRouteId, 'fromStationId' : fromStationId,
          'toStationId' : toStationId});
      Map<String, dynamic> data = response.data;
      if (data['code'] != 200) {
        return ResultEntity.name(false, data['code'], data['message'], null);
      } else {
        TicketRouteTimeInfo info = TicketRouteTimeInfo.fromJson(data['data']);
        return ResultEntity.name(true, data['code'], data['message'], info);
      }
    } catch (e) {
      debugPrint(e.toString());
      return ResultEntity.name(false, -1, '', null);
    }
  }
}