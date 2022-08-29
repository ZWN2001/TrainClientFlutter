import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:train_client_flutter/api/api.dart';
import 'package:train_client_flutter/ui/passenger/select_passenger.dart';
import 'package:train_client_flutter/util/utils.dart';

import '../../bean/bean.dart';
import '../../constant.dart';
import '../../util/date_util.dart';
import 'order_unpaied.dart';

class OrderConfirmTransferPage extends StatefulWidget{
  const OrderConfirmTransferPage({Key? key, required this.route, required this.departureDate}) : super(key: key);
  final TrainRouteTransfer route;
  final DateTime departureDate;

  @override
  State<StatefulWidget> createState() => OrderConfirmTransferState();
}

class OrderConfirmTransferState extends State<OrderConfirmTransferPage> {
  List<TicketPrice> _prices = [];
  List<TicketPrice> _pricesNext = [];
  final List<Passenger> _passengers = [];
  late TrainRouteTransfer _routeTransfer;
  int? _selectedTypeFirst;
  int? _selectedTypeNext;
  TicketRouteTimeInfo _timeInfo = TicketRouteTimeInfo.fromJson({});
  TicketRouteTimeInfo _timeInfoNext = TicketRouteTimeInfo.fromJson({});
  bool _isLoading = true;
  static final List<SeatSelectRow> _seatSelectRows = [];
  static final List<SeatSelectRow> _seatSelectRowsNext = [];

