import 'package:dio/dio.dart';

class Http{
  static final Dio _dio = Dio();
  static Dio get dio => _dio;

  static void init({
    required String baseUrl,
    int connectTimeout = 15000,
    int receiveTimeout = 15000,
  }) {
    _dio.options = _dio.options.copyWith(
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
    response = await _dio.get<T>(
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
    var response = await _dio.post<T>(
      path,
      data: data,
      queryParameters: params,
      options: requestOptions,
    );
    return response;
  }
}

class Service{
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
  String urlostRegister = "${Service.hostUser}/register";
  String urlPostLogin = "${Service.hostUser}/login";
  String urlPostLogout = "${Service.hostUser}/logout";
  String urlPostRefresh = "${Service.hostUser}/refresh";
}

class PayApi{
  String urlGetPay = "${Service.hostPay}/pay";
}

class DataApi{
  String urlGetAllStationDetail = "${Service.hostStation}${Service.query}/allStationDetail";
  String urlGetAllSeatType = "${Service.hostSeatType}${Service.query}/allSeatType";
}

class PassengerApi{
  String urlPostAdd = "${Service.hostPassenger}${Service.command}/add";
  String urlPostModify = "${Service.hostPassenger}${Service.command}/modify";
  String urlPostDelete = "${Service.hostPassenger}${Service.command}/delete";
  String urlGetQueryAll = "${Service.hostPassenger}${Service.query}/all";
  String urlGetQuerySingle = "${Service.hostPassenger}${Service.query}/single";
}

class TicketAndOrderApi{
  ///订票
  String urlPostBooking = "${Service.hostTicket}${Service.command}/booking";
  ///退票
  String urlPostRefund = "${Service.hostTicket}${Service.command}/refund";
  ///改签
  String urlPostRebook = "${Service.hostTicket}${Service.command}/rebook";
  ///取票
  String urlPostGet = "${Service.hostTicket}${Service.command}/booking";
  ///余票
  String urlGetTicketRemain = "${Service.hostTicket}${Service.query}/ticketRemain";
  ///票价
  String urlGetTicketPrice = "${Service.hostTicket}${Service.query}/ticketPrice";
  String urlGetSelfTicket = "${Service.hostTicket}${Service.query}/selfTicket";
  String urlGetSelfOrder = "${Service.hostTicket}${Service.query}/selfOrder";
  String urlGetTicketInfo = "${Service.hostTicket}${Service.query}/ticketInfo";
  String urlGetTicketSeatInfo = "${Service.hostTicket}${Service.query}/ticketSeatInfo";
}

class TrainRouteApi{
  String urlGetQueryTrainRoute = "${Service.hostTrainRoute}${Service.query}/trainRoute";
  String urlGetQueryDetail = "${Service.hostTrainRoute}${Service.query}/trainRouteDetail";
}