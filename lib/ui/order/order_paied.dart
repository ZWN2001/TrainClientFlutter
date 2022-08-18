import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:train_client_flutter/api/api.dart';
import 'package:train_client_flutter/bean/bean.dart';

import '../../widget/cards.dart';


class OrderPaiedPage extends StatefulWidget{
  const OrderPaiedPage({Key? key}) : super(key: key);
  static const routeName = '/order_paid';

  @override
  State<StatefulWidget> createState() =>OrderPaiedState();
}

class OrderPaiedState extends State<OrderPaiedPage>{
  late List<OrderGeneral> list = [];
  Widget _body = const Center(child: CircularProgressIndicator());

  @override
  void initState() {
    super.initState();
    _getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("已支付"),),
      body: _body,
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
         children: list.map((e) => TicketPaiedCard(orderGeneral: e,)).toList()
      ),
    );
  }

  Future<void> _getOrder() async {
    ResultEntity requestMap = await TicketAndOrderApi.getOrderPaied();
    if (requestMap.result) {
      list.clear();
      list.addAll(requestMap.data);
      _body = list.isEmpty?_noTicketWidget():_ticketsWidget();
    }else{
      Fluttertoast.showToast( msg: requestMap.message);
    }
    setState((){});
  }

}