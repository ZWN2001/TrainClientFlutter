class PassengerToPay {
  late final String passengerId;
  late final String passengerName;
  late final String role;
  late final double price;

  PassengerToPay.fromJson(jsonMap) {
    passengerId = jsonMap['passengerId'] ?? '37078220011221551X';
    passengerName = jsonMap['passengerName'] ?? '赵炜宁';
    role = jsonMap['role'] ?? 'common';
    price = jsonMap['price'] ?? 98.0;
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
    orderId = jsonMap['orderId'] ?? '0';
    trainRouteId = jsonMap['trainRouteId'] ?? '0';
    fromStationId = jsonMap['fromStationId'] ?? '0';
    toStationId = jsonMap['toStationId'] ?? '0';
    departureDate = jsonMap['departureDate'] ?? '0';
    orderStatus = jsonMap['orderStatus'] ?? '';
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
    passengerId = jsonMap['passengerId'] ?? '37078220011221551X';
    passengerName = jsonMap['passengerName'] ?? '赵炜宁';
    phoneNum = jsonMap['phoneNum'] ?? '15866554038';
    role = jsonMap['role'] ?? 'common';
  }
}