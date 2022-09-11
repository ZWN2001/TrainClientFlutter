import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:train_client_flutter/constant.dart';

import '../../api/api.dart';
import '../../bean/bean.dart';
import '../../widget/cards.dart';
import '../../widget/dialog.dart';
import '../train_route/route_rebook.dart';

class OrderDetailPage extends StatefulWidget{
  const OrderDetailPage({Key? key, required this.orderId, this.passengerId}) : super(key: key);
  final String orderId;
  final String? passengerId;
  static const String routeName = '/order_detail';

  @override
  State<StatefulWidget> createState() => OrderDetailState();
}

class OrderDetailState extends State<OrderDetailPage>{
  TicketRouteTimeInfo _timeInfo = TicketRouteTimeInfo.fromJson({});
  TicketRouteTimeInfo _timeInfoNext = TicketRouteTimeInfo.fromJson({});
  final List<PassengerToPay> _passengerList = [];
  double _allPrice = 0;
  List<Order> _res = [];
  List<SeatInfo> seatInfos = [];
  late Order? _order;
  Order? _orderNext;
  bool _loading = true;
  int carriageId = 0;
  int seat = 0;

  @override
  void initState() {
    super.initState();
    _order = null;
    _initOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),),
        body: _loading ?
        const Center(child: CircularProgressIndicator()) :
        (_order == null ?
        const Center(child: Text('无订单信息', style: TextStyle(fontSize: 20)))
            : _haveOrder())
    );
  }

  Widget _haveOrder(){
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.center,
              )),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _statusRow(),
                  _tipsCard(),
                  const SizedBox(height: 8,),
                  _orderInfoCard(),
                  _orderNext == null? _ticketInfoCard() : _ticketInfoCardTansfer(),
                  const SizedBox(height: 8,),
                  (_order!.orderStatus == OrderStatus.PAIED || _order!.orderStatus == OrderStatus.REBOOK) ?
                  _passengerWithSeatInfoCard() : _passengerInfoCard(),
                ],
              ),
            )
        ),
        if(_order!.orderStatus == OrderStatus.PAIED)
          Positioned(left:0,bottom:0,right:0,child: _paiedSettlementCard()),
        if(_order!.orderStatus == OrderStatus.REBOOK)
          Positioned(left:0,bottom:0,right:0,child: _rebookedSettlementCard()),
        if(_order!.orderStatus != OrderStatus.PAIED && _order!.orderStatus != OrderStatus.REBOOK )
          Positioned(left:0,bottom:0,right:0,child: _commonSettlementCard()),
      ],
    );
  }

  Widget _statusRow(){
    return Padding(
      padding: const EdgeInsets.only(top: 8,bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(bottom: 2),
            child: Icon(Icons.access_time_outlined,
              size: 28, color: Colors.white,),),
          const SizedBox(width: 10,),
          Text(_order!.orderStatus,style: const TextStyle(fontSize: 24,
              color: Colors.white,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }

  Widget _tipsCard(){
    return Card(
        child: Container(
          color: const Color.fromRGBO(255, 200, 200, 0.4),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '为了保证惩顺利出行，请提前了解上、下车站所在地政府'
                  '有关防控改策，持相关有效证明乘车，并在车站和到车上全程佣戴口罩，感谢支持和配合。',
              style: TextStyle(color: Colors.red),
            ),
          ),
        )
    );
  }

  Widget _ticketInfoCard(){
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_timeInfo.startTime, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    Text(' ${Constant.stationIdMap[_order!.fromStationId]?.stationName}')
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text(_order!.trainRouteId, style: const TextStyle(fontSize: 18)),
                    const ImageIcon(AssetImage('icons/arrow.png'),size: 26,color: Colors.blue,),
                    Text('历时 ${_timeInfo.durationInfo}',style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_timeInfo.arriveTime, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    Text('${Constant.stationIdMap[_order!.toStationId]?.stationName} ')
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12,),
            Text('发车时间：${_order!.departureDate}',style: const TextStyle(color: Colors.grey),),
            const SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }

  Widget _passengerInfoCard(){
    return Column(
      children: _passengerList.map((p) =>  OrderPassengerCard(passenger: p)).toList(),
    );
  }

  Widget _passengerWithSeatInfoCard(){
    List<Widget> c = [];
    for(int index = 0; index < _passengerList.length; index++){
      c.add(OrderPassengerWithSeatInfoCard(
        passenger: _passengerList[index],
        carriageId: seatInfos[index].carriageId,
        seat: seatInfos[index].seat,));
    }
    return Column(
      children: [
        ...c,
      ],
    );
  }

  Widget _orderInfoCard(){
    return Card(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('订单号：${_order!.orderId}'),)
                  ],
                ),
                const SizedBox(height: 4,),
                Text('订单创建时间：${_order!.orderTime}'),
                const SizedBox(height: 4,),
                Text('交易流水号：${_order!.tradeNo}')
              ],
            )
        )
    );
  }

  Widget _ticketInfoCardTansfer() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_timeInfo.startTime, style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),),
                    Text(" ${Constant.stationIdMap[_order!.fromStationId]!.stationName}", style: const TextStyle(
                        fontSize: 17),)
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text('${_timeInfo.arriveTime}到达',
                        style: const TextStyle(fontSize: 13, color: Colors.blue)),
                    const ImageIcon(AssetImage('icons/arrow.png'), size: 26,
                      color: Colors.blue,),
                    Text(_order!.trainRouteId,
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text(Constant.stationIdMap[_order!.toStationId]!.stationName,style: const TextStyle(fontSize: 16),),
                    const SizedBox(height: 7,),
                    Text('同站换乘\n${_getDurationString(_getDuration(_timeInfo.arriveTime, _timeInfoNext.startTime))}',
                        style: const TextStyle(color: Colors.grey,fontSize: 13)),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text('${_timeInfoNext.startTime}出发',
                        style: const TextStyle(fontSize: 13, color: Colors.blue)),
                    const ImageIcon(AssetImage('icons/arrow.png'), size: 26,
                      color: Colors.blue,),
                    Text(_orderNext!.trainRouteId,
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_timeInfoNext.arriveTime, style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),),
                    Text("${Constant.stationIdMap[_orderNext!.toStationId]!.stationName} ", style: const TextStyle(
                        fontSize: 17),)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _commonSettlementCard(){
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -4.0), //阴影xy轴偏移量
                blurRadius: 15.0, //阴影模糊程度
                spreadRadius: 1.0 //阴影扩散程度
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 16,),
          Row(
            children: [
              const SizedBox(width: 24,),
              const Text("总金额:  ",style: TextStyle(fontSize: 16,color: Colors.grey),),
              const Text('￥',style: TextStyle(fontSize: 16,color: Colors.deepOrange),),
              Text('$_allPrice',style: const TextStyle(fontSize: 24,color: Colors.deepOrange),),
            ],
          ),
          const SizedBox(height: 6,),
        ],
      ),
    );
  }

  Widget _paiedSettlementCard(){
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -4.0), //阴影xy轴偏移量
                blurRadius: 15.0, //阴影模糊程度
                spreadRadius: 1.0 //阴影扩散程度
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 8,),
          Row(
            children: [
              const SizedBox(width: 24,),
              const Text("总金额:  ",style: TextStyle(fontSize: 16,color: Colors.grey),),
              const Text('￥',style: TextStyle(fontSize: 16,color: Colors.deepOrange),),
              Text('$_allPrice',style: const TextStyle(fontSize: 24,color: Colors.deepOrange),),
            ],
          ),
          const SizedBox(height: 8,),
          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24,right: 12),
                    child: ElevatedButton(
                      onPressed: _refund,
                      child: const Text('退票'),
                    ),
                  )
              ),
              if(_orderNext == null)
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12,right: 24),
                    child: ElevatedButton(
                      child: const Text('改签'),
                      onPressed: (){
                        Get.to(()=>RouteRebookPage(
                          title: '${Constant.stationIdMap[_order!.fromStationId]!.stationName}<>${Constant.stationIdMap[_order!.toStationId]!.stationName}(改签)',
                          date: DateTime.now(),
                          fromStationId: _order!.fromStationId,
                          toStationId: _order!.toStationId,
                          passengerList: _passengerList,
                          orderId: widget.orderId,
                          originalRTainRouteId: _order!.trainRouteId,
                        ));
                      },
                    ),
                  )
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _rebookedSettlementCard(){
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -4.0), //阴影xy轴偏移量
                blurRadius: 15.0, //阴影模糊程度
                spreadRadius: 1.0 //阴影扩散程度
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 8,),
          Row(
            children: [
              const SizedBox(width: 24,),
              const Text("总金额:  ",style: TextStyle(fontSize: 16,color: Colors.grey),),
              const Text('￥',style: TextStyle(fontSize: 16,color: Colors.deepOrange),),
              Text('$_allPrice',style: const TextStyle(fontSize: 24,color: Colors.deepOrange),),
              const Expanded(child: SizedBox()),
              ElevatedButton(
                onPressed: _refund,
                child: const Text('退票'),
              ),
              const SizedBox(width: 18,),
            ],
          ),
          const SizedBox(height: 6,),
        ],
      ),
    );
  }

  Future<void> _initOrder() async {
    ResultEntity orderResult = await TicketAndOrderApi.getOrderInfo(widget.orderId,widget.passengerId);
    if(orderResult.result){
      _res = orderResult.data;
      if(_res.isNotEmpty){
        //初始化order与订单剩余时间
        _order = _res[0];
        if(_res.length > 1 && _res.length % 2 == 0){
          _orderNext = _res[1];
          if(_orderNext!.trainRouteId == _order!.trainRouteId){
            _orderNext = null;
          }
        }else{
          _orderNext = null;
        }
        //初始化各乘员
        for(Order o in _res){
          ResultEntity r = await PassengerApi.getSinglePassenger(o.passengerId);
          if(r.result){
            PassengerToPay p = r.data;
            p.price = o.price;
            p.seatTypeId = o.seatTypeId;
            _passengerList.add(p);
            _allPrice += p.price;
          }
        }

        if(_order?.orderStatus == OrderStatus.PAIED || _order?.orderStatus == OrderStatus.REBOOK){
          List<String> pids = [];
          for(PassengerToPay p in _passengerList){
            pids.add(p.passengerId);
          }
          ResultEntity r = await TicketAndOrderApi.getTicketSeatInfo(_order!.orderId,pids);
          if(r.result){
            seatInfos = r.data;
          }
        }
        //初始化车次发车与到站时间 & 历时
        ResultEntity resultEntity = await
        TrainRouteApi.getTrainRouteTimeInfo(_order!.trainRouteId, _order!.fromStationId, _order!.toStationId);
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
        if(_orderNext != null){
          ResultEntity resultEntity = await
          TrainRouteApi.getTrainRouteTimeInfo(_orderNext!.trainRouteId, _orderNext!.fromStationId, _orderNext!.toStationId);
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
        }
      }
    }else{
      _order = null;
      Fluttertoast.showToast(msg: orderResult.message);
    }
    setState((){_loading = false;});
  }

  Future<void> _refund() async {
    bool? delete = await MyDialog.showDeleteConfirmDialog(context: context,
        tips: "确定退票吗？");
    if (delete != null) {
      ResultEntity resultEntity = await TicketAndOrderApi.ticketRefund(widget.orderId);
      if(resultEntity.result){
        Get.back();
        Get.back();
        setState((){});
      }else{
        Fluttertoast.showToast(msg: resultEntity.message);
      }
    }
  }

  int _getDuration(String first,String next) {
    return 60 *
        ((24 - int.parse(first.substring(0, 2)) + int.parse(next.substring(0, 2))) % 24)
        + (int.parse(next.substring(3, 5)) - int.parse(first.substring(3, 5)));
  }

  String _getDurationString(int duration){
    if(duration > 60){
      return '${duration ~/ 60}时${duration % 60}分';
    }else{
      return '$duration分';
    }
  }



}