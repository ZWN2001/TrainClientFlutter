import 'package:dio/dio.dart';

class Http{
  static  Dio? _dio;
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
        required Map<String, dynamic> params,
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
        required Map<String, dynamic> params,
        required Options options,
      }) async {
    Options requestOptions = options;
    var response = await dio!.post<T>(
      path,
      data: data,
      queryParameters: params,
      options: requestOptions,
    );
    return response;
  }
}

class Server{
  static String baseHost = "http://localhost:8080";
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
  String urlostRegister = "${Server.hostUser}/register";
  String urlPostLogin = "${Server.hostUser}/login";
  String urlPostLogout = "${Server.hostUser}/logout";
  String urlPostRefresh = "${Server.hostUser}/refresh";
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