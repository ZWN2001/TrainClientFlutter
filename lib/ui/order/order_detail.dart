import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../api/api.dart';
import '../../bean/bean.dart';
import '../../widget/cards.dart';

class OrderDetailPage extends StatefulWidget{
  const OrderDetailPage({Key? key, required this.orderId}) : super(key: key);
  final String orderId;
  static const String routeName = '/order_detail';

  @override
  State<StatefulWidget> createState() => OrderDetailState();
}

class OrderDetailState extends State<OrderDetailPage>{
  TicketRouteTimeInfo _timeInfo = TicketRouteTimeInfo.fromJson({});
  final List<PassengerToPay> _passengerList = [];
  double _allPrice = 0;
  List<Order> _res = [];
  late Order _order;
  bool _loading = true;
  int carriageId = 0;
  int seat = 0;

  @override
  void initState() {
    super.initState();
    _initOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0,),
        body: _loading ?
        const Center(child: CircularProgressIndicator()): _haveOrder()
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
                  _countDownRow(),
                  _tipsCard(),
                  const SizedBox(height: 8,),
                  _orderInfoCard(),
                  const SizedBox(height: 8,),
                  _ticketInfoCard(),
                  (_order.orderStatus == OrderStatus.PAIED || _order.orderStatus == OrderStatus.REBOOK) ?
                  _passengerInfoCard():_passengerWithSeatInfoCard(),
                ],
              ),
            )
        ),
        Positioned(left:0,bottom:0,right:0,child: _settlementCard())
      ],
    );
  }

  Widget _countDownRow(){
    return Padding(
      padding: const EdgeInsets.only(top: 8,bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(bottom: 2),
            child: Icon(Icons.access_time_outlined,
              size: 28, color: Colors.white,),),
          const SizedBox(width: 10,),
          Text(_order.orderStatus,style: const TextStyle(fontSize: 24,
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
                    Text(' ${_order.fromStationId}')
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text(_order.trainRouteId, style: const TextStyle(fontSize: 18)),
                    const ImageIcon(AssetImage('icons/arrow.png'),size: 26,color: Colors.blue,),
                    Text('历时 ${_timeInfo.durationInfo}',style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_timeInfo.arriveTime, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    Text('${_order.toStationId} ')
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12,),
            Text('发车时间：${_order.departureDate}',style: const TextStyle(color: Colors.grey),),
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
    return Column(
      children: _passengerList.map((p) =>  OrderPassengerWithSeatInfoCard(passenger: p,carriageId: carriageId,seat: seat,)).toList(),
    );
  }

  Widget _settlementCard(){
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
                      child: const Text('取消订单'),
                      onPressed: (){

                      },
                    ),
                  )
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12,right: 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
                      child: const Text('立即支付'),
                      onPressed: (){

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

  Widget _orderInfoCard(){
    return Card(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Column(
              children: [
                Text('订单号：${_order.orderId}'),
                Text('订单创建时间：${_order.orderTime}'),
                Text('交易流水号：${_order.tradeNo}')
              ],
            )
        )
    );
  }

  Future<void> _initOrder() async {
    ResultEntity orderResult = await TicketAndOrderApi.getOrderInfo(widget.orderId);
    if(orderResult.result){
      _res = orderResult.data;
      if(_res.isNotEmpty){
        //初始化order与订单剩余时间
        _order = _res[0];

        //初始化各乘员
        for(Order o in _res){
          ResultEntity r = await PassengerApi.getSinglePassenger(o.passengerId);
          if(r.result){
            PassengerToPay p = r.data;
            p.price = o.price;
            _passengerList.add(p);
            _allPrice += p.price;
          }
        }
        //初始化车次发车与到站时间 & 历时
        ResultEntity resultEntity = await
        TrainRouteApi.getTrainRouteTimeInfo(_order.trainRouteId, _order.fromStationId, _order.toStationId);
        if(resultEntity.result){
          _timeInfo = resultEntity.data;
          String duration = _timeInfo.durationInfo;
          List<String> list = duration.split(":");
          if(list.length == 2){
            _timeInfo.durationInfo = "${list[0]}小时${list[1]}分钟";
          }else if(list.length == 3){
            _timeInfo.durationInfo = "${list[0]}天${list[1]}小时${list[2]}分钟";
          }

          //对于已出票&改签：查询车厢号与座号

        }else{
          Fluttertoast.showToast(msg: '初始化车次时间失败');
        }
      }
    }else{
      Fluttertoast.showToast(msg: orderResult.message);
    }
    setState((){_loading = false;});
  }

}