  @override
  void initState() {
    super.initState();
    _routeTransfer = widget.route;
    _selectedTypeFirst = null;
    _selectedTypeNext = null;
    _getTransferData();
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
                              if(_selectedTypeFirst == null || _selectedTypeNext == null ){
                                Fluttertoast.showToast(msg: '请选择座位类型');
                              }else{
                                List<Order> list = _getOrderList();
                                List<String> passengerIds = [];
                                for (var element in _passengers) {
                                  passengerIds.add(element.passengerId);
                                }
                                _submitOrder(list, passengerIds);
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

  Widget _routeInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(" ${Constant.stationIdMap[_routeTransfer.fromStationId]!.stationName}", style: const TextStyle(
                    fontSize: 26),),
                const Expanded(child: SizedBox()),
                const ImageIcon(AssetImage('icons/arrow.png'), size: 26,
                  color: Colors.blue,),
                const Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text(Constant.stationIdMap[_routeTransfer.transStationId]!.stationName,style: const TextStyle(fontSize: 16),),
                    const SizedBox(height: 4,),
                    Text('同站换乘\n${getDurationString(_routeTransfer.durationTransfer)}',
                        style: const TextStyle(color: Colors.orange,fontSize: 15)),
                  ],
                ),
                const Expanded(child: SizedBox()),
                const ImageIcon(AssetImage('icons/arrow.png'), size: 26,
                  color: Colors.blue,),
                const Expanded(child: SizedBox()),
                Text("${Constant.stationIdMap[_routeTransfer.toStationId]!.stationName} ", style: const TextStyle(
                    fontSize: 26),)
              ],
            ),
            const Divider(),
            ..._routeInfoFirst(),
            const Divider(color: Colors.grey,),
            const SizedBox(height: 8,),
            ..._routeInfoNext()

          ],
        ),
      ),
    );
  }

  List<Widget> _routeInfoFirst(){
    return [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_routeTransfer.startTimeFrom, style: const TextStyle(fontSize: 26),),
                Text(Constant.stationIdMap[_routeTransfer.fromStationId]!.stationName, style: const TextStyle(fontSize: 16),)
              ],
            ),
            const Expanded(child: SizedBox()),
            Column(
              children: [
                Text(_routeTransfer.trainRouteId1, style: const TextStyle(fontSize: 18)),
                const ImageIcon(AssetImage('icons/arrow.png'),size: 26,color: Colors.blue,),
                Text(_timeInfo.durationInfo,style: const TextStyle(color: Colors.blue),)
              ],
            ),
            const Expanded(child: SizedBox()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_routeTransfer.arriveTimeTrans, style: const TextStyle(fontSize: 26),),
                Text(Constant.stationIdMap[_routeTransfer.transStationId]!.stationName, style: const TextStyle(fontSize: 16),)
              ],
            ),
          ],
        ),
        const SizedBox(height: 8,),
        const Divider(indent: 8, endIndent: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _prices.map((e) =>
              Expanded(
                  child: _seatTypeButton(e, true)
              )
          ).toList(),
        )
      ];
  }

  List<Widget> _routeInfoNext(){
    return [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_routeTransfer.startTimeTrans, style: const TextStyle(fontSize: 26),),
                Text(Constant.stationIdMap[_routeTransfer.transStationId]!.stationName, style: const TextStyle(fontSize: 16),)
              ],
            ),
            const Expanded(child: SizedBox()),
            Column(
              children: [
                Text(_routeTransfer.trainRouteId2, style: const TextStyle(fontSize: 18)),
                const ImageIcon(AssetImage('icons/arrow.png'),size: 26,color: Colors.blue,),
                Text(_timeInfoNext.durationInfo,style: const TextStyle(color: Colors.blue),)
              ],
            ),
            const Expanded(child: SizedBox()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_routeTransfer.arriveTimeTo, style: const TextStyle(fontSize: 26),),
                Text(Constant.stationIdMap[_routeTransfer.toStationId]!.stationName, style: const TextStyle(fontSize: 16),)
              ],
            ),
          ],
        ),
        const SizedBox(height: 10,),
        const Divider(indent: 8, endIndent: 8,height: 14,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _pricesNext.map((e) =>
              Expanded(
                  child: _seatTypeButton(e, false)
              )
          ).toList(),
        )
      ];
  }

  Widget _seatTypeButton(TicketPrice ticketPrice, bool isFirst){
    return Padding(padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: ElevatedButton(
          onPressed: () {
            if(isFirst){
              _selectedTypeFirst = ticketPrice.seatTypeId;
            }else{
              _selectedTypeNext = ticketPrice.seatTypeId;
            }

            if(mounted){
              setState((){});
            }
          },
          style: ButtonStyle(
            backgroundColor: isFirst? (_selectedTypeFirst != ticketPrice.seatTypeId?
            MaterialStateProperty.all(Colors.white70):
            MaterialStateProperty.all(const Color.fromRGBO(206, 231, 255, 0.9))):(
                _selectedTypeNext != ticketPrice.seatTypeId?
                MaterialStateProperty.all(Colors.white70):
                MaterialStateProperty.all(const Color.fromRGBO(206, 231, 255, 0.9))
            ),
            side: isFirst? (_selectedTypeFirst == ticketPrice.seatTypeId?
            MaterialStateProperty.all(const BorderSide(width: 1, color: Colors.blueAccent))
                :null):(
                _selectedTypeNext == ticketPrice.seatTypeId?
                MaterialStateProperty.all(const BorderSide(width: 1, color: Colors.blueAccent))
                    :null
            ),
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
          _seatSelectRowsNext.clear();
          for(int i = 0; i < _passengers.length; i++){
            _seatSelectRowsNext.add(SeatSelectRow());
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
                Text('可选${_seatSelectRows.length + _seatSelectRowsNext.length}个座位',
                    style: const TextStyle(color: Colors.blue))
              ],
            ),
            const SizedBox(height: 6,),
            Row(
              children: [
              Expanded(child: Center(child: Text('第一程    ${_routeTransfer.trainRouteId1}'),))
            ],),
            const SizedBox(height: 6,),
            ..._seatSelectRows,
            const SizedBox(height: 12,),
            Row(
              children: [
                Expanded(child: Center(child: Text('第二程    ${_routeTransfer.trainRouteId1}'),))
              ],),
            const SizedBox(height: 6,),
            ..._seatSelectRowsNext

          ],
        ),
      ),
    );
  }

  Future<void> _getTransferData() async {
    ResultEntity resultEntity = await TicketAndOrderApi.getTicketPrices(
        _routeTransfer.trainRouteId1, _routeTransfer.fromStationId, _routeTransfer.transStationId);
    if(resultEntity.result){
      _prices = resultEntity.data;
    }

    resultEntity = await TicketAndOrderApi.getTicketPrices(
        _routeTransfer.trainRouteId2, _routeTransfer.transStationId, _routeTransfer.toStationId);
    if(resultEntity.result){
      _pricesNext = resultEntity.data;
    }

    resultEntity = await
    TrainRouteApi.getTrainRouteTimeInfo( _routeTransfer.trainRouteId1, _routeTransfer.fromStationId, _routeTransfer.transStationId);
    if(resultEntity.result){
      _timeInfo = resultEntity.data;
      String duration = _timeInfo.durationInfo;
      List<String> list = duration.split(":");
      if(list.length == 2){
        _timeInfo.durationInfo = "${list[0]}小时${list[1]}分钟";
      }else if(list.length == 3){
        _timeInfo.durationInfo = "${list[0]}天${list[1]}小时${list[2]}分钟";
      }
    }else{
      Fluttertoast.showToast(msg: '初始化车次时间失败');
    }

    resultEntity = await
    TrainRouteApi.getTrainRouteTimeInfo(_routeTransfer.trainRouteId2, _routeTransfer.transStationId, _routeTransfer.toStationId);
    if(resultEntity.result){
      _timeInfoNext = resultEntity.data;
      String duration = _timeInfoNext.durationInfo;
      List<String> list = duration.split(":");
      if(list.length == 2){
        _timeInfoNext.durationInfo = "${list[0]}小时${list[1]}分钟";
      }else if(list.length == 3){
        _timeInfoNext.durationInfo = "${list[0]}天${list[1]}小时${list[2]}分钟";
      }
    }else{
      Fluttertoast.showToast(msg: '初始化车次时间失败');
    }

    setState((){
      _isLoading = false;
    });
  }

  List<Order> _getOrderList(){
    List<Order> list = [];
    Order order = Order.name();
    order.orderId = '';
    order.userId = UserApi.getUserId().toString();
    order.passengerId = '';
    order.departureDate = DateUtil.date(widget.departureDate);
    order.trainRouteId = _routeTransfer.trainRouteId1;
    order.fromStationId = _routeTransfer.fromStationId;
    order.toStationId = _routeTransfer.transStationId;
    order.seatTypeId = _selectedTypeFirst!;
    order.orderStatus = '';
    order.orderTime = '';
    order.price = 0;
    order.tradeNo = '';
    list.add(order);

    Order order2 = Order.name();
    order2.orderId = '';
    order2.userId = UserApi.getUserId().toString();
    order2.passengerId = '';
    order2.departureDate = DateUtil.date(widget.departureDate);
    order2.trainRouteId = _routeTransfer.trainRouteId2;
    order2.fromStationId = _routeTransfer.transStationId;
    order2.toStationId = _routeTransfer.toStationId;
    order2.seatTypeId = _selectedTypeNext!;
    order2.orderStatus = '';
    order2.orderTime = '';
    order2.price = 0;
    order2.tradeNo = '';
    list.add(order2);
    return list;
  }

  Future<void> _submitOrder(List<Order> orderList, List<String> passengerIds) async {
    bool hasNotChoice = false;
    List<int> seatSelects = [];
    List<int> seatSelectsNext = [];
    for (int i = 0; i<_passengers.length;i++) {
      if(_seatSelectRows[i].selectIndex == null
          || _seatSelectRowsNext[i].selectIndex == null){
        Fluttertoast.showToast(msg: '有乘员未选座');
        hasNotChoice = true;
        break;
      }else{
        seatSelects.add(_seatSelectRows[i].selectIndex!);
        seatSelectsNext.add(_seatSelectRowsNext[i].selectIndex!);
      }
    }

    if(!hasNotChoice){
      ResultEntity resultEntity = await TicketAndOrderApi.ticketBookingTransfer(
          orderList[0], orderList[1], passengerIds, seatSelects, seatSelectsNext);
      if(resultEntity.result){
        Get.to(() => const OrderUnpaiedPage());
      }else{
        Fluttertoast.showToast(msg: resultEntity.message);
      }
    }
  }

  String getDurationString(int duration){
    if(duration > 60){
      return '${duration ~/ 60}时${duration % 60}分';
    }else{
      return '$duration分';
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