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

@JsonSerializable()
class Order {
  late final  String orderId;
  late String userId;
  late final  String passengerId;
  late final  String departureDate;
  late final  String trainRouteId;
  late final  String fromStationId;
  late final  String toStationId;
  late final  int    seatTypeId;
  late final  String orderStatus;
  late final  String orderTime;
  late final  double price;
  late final  String tradeNo;

  Order.name();

  Order.fromJson(jsonMap){
    orderId = jsonMap['orderId'] ?? 'unKnown';
    passengerId = jsonMap['passengerId'] ?? 'unKnown';
    departureDate = jsonMap['departureDate'] ?? 'unKnown';
    trainRouteId = jsonMap['trainRouteId'] ?? 'unKnown';
    fromStationId = jsonMap['fromStationId'] ?? 'unKnown';
    toStationId = jsonMap['toStationId'] ?? 'unKnown';
    seatTypeId = jsonMap['seatTypeId'] ?? 1;
    orderStatus = jsonMap['orderStatus'] ?? 'unKnown';
    orderTime = jsonMap['orderTime'] ?? DateTime.now().toString();
    price = jsonMap['price'] ?? 0.0;
    tradeNo = jsonMap['tradeNo'] ?? '无';
  }

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
    'orderId': instance.orderId,
    'userId': instance.userId,
    'passengerId': instance.passengerId,
    'departureDate': instance.departureDate,
    'trainRouteId': instance.trainRouteId,
    'fromStationId': instance.fromStationId,
    'toStationId': instance.toStationId,
    'seatTypeId': instance.seatTypeId,
    'orderStatus': instance.orderStatus,
    'orderTime': instance.orderTime,
    'price': instance.price,
    'tradeNo': instance.tradeNo,
  };
}

@JsonSerializable()
class RebookOrder {
  late final String orderId;
  late int userId;
  late final String passengerId;
  late final String departureDate;
  late final String trainRouteId;
  late final String fromStationId;
  late final String toStationId;
  late final int seatTypeId;
  late final int seatBooking;
  late final double originalPrice;
  late final double price;
  late final String createTime;

  RebookOrder.name();

  RebookOrder.fromJson(jsonMap){
    orderId = jsonMap['orderId'] ?? 'unKnown';
    passengerId = jsonMap['passengerId'] ?? 'unKnown';
    departureDate = jsonMap['departureDate'] ?? 'unKnown';
    trainRouteId = jsonMap['trainRouteId'] ?? 'unKnown';
    fromStationId = jsonMap['fromStationId'] ?? 'unKnown';
    toStationId = jsonMap['toStationId'] ?? 'unKnown';
    seatTypeId = jsonMap['seatTypeId'] ?? 1;
    seatBooking = jsonMap['seatBooking'] ?? 1;
    originalPrice = jsonMap['originalPrice'] ?? 0;
    price = jsonMap['price'] ?? 0.0;
    createTime = jsonMap['createTime'] ?? DateTime.now();
  }

  Map<String, dynamic> toJson() => _$RebookOrderToJson(this);

  Map<String, dynamic> _$RebookOrderToJson(RebookOrder instance) => <String, dynamic>{
    'orderId': instance.orderId,
    'userId': instance.userId,
    'passengerId': instance.passengerId,
    'departureDate': instance.departureDate,
    'trainRouteId': instance.trainRouteId,
    'fromStationId': instance.fromStationId,
    'toStationId': instance.toStationId,
    'seatTypeId': instance.seatTypeId,
    'seatBooking': instance.seatBooking,
    'originalPrice': instance.originalPrice,
    'price': instance.price,
    'createTime': instance.createTime,
  };
}

class OrderGeneral {
  late final String orderId;
  late final String trainRouteId;
  late final String fromStationId;
  late final String toStationId;
  late final String departureDate;
  late final String orderStatus;
  late final String passengerId;
  ///0为直达，1为中转第一程，2为第二程
  late int routeNo = 0;

