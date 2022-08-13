import 'package:flutter/material.dart';

import '../bean/bean.dart';
import '../widget/cards.dart';

class OrderAllPage extends StatefulWidget{
  const OrderAllPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>OrderAllState();

}

class OrderAllState extends State<OrderAllPage>{
  OrderGeneral o = OrderGeneral.fromJson({});
  late List<OrderGeneral> list = [o];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("全部订单"),),
      body: list.isEmpty?_noTicketWidget():_ticketsWidget(),
    );
  }
  Widget _noTicketWidget(){
    return const Center(
      child: Text("暂无已支付订单",style: TextStyle(fontSize: 20),),
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