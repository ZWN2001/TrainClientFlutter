import 'package:flutter/material.dart';
import 'package:train_client_flutter/bean/bean.dart';

import '../../widget/cards.dart';


class OrderPaiedPage extends StatefulWidget{
  const OrderPaiedPage({Key? key}) : super(key: key);
  static const routeName = '/order_paid';

  @override
  State<StatefulWidget> createState() =>OrderPaiedState();
}

class OrderPaiedState extends State<OrderPaiedPage>{
  OrderGeneral o = OrderGeneral.fromJson({});
  late List<OrderGeneral> list = [o];


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
    return SingleChildScrollView(
      child: Column(
        children: [
          TicketPaiedCard(orderGeneral: list.first,)
        ],
      ),
    );
  }

}