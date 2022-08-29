import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:train_client_flutter/api/api.dart';
import 'package:train_client_flutter/ui/order/order_unpaied.dart';
import 'package:train_client_flutter/ui/passenger/select_passenger.dart';
import 'package:train_client_flutter/util/utils.dart';

import '../../bean/bean.dart';
import '../../constant.dart';
import '../../util/date_util.dart';
import '../../widget/cards.dart';

class OrderConfirmPage extends StatefulWidget{
  const OrderConfirmPage({Key? key, required this.route, required this.departureDate}) : super(key: key);
  final TrainRoute route;
  final DateTime departureDate;

  @override
  State<StatefulWidget> createState() => OrderConfirmState();
}

class OrderConfirmState extends State<OrderConfirmPage> {
  List<TicketPrice> _prices = [];
  final List<Passenger> _passengers = [];
  late final TrainRoute _route;
  int? _selectedType ;
  bool _isLoading = true;
  static final List<SeatSelectRow> _seatSelectRows = [];

  @override
  void initState() {
    super.initState();
    _selectedType = null;
    _route = widget.route;
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

  Widget _contentCard() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _routeInfoCard(),
              const SizedBox(height: 8,),
              _selectPassengerButton(),
              const SizedBox(height: 8,),
              if(_passengers.isNotEmpty)
                _passengerCards(),
              if(_passengers.isNotEmpty)
                _selectSeatCard(),
              const SizedBox(height: 8,),
              Image.asset('images/orderTips.jpg'),
              const SizedBox(height: 12,),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if(_passengers.isNotEmpty){
                              if(_selectedType == null){
                                Fluttertoast.showToast(msg: '请选择座位类型');
                              }else{
                                Order order = Order.name();
                                order.orderId = '';
                                order.userId = UserApi.getUserId().toString();
                                order.passengerId = '';
                                order.departureDate = DateUtil.date(widget.departureDate);
                                order.trainRouteId = _route.trainRouteId;
                                order.fromStationId = _route.fromStationId;
                                order.toStationId = _route.toStationId;
                                order.seatTypeId = _selectedType!;
                                order.orderStatus = '';
                                order.orderTime = '';
                                order.price = 0;
                                order.tradeNo = '';
                                List<String> passengerIds = [];
                                for (var element in _passengers) {
                                  passengerIds.add(element.passengerId);
                                }
                                _submitOrder(order, passengerIds);
                              }
                            }else{
                              Fluttertoast.showToast(msg: '请选择乘员');
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                            child: Text('提交订单'),
                          ))

                  )
                ],
              ),
              const SizedBox(height: 24,),
            ],
          ),
        )
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
            SelectPassengerPage(addedPassengers: _passengers,));
        if(addedPassengerList != null){
          _passengers.clear();
          _passengers.addAll(addedPassengerList);
          _seatSelectRows.clear();
          for(int i = 0; i < _passengers.length; i++){
            _seatSelectRows.add(SeatSelectRow());
          }
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
      children: _passengers.map((e) => _passengerInfo(e)).toList(),
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
                      _passengers.remove(passenger);
                    });
                  },
                  icon: const Icon(Icons.delete_forever))

            ],
          ),
        )
    );
  }

  Widget _selectSeatCard(){
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('选座服务',style: TextStyle(color: Colors.orange),),
                const Expanded(child: SizedBox()),
                Text('可选${_seatSelectRows.length}个座位',
                    style: const TextStyle(color: Colors.blue))
              ],
            ),
            const SizedBox(height: 6,),
            ..._seatSelectRows
          ],
        ),
      ),
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

  Future<void> _submitOrder(Order order, List<String> passengerIds) async {
    bool hasNotChoice = false;
    List<int> seatSelects = [];
    for (var element in _seatSelectRows) {
      if(element.selectIndex == null){
        Fluttertoast.showToast(msg: '有乘员未选座');
        hasNotChoice = true;
        break;
      }else{
        seatSelects.add(element.selectIndex!);
      }
    }
    if(!hasNotChoice){
      ResultEntity resultEntity = await TicketAndOrderApi.ticketBooking(order, passengerIds, seatSelects);
      if(resultEntity.result){
        Get.to(() => const OrderUnpaiedPage());
      }else{
        Fluttertoast.showToast(msg: resultEntity.message);
      }
    }
  }
}

class SeatSelectRow extends StatefulWidget{
  int? selectIndex;
  SeatSelectRow({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SeatSelectRowState();

  int? getSelectIndex() => selectIndex;
}

class _SeatSelectRowState extends State<SeatSelectRow>{
  int index1 = 1;
  int index2 = 2;
  int index3 = 3;
  int index4 = 4;

  @override
  void initState() {
    super.initState();
    widget.selectIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Center(
              child: Text('窗'),
            ),
        ),

        Expanded(
          child: ElevatedButton(
            onPressed: (){
              setState((){
                widget.selectIndex = index1;
              });
            },
            style: ButtonStyle(backgroundColor: widget.selectIndex == index1?
            MaterialStateProperty.all(const Color.fromRGBO(206, 231, 255, 0.9)):
            MaterialStateProperty.all(Colors.white70)),
            child: Text('$index1',style: const TextStyle(color: Colors.indigo),),
          )
        ),

        const SizedBox(width: 6,),

        Expanded(
            child: ElevatedButton(
              onPressed: (){
                setState((){
                  widget.selectIndex = index2;
                });
              },
              style: ButtonStyle(backgroundColor: widget.selectIndex == index2?
              MaterialStateProperty.all(const Color.fromRGBO(206, 231, 255, 0.9)):
              MaterialStateProperty.all(Colors.white70)),
              child: Text('$index2',style: const TextStyle(color: Colors.indigo),),
            )
        ),

        const Expanded(
          child: Center(
            child: Text('过道'),
          ),
        ),

        Expanded(
            child: ElevatedButton(
              onPressed: (){
              setState((){
                widget.selectIndex = index3;
              });
              },
              style: ButtonStyle(backgroundColor: widget.selectIndex == index3?
              MaterialStateProperty.all(const Color.fromRGBO(206, 231, 255, 0.9)):
              MaterialStateProperty.all(Colors.white70)),
              child: Text('$index3',style: const TextStyle(color: Colors.indigo),),
            )
        ),

        const SizedBox(width: 6,),

        Expanded(
            child: ElevatedButton(
              onPressed: (){
                setState((){
                  widget.selectIndex = index4;
                });
              },
              style: ButtonStyle(backgroundColor: widget.selectIndex == index4?
              MaterialStateProperty.all(const Color.fromRGBO(206, 231, 255, 0.9)):
              MaterialStateProperty.all(Colors.white70)),
              child: Text('$index4',style: const TextStyle(color: Colors.indigo),),
            )
        ),

        const SizedBox(width: 6,),

        const Expanded(
          child: Center(
            child: Text('窗'),
          ),
        ),
      ],
    );
  }

}