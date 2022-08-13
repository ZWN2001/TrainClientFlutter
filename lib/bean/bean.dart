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