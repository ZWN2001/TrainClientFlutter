import 'package:get/get.dart';

class User {
  late final int userId;
  late final String userName;
  late final String role;
  late final bool gender;
  late final String email;

  User.name(this.userId,this.userName,this.role,this.gender,this.email);

  User.fromJson(jsonMap){
    userId = jsonMap['userId'] ?? 0 ;
    userName = jsonMap['userName'] ?? 'unKnown';
    role = jsonMap['role'] ?? 'unKnown';
    gender = jsonMap['gender'] ?? 'unKnown';
    email = jsonMap['email'] ?? 'unKnown';
  }
}

class OrderGeneral {
  late final String orderId;
  late final String trainRouteId;
  late final String fromStationId;
  late final String toStationId;
  late final String departureDate;
  late final String orderStatus;

  OrderGeneral.fromJson(jsonMap) {
    orderId = jsonMap['orderId'] ?? 'unKnown';
    trainRouteId = jsonMap['trainRouteId'] ?? 'unKnown';
    fromStationId = jsonMap['fromStationId'] ?? 'unKnown';
    toStationId = jsonMap['toStationId'] ?? 'unKnown';
    departureDate = jsonMap['departureDate'] ?? 'unKnown';
    orderStatus = jsonMap['orderStatus'] ?? 'unKnown';
  }
}

class Passenger {
  late final int userId;
  late final String passengerId;
  late final String passengerName;
  late final String phoneNum;
  late final String role;

  Passenger.fromJson(jsonMap) {
    userId = jsonMap['userId'] ?? 0;
    passengerId = jsonMap['passengerId'] ?? 'unKnown';
    passengerName = jsonMap['passengerName'] ?? 'unKnown';
    phoneNum = jsonMap['phoneNum'] ?? 'unKnown';
    role = jsonMap['role'] ?? 'unKnown';
  }
}

///待支付的乘员信息
class PassengerToPay {
  late final String passengerId;
  late final String passengerName;
  late final String role;
  late final double price;

  PassengerToPay.fromJson(jsonMap) {
    passengerId = jsonMap['passengerId'] ?? 'unKnown';
    passengerName = jsonMap['passengerName'] ?? 'unKnown';
    role = jsonMap['role'] ?? 'unKnown';
    price = jsonMap['price'] ?? 0.0;
  }

}

//模版类仅用来标识
class ResultEntity<T> {
  late final bool result;
  late final int code;
  late final  String message;
  late final T data;

  ResultEntity.name(this.result, this.code, this.message, this.data);

  ResultEntity.success(dynamic data){
    result = true;
    code = 200;
    message = "success";
    data = data;
  }

  ResultEntity.error(String msg, {int? code, dynamic data}){
    result = false;
    code = code ?? 500;
    message = msg;
    data = data ?? '';
  }

}