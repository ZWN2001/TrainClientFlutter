
import 'package:azlistview/azlistview.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lpinyin/lpinyin.dart';

class User {
  late final String? userId;
  late final String? userName;
  late final String? role;
  late final bool? gender;
  late final String? pwd;
  late final String? email;

  User.name({this.userId,this.userName,this.role,this.gender,this.pwd,this.email});

  User.fromJson(jsonMap){
    userId = jsonMap['userId'].toString() ;
    userName = jsonMap['userName'] ?? '未设置用户名';
    role = jsonMap['role'].toString();
    gender = jsonMap['gender'] ?? false;
    email = jsonMap['email'] ?? '未设置邮箱';
    pwd = jsonMap['pwd'] ?? '';
  }

  @override
  String toString() {
    return 'User{userId: $userId, userName: $userName, role: $role, gender: $gender, pwd: $pwd, email: $email}';
  }
}

class Order {
  late final  String orderId;
  late final  String passengerId;
  late final  String departureDate;
  late final  String trainRouteId;
  late final  String fromStationId;
  late final  String toStationId;
  late final  int seatTypeId;
  late final  String orderTime;
  late final  double price;
  late final  String tradeNo;

  Order.fromJson(jsonMap){
    orderId = jsonMap['orderId'] ?? 'unKnown';
    passengerId = jsonMap['passengerId'] ?? 'unKnown';
    departureDate = jsonMap['departureDate'] ?? 'unKnown';
    trainRouteId = jsonMap['trainRouteId'] ?? 'unKnown';
    fromStationId = jsonMap['fromStationId'] ?? 'unKnown';
    toStationId = jsonMap['toStationId'] ?? 'unKnown';
    seatTypeId = jsonMap['seatTypeId'] ?? 0;
    orderTime = jsonMap['orderTime'] ?? DateTime.now().toString();
    price = jsonMap['price'] ?? 0.0;
    tradeNo = jsonMap['tradeNo'] ?? 'unKnown';
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

class OrderStatus {
  static const String UN_PAY = "未支付";
  static const String CANCEL = "已取消";
  static const String TIMEOUT = "支付超时";
  static const String PAIED = "已支付";
  static const String REFUNDED = "已退票";
  static const String DRAFTED = "已出票";
}

class Passenger {
  late final int userId;
  late String passengerId;
  late String passengerName;
  late String phoneNum;
  late String role;

  Passenger.fromJson(jsonMap) {
    userId = jsonMap['userId'] ?? 0;
    passengerId = jsonMap['passengerId'] ?? 'unKnown';
    passengerName = jsonMap['passengerName'] ?? 'unKnown';
    phoneNum = jsonMap['phoneNum'] ?? 'unKnown';
    role = jsonMap['role'] ?? 'unKnown';
  }

  Passenger();

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'passengerId': passengerId,
      'passengerName': passengerName,
      'phoneNum': phoneNum,
      'role': role,
    };
  }
}

///待支付的乘员信息
class PassengerToPay {
  late final String passengerId;
  late final String passengerName;
  late final String role;
  late double price;

  PassengerToPay.fromJson(jsonMap) {
    passengerId = jsonMap['passengerId'] ?? 'unKnown';
    passengerName = jsonMap['passengerName'] ?? 'unKnown';
    role = jsonMap['role'] ?? 'unKnown';
    price = jsonMap['price'] ?? 0.0;
  }

}

@JsonSerializable()
class Station  extends ISuspensionBean{
  late final String stationId;
  late final String stationName;
  late final String city;
  late String tagIndex;
  late String abbr;

  Station.fromJson(jsonMap){
    stationId = jsonMap['stationId'] ?? 'unKnown';
    stationName = jsonMap['stationName'] ?? 'unKnown';
    city = jsonMap['city'] ?? 'unKnown';
    tagIndex = PinyinHelper.getFirstWordPinyin(jsonMap['stationName'] ?? 'unKnown').substring(0,1).toUpperCase();
    abbr = PinyinHelper.getShortPinyin(jsonMap['stationName'] ?? 'unKnown');
  }

  Station.name({required this.stationName});


  Map<String, dynamic> toJson() => _$StationToJson(this);

  Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
    'stationId': instance.stationId,
    'stationName': instance.stationName,
    'city': instance.city,
    'tagIndex': instance.tagIndex,
  };

  @override
  String getSuspensionTag() {
    if(tagIndex == ''){
      tagIndex = PinyinHelper.getFirstWordPinyin(stationName).substring(0,1).toUpperCase();
    }
    return tagIndex;
  }
}

class TrainRouteAtom {
  late final String stationId;
  late final String stationName;
  late final int stationNo;
  late final String arriveTime;
  late final String startTime;
  late final int  stopoverTime;
  int duration = 0;

  TrainRouteAtom.fromJson(jsonMap){
    stationId = jsonMap['stationId'] ?? 'unKnown';
    stationName = jsonMap['stationName'] ?? 'unKnown';
    stationNo = jsonMap['stationNo'] ?? 0.0;
    arriveTime = jsonMap['arriveTime'] ?? 'unKnown';
    startTime = jsonMap['startTime'] ?? 'unKnown';
    stopoverTime = jsonMap['stopoverTime'] ?? 0.0;
  }

}

class TicketRouteTimeInfo {
  late final String startTime;
  late final String arriveTime;
  late String durationInfo;

  TicketRouteTimeInfo.fromJson(jsonMap){
    String startTimeInfo = jsonMap['startTime'] ?? 'unKnown';
    if(startTimeInfo != 'unKnown'){
      startTimeInfo = startTimeInfo.substring(0,5);
    }
    startTime = startTimeInfo;
    String arriveTimeInfo = jsonMap['arriveTime'] ?? 'unKnown';
    if(arriveTimeInfo != 'unKnown'){
      arriveTimeInfo = arriveTimeInfo.substring(0,5);
    }
    arriveTime = arriveTimeInfo;
    durationInfo = jsonMap['durationInfo'] ?? 'unKnown';
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

