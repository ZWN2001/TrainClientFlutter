import 'package:flutter/material.dart';

import '../bean/bean.dart';
import '../widget/cards.dart';

class MyTicketPage extends StatefulWidget{
  const MyTicketPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyTicketState();

}

class MyTicketState extends State<MyTicketPage>{
  OrderGeneral o = OrderGeneral.fromJson({});
  late List<OrderGeneral> list = [o];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("我的车票"),),
      body: list.isEmpty?_noTicketWidget():_ticketsWidget(),
    );
  }
  Widget _noTicketWidget(){
    return const Center(
      child: Text("暂无车票",style: TextStyle(fontSize: 20),),
    );
  }

  Widget _ticketsWidget(){
    return SingleChildScrollView(
      child: Column(
        children: [
          TicketPaiedCard(orderGeneral: list.first,)
        ],
      ),
    );
  }

}