  OrderGeneral.fromJson(jsonMap) {
    orderId = jsonMap['orderId'] ?? 'unKnown';
    trainRouteId = jsonMap['trainRouteId'] ?? 'unKnown';
    fromStationId = jsonMap['fromStationId'] ?? 'unKnown';
    toStationId = jsonMap['toStationId'] ?? 'unKnown';
    departureDate = jsonMap['departureDate'] ?? 'unKnown';
    orderStatus = jsonMap['orderStatus'] ?? 'unKnown';
    passengerId = jsonMap['passengerId'] ?? 'unKnown';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderGeneral &&
          runtimeType == other.runtimeType &&
          orderId == other.orderId &&
          passengerId == other.passengerId;

  @override
  int get hashCode => orderId.hashCode ^ passengerId.hashCode;
}

class OrderStatus {
  static const String UN_PAY = "未支付";
  static const String CANCEL = "已取消";
  static const String TIMEOUT = "支付超时";
  static const String PAIED = "已支付";
  static const String REFUNDED = "已退票";
  static const String REBOOK = "已改签";
  static const String TO_REBOOK = "待改签";
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
    role = jsonMap['prole'] ?? 'unKnown';
  }

  Passenger();

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'passengerId': passengerId,
      'passengerName': passengerName,
      'phoneNum': phoneNum,
      'prole': role,
    };
  }
}

///待支付的乘员信息
class PassengerToPay {
  late final String passengerId;
  late final String passengerName;
  late final String role;
  late int seatTypeId;
  late double price;

  PassengerToPay.fromJson(jsonMap) {
    passengerId = jsonMap['passengerId'] ?? 'unKnown';
    passengerName = jsonMap['passengerName'] ?? 'unKnown';
    role = jsonMap['prole'] ?? 'unKnown';
    seatTypeId = jsonMap['seatTypeId'] ?? 1;
    price = jsonMap['price'] ?? 0.0;
  }

}

///改签待支付的乘员信息
class PassengerRebookToPay {
  late final String passengerId;
  late final String passengerName;
  late final String role;
  late int seatTypeId;
  late double originalPrice;
  late double price;

  PassengerRebookToPay.fromPassengerToPay(PassengerToPay passengerToPay) {
    passengerId = passengerToPay.passengerId;
    passengerName = passengerToPay.passengerName;
    role = passengerToPay.role;
    seatTypeId = passengerToPay.seatTypeId;
    price = passengerToPay.price;
    originalPrice = 0;
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
    abbr = PinyinHelper.getPinyin(jsonMap['stationName'] ?? 'unKnown');
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

class SeatType {
  late final String seatTypeId;
  late final String seatTypeName;

  SeatType.fromJson(jsonMap){
    seatTypeId = jsonMap['seatTypeId'] ?? '1';
    seatTypeName = jsonMap['seatTypeName'] ?? 'unKnown';
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

class MyRoute{}

class TrainRoute extends MyRoute{
  late final String trainRouteId;
  late final String fromStationId;
  late final String toStationId;
  late final bool formIsStart;
  late final bool toIsEnd;
  late final String startTime;
  late final String arriveTime;
  late String durationInfo;
  late int duratoinInt;
  late Map<int,int> tickets;

  TrainRoute();

  TrainRoute.fromJson(jsonMap){
    trainRouteId = jsonMap['trainRouteId'] ?? 'unKnown';
    fromStationId = jsonMap['fromStationId'] ?? 'unKnown';
    toStationId = jsonMap['toStationId'] ?? 'unKnown';
    formIsStart = jsonMap['formIsStart'] ?? true;
    toIsEnd = jsonMap['toIsEnd'] ?? true;
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
    String time = jsonMap['durationInfo'] ?? 'unKnown';
    if(time != 'unKnown'){
      List<String> list = time.split(":");
      if(list.length == 2){
        durationInfo = "${list[0]}小时${list[1]}分钟";
        duratoinInt = int.parse(list[0]) * 60 + int.parse(list[1]);
      }else if(list.length == 3){
        durationInfo = "${list[0]}天${list[1]}小时${list[2]}分钟";
        duratoinInt = int.parse(list[0]) * 60 * 24 + int.parse(list[1]) * 60 + int.parse(list[2]);
      }
    }
    Map<String, dynamic> map = jsonMap['tickets'] ?? {};
    tickets = {};
    map.forEach((key, value) {
      int keyInt = int.parse(key);
      tickets[keyInt] = value;
    });
  }

  @override
  String toString() {
    return 'TrainRoute{trainRouteId: $trainRouteId, fromStationId: $fromStationId, toStationId: $toStationId, formIsStart: $formIsStart, toIsEnd: $toIsEnd}';
  }
}

class TrainRouteTransfer extends MyRoute{
  late final String trainRouteId1;
  late final String trainRouteId2;
  late final String fromStationId;
  late final String transStationId;
  late final String toStationId;
  //始发站发车时间
  late final String startTimeFrom;
  //换乘站到达时间
  late final String arriveTimeTrans;
  //换乘站发车时间
  late final String startTimeTrans;
  //目的站到达时间
  late final String arriveTimeTo;
  late final int durationAll;
  late final int durationTransfer;
  late final Map<int, int> ticketsFirst;
  late final Map<int, int> ticketsNext;

  TrainRouteTransfer();

  TrainRouteTransfer.fromJson(jsonMap){
    trainRouteId1 = jsonMap['trainRouteId1'] ?? 'u';
    trainRouteId2 = jsonMap['trainRouteId2'] ?? 'u';
    fromStationId = jsonMap['fromStationId'] ?? 'u';
    transStationId = jsonMap['transStationId'] ?? 'u';
    toStationId = jsonMap['toStationId'] ?? 'u';

    String startTimeFromInfo = jsonMap['startTimeFrom'] ?? 'u';
    if(startTimeFromInfo != 'u'){
      startTimeFromInfo = startTimeFromInfo.substring(0,5);
    }
    startTimeFrom = startTimeFromInfo;

    String arriveTimeTransInfo = jsonMap['arriveTimeTrans'] ?? 'u';
    if(arriveTimeTransInfo != 'u'){
      arriveTimeTransInfo = arriveTimeTransInfo.substring(0,5);
    }
    arriveTimeTrans = arriveTimeTransInfo;

    String startTimeTransInfo = jsonMap['startTimeTrans'] ?? 'u';
    if(startTimeTransInfo != 'u'){
      startTimeTransInfo = startTimeTransInfo.substring(0,5);
    }
    startTimeTrans = startTimeTransInfo;

    String arriveTimeToInfo = jsonMap['arriveTimeTo'] ?? 'u';
    if(arriveTimeToInfo != 'u'){
      arriveTimeToInfo = arriveTimeToInfo.substring(0,5);
    }
    arriveTimeTo = arriveTimeToInfo;

    durationTransfer = jsonMap['durationTransfer'] ?? 0;
    // durationAll = jsonMap['durationAll'] ?? 0;

    Map<String, dynamic> map1 = jsonMap['ticketsFirst'] ?? {};
    ticketsFirst = {};
    map1.forEach((key, value) {
      int keyInt = int.parse(key);
      ticketsFirst[keyInt] = value;
    });

    Map<String, dynamic> map2 = jsonMap['ticketsNext'] ?? {};
    ticketsNext = {};
    map2.forEach((key, value) {
      int keyInt = int.parse(key);
      ticketsNext[keyInt] = value;
    });
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

class TicketPrice {
  late final int seatTypeId;
  late final double price;

  TicketPrice.fromJson(jsonMap){
    seatTypeId = jsonMap['seatTypeId'] ?? 'unKnown';
    price = jsonMap['price'] ?? 0.0;
  }

}

class SeatInfo{
  late int carriageId;
  late int seat;

  SeatInfo.fromJson(jsonMap){
    carriageId = jsonMap['carriageId'] ?? 0;
    seat = jsonMap['seat'] ?? 0;
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

  @override
  String toString() {
    return 'ResultEntity{result: $result, code: $code, message: $message, data: $data}';
  }
}

