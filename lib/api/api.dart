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

}



class PayApi{

}