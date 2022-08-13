import 'dart:async';

import 'package:flutter/material.dart';

import '../bean/bean.dart';
import '../widget/cards.dart';

class TicketUnpaiedPage extends StatefulWidget{
  const TicketUnpaiedPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_TicketUnpaiedState();
}

class _TicketUnpaiedState extends State<TicketUnpaiedPage>{
  late Timer _timer;
  int _countdownTime = 150;
  String fromStation = '潍坊';
  String fromTime = '04:13';
  String toStation = '北京';
  String toTime = '13:26';
  String trainRouteId = 'K286';
  String stopoverTime = '9时13分';
  String startTime = '2022年08月14日 周日';
  List<PassengerToPay> passengerList = [];
  PassengerToPay p = PassengerToPay.fromJson({});
  double allPrice = 0;

  @override
  void initState() {
    super.initState();
    startCountdownTimer();
    passengerList.add(p);
    for (var element in passengerList) {
      allPrice+=element.price;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('未完成'),elevation: 0,),
      body: haveOrder(),
    );
  }

  Widget haveOrder(){
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
                countDownRow(),
                tipsCard(),
                const SizedBox(height: 8,),
                orderInfoCard(),
                passengerInfoCard(),
              ],
            ),
          )
        ),
        Positioned(left:0,bottom:0,right:0,child: settlementCard())
      ],
    );
  }

  Widget countDownRow(){
    return Padding(
      padding: const EdgeInsets.only(top: 8,bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(padding: EdgeInsets.only(bottom: 2),
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

  Widget tipsCard(){
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

  Widget orderInfoCard(){
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fromTime, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    Text(fromStation)
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text(trainRouteId, style: const TextStyle(fontSize: 18)),
                    const ImageIcon(AssetImage('icons/arrow.png'),size: 26,color: Colors.blue,),
                    Text('历时$stopoverTime',style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(toTime, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    Text(toStation)
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12,),
            Text('发车时间：$startTime',style: const TextStyle(color: Colors.grey),),
            const SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }

  Widget passengerInfoCard(){
    return Column(
        // children: allGrades.map((g) => GradeCard(g)).toList(),
      children: [
        PassengerCard(passenger: p,)
      ],
    );
  }

  Widget settlementCard(){
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
              Text('$allPrice',style: const TextStyle(fontSize: 24,color: Colors.deepOrange),),
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

  void startCountdownTimer() {
    const oneSec = Duration(seconds: 1);

    void callback(timer) {
      setState(() {
        if (_countdownTime < 1) {
          //TODO
          _timer.cancel();
        } else {
          _countdownTime = _countdownTime - 1;
        }
      });
    }
    _timer = Timer.periodic(oneSec, callback);
  }

  @override
  void dispose() {
    super.dispose();
    if(mounted){
      _timer.cancel();
    }
  }

}
