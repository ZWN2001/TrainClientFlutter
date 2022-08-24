import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_client_flutter/api/api.dart';
import 'package:train_client_flutter/ui/passenger/select_passenger.dart';
import 'package:train_client_flutter/util/utils.dart';

import '../../bean/bean.dart';
import '../../constant.dart';
import '../../widget/cards.dart';

class BookingPage extends StatefulWidget{
  const BookingPage({Key? key, required this.route}) : super(key: key);
  final TrainRoute route;

  @override
  State<StatefulWidget> createState() => BookingState();
}

class BookingState extends State<BookingPage> {
  List<TicketPrice> _prices = [];
  List<Passenger> passengers = [];
  late TrainRoute _route;
  int? _selectedType ;
  bool _isLoading = true;
  int enableNumMax = 4;

  @override
  void initState() {
    super.initState();
    _route = widget.route;
    _selectedType = null;
    _getData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('确认订单'),
          centerTitle: true,
          elevation: 0,
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
        ),
        body: _isLoading ?
        const Center(child: CircularProgressIndicator())
        : Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Color.fromARGB(1, 33, 150, 243),
                  Colors.transparent
                ],
                begin: Alignment.topCenter,
                end: Alignment.center,
              )),
          child: _contentCard(),
        )
    );
  }

  Widget _contentCard(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          _routeInfoCard(),
          const SizedBox(height: 8,),
          _selectPassengerButton(),
          const SizedBox(height: 16,),
          if(passengers.isNotEmpty)
          _passengerCards()
          // Image.asset('images/orderTips.jpg')
        ],
      ),
    );
  }

  Widget _routeInfoCard(){
    double size = 26;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_route.startTime, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        _route.formIsStart ? PassStartEndIcon.stationStartIcon(size) : PassStartEndIcon.stationPassIcon(size),
                        Text(Constant.stationIdMap[_route.fromStationId]!.stationName, style: const TextStyle(fontSize: 16),)
                      ],
                    )

                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text(_route.trainRouteId, style: const TextStyle(fontSize: 18)),
                    const ImageIcon(AssetImage('icons/arrow.png'),size: 26,color: Colors.blue,),
                    Text(_route.durationInfo,style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_route.arriveTime, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        _route.toIsEnd ? PassStartEndIcon.stationEndIcon(size) : PassStartEndIcon.stationPassIcon(size),
                        Text(Constant.stationIdMap[_route.toStationId]!.stationName, style: const TextStyle(fontSize: 16),)
                      ],
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8,),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _prices.map((e) =>
                  Expanded(
                      child: _seatTypeButton(e)
                  )
              ).toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _seatTypeButton(TicketPrice ticketPrice){
    return Padding(padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
    child: ElevatedButton(
      onPressed: () {
        _selectedType = ticketPrice.seatTypeId;
        if(mounted){
          setState((){});
        }
      },
      style: ButtonStyle(
        backgroundColor: _selectedType != ticketPrice.seatTypeId?
        MaterialStateProperty.all(Colors.white70):
        MaterialStateProperty.all(const Color.fromRGBO(206, 231, 255, 0.9)),
        side: _selectedType == ticketPrice.seatTypeId?
        MaterialStateProperty.all(const BorderSide(width: 1, color: Colors.blueAccent))
            :null,
      ),
      child: SizedBox(
        height: 82,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Constant.seatIdToTypeMap[ticketPrice.seatTypeId.toString()]!,
                style: const TextStyle(fontSize: 16,color: Colors.black),),
              const SizedBox(height: 4,),
              Text('￥${ticketPrice.price}',style: const TextStyle(color: Colors.black),)
            ],
          ),
        ),
      )
    ),);
  }

  Widget _selectPassengerButton(){
    return GestureDetector(
      onTap: () async {
        List<Passenger>? addedPassengerList = await Get.to(() =>
            SelectPassengerPage(addedPassengers: passengers,));
        if(addedPassengerList != null){
          passengers.addAll(addedPassengerList);
        }
        setState((){});
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_box_rounded,color: Colors.orange),
              SizedBox(width: 6,),
              Text('选择乘员',style: TextStyle(color: Colors.orange,fontSize: 18),)
            ],
          ),
        ),
      ),
    );
  }

  Widget _passengerCards() {
    return Column(
      children: passengers.map((e) => _passengerInfo(e)).toList(),
    );
  }

  Widget _passengerInfo(Passenger passenger) {
    return Card(
        child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(passenger.passengerName,
                        style: const TextStyle(fontSize: 18),),
                      const SizedBox(width: 8,),
                      Text(passenger.role == 'common' ? '成人票' : '学生票',
                        style: const TextStyle(color: Colors.blue),)
                    ],
                  ),
                  Text(passenger.phoneNum),
                  Text(IDUtil.getObscureID(passenger.passengerId),
                    style: const TextStyle(color: Colors.grey),),
                ],
              ),
              const Expanded(child: SizedBox()),
              IconButton(
                  onPressed: () {
                    setState((){
                      passengers.remove(passenger);
                    });
                  },
                  icon: const Icon(Icons.delete_forever))

            ],
          ),
        )
    );
  }

  Future<void> _getData() async {
    ResultEntity resultEntity = await TicketAndOrderApi.getTicketPrices(
        _route.trainRouteId, _route.fromStationId, _route.toStationId);
    if(resultEntity.result){
      _prices = resultEntity.data;
    }
    setState((){
      _isLoading = false;
    });
  }

}