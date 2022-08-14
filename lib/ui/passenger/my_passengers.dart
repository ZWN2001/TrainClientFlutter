import 'package:flutter/material.dart';

import '../../bean/bean.dart';
import '../../widget/cards.dart';

class MyPassengerPage extends StatefulWidget{
  const MyPassengerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyPassengerState();
}

class MyPassengerState extends State<MyPassengerPage>{
  Passenger o = Passenger.fromJson({});
  late List<Passenger> list = [o];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("乘员列表"),
        actions: [
        TextButton(onPressed: (){}, child: const Text('添加',
          style: TextStyle(fontSize:16, color: Colors.white),))
      ],),
      body: Column(
        children: [
          tipsCard(),
          const SizedBox(height: 24,),
          list.isEmpty? _noTicketWidget() : _ticketsWidget()
        ],
      ),
    );
  }

  Widget tipsCard(){
    return Container(
          color: const Color.fromRGBO(255, 200, 200, 0.4),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '购票人须提供毎一名乘车旅客本人使用的联系方式，为了方便您为他人购票，'
                  '请惩提前填报并通知乘车旅客协助核验。',
              style: TextStyle(color: Colors.red),
            ),
          ),
    );
  }

  Widget _noTicketWidget(){
    return const Center(
      child: Text("暂无乘员",style: TextStyle(fontSize: 20),),
    );
  }

  Widget _ticketsWidget(){
    return SingleChildScrollView(
      child: Column(
        children: [
          PassengerInfoCard(passenger: list.first,)
        ],
      ),
    );
  }

}