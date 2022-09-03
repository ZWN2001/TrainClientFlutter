import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:train_client_flutter/api/api.dart';
import 'package:train_client_flutter/constant.dart';
import 'package:train_client_flutter/ui/main_page.dart';

import '../../bean/bean.dart';
import '../../widget/cards.dart';
import '../../widget/dialog.dart';

class OrderUnpaiedPage extends StatefulWidget{
  const OrderUnpaiedPage({Key? key}) : super(key: key);
  static const routeName = '/order_unpaid';

  @override
  State<StatefulWidget> createState() =>_OrderUnpaiedState();
}

class _OrderUnpaiedState extends State<OrderUnpaiedPage>{
  late Timer? _timer;
  int _countdownTime = 150;
  TicketRouteTimeInfo _timeInfo = TicketRouteTimeInfo.fromJson({});
  TicketRouteTimeInfo _timeInfoNext = TicketRouteTimeInfo.fromJson({});
  final List<PassengerToPay> _passengerList = [];
  double _allPrice = 0;
  List<Order> _res = [];
  Order? _order;
  Order? _orderNext;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _timer = null;
    _orderInit();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.offAll(()=>const MainPage(targetIndex: 2,));
          return true;
        },
        child: Scaffold(
            appBar: AppBar(elevation: 0,),
            body: _loading ? const Center(child: CircularProgressIndicator()):(
                _order == null? const Center(child: Text('无订单需要支付',style: TextStyle(fontSize: 20))):
                _haveOrder()
            )
        ),
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
                _orderNext == null? _orderInfoCard() : _orderInfoCardTansfer(),
                _passengerInfoCard(),
                const SizedBox(height: 100,),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(padding: EdgeInsets.only(bottom: 2,left: 2),
            child: Icon(Icons.access_time_outlined,
              size: 28, color: Colors.white,),),
          const SizedBox(width: 10,),
          const Text('未完成',style: TextStyle(fontSize: 24,
              color: Colors.white,fontWeight: FontWeight.bold),),
          const Expanded(child: SizedBox()),
          const Padding(padding: EdgeInsets.only(bottom: 2),
            child: Text('剩余：',style: TextStyle(color: Colors.white),),),
          Text('${_countdownTime~/60}分${_countdownTime%60}秒',
            style: const TextStyle(fontSize: 20,
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

  Widget _orderInfoCard(){
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

  Widget _orderInfoCardTansfer() {
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

  Widget _passengerInfoCard(){
    return Column(
        children: _passengerList.map((p) =>  OrderPassengerCard(passenger: p)).toList(),
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
                      onPressed: _orderCancel,
                      child: const Text('取消订单'),
                    ),
                  )
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12,right: 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
                      onPressed: _orderPay,
                      child: const Text('立即支付'),
                    ),
                  )
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _orderInit() async {
    ResultEntity orderResult = await TicketAndOrderApi.getTicketToPayDetail();
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
        DateTime dateTime = DateTime.parse(_order!.orderTime);
        DateTime now = DateTime.now();
        _countdownTime = 5 * 60 - now.difference(dateTime).inSeconds;
        if(_countdownTime<0){
          _order = null;
          setState((){_loading = false;});
          return;
        }
        // _countdownTime = 5 * 60 ;
        _startCountdownTimer();
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
      Fluttertoast.showToast(msg: orderResult.message);
    }
    setState((){_loading = false;});
  }

  Future<void> _orderCancel() async {
    bool? delete = await MyDialog.showDeleteConfirmDialog(context: context,
        tips: "确定取消订单吗？");
    if(delete != null && delete){
      List<String> allPassengerIdList = [];
      for (var element in _passengerList) {
        allPassengerIdList.add(element.passengerId);
      }
      ResultEntity resultEntity = await TicketAndOrderApi.ticketBookingCancel(_order!.departureDate,_order!.trainRouteId,allPassengerIdList);
      if(_orderNext != null){
        resultEntity = await TicketAndOrderApi.ticketBookingCancel(_orderNext!.departureDate,_orderNext!.trainRouteId,allPassengerIdList);
      }
      if(resultEntity.result){
        Fluttertoast.showToast(msg: '取消成功');
        _order = null;
        _orderNext = null;
        Get.back();
        Get.back();
      }else{
        Fluttertoast.showToast(msg: resultEntity.message);
      }
    }
  }

  Future<void> _orderPay() async {
    List<String> allPassengerIdList = [];
    for (var element in _passengerList) {
      if(!allPassengerIdList.contains(element.passengerId)){
        allPassengerIdList.add(element.passengerId);
      }
    }
    ResultEntity resultEntity = await PayApi.ticketPay(_order!.orderId, allPassengerIdList, 0);
    if(resultEntity.result){
     String result = resultEntity.data;
     Get.showOverlay(
         asyncFunction: () async {
           ResultEntity resultEntity;
           while (true) {
             resultEntity = await PayApi.getOrderPayStatus(_order!.orderId);
             if (resultEntity.result && resultEntity.data) {
               Fluttertoast.showToast(msg: '支付成功');
               Get.offAll(()=>const MainPage(targetIndex: 2,));
               break;
             }
           }
         },
         loadingWidget: Dialog(
           child: Container(
             padding: const EdgeInsets.all(8),
             alignment: Alignment.center,
             child: QrImage(data: result),
           ),
         ));
    }else{
      Fluttertoast.showToast(msg: resultEntity.message);
    }
  }

  void _startCountdownTimer() {
    const oneSec = Duration(seconds: 1);

    void callback(timer) {
      setState(() {
        if (_countdownTime < 1) {
          _order = null;
          _timer!.cancel();
        } else {
          _countdownTime = _countdownTime - 1;
        }
      });
    }
    _timer = Timer.periodic(oneSec, callback);
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

  @override
  void dispose() {
    super.dispose();
    if( _timer != null){
      _timer!.cancel();
    }
  }

}
