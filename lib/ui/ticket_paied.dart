import 'package:flutter/material.dart';
import 'package:train_client_flutter/bean/bean.dart';

import '../widget/cards.dart';

class TicketPaiedPage extends StatefulWidget{
  const TicketPaiedPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>TicketPaiedState();
}

class TicketPaiedState extends State<TicketPaiedPage>{
  OrderGeneral o = OrderGeneral.fromJson({});
  late List<OrderGeneral> list = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("已支付"),),
      body: list.isEmpty?_noTicketWidget():_ticketsWidget(),
    );
  }
  Widget _noTicketWidget(){
    return const Center(
      child: Text("暂无已支付订单",style: TextStyle(fontSize: 20),),
    );
  }

  Widget _ticketsWidget(){
    return Column(
      children: [
        TicketPaiedCard(orderGeneral: list.first,)
      ],
    );
  }

}