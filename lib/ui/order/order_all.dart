import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../api/api.dart';
import '../../bean/bean.dart';
import '../../widget/cards.dart';

class OrderAllPage extends StatefulWidget{
  const OrderAllPage({Key? key}) : super(key: key);
  static const routeName = '/order_all';

  @override
  State<StatefulWidget> createState() =>OrderAllState();

}

class OrderAllState extends State<OrderAllPage>{
  late final List<OrderGeneral> _list = [];
  Widget _body = const Center(child: CircularProgressIndicator());

  @override
  void initState() {
    super.initState();
    _getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("全部订单"),),
      body: _body,
    );
  }
  Widget _noTicketWidget(){
    return const Center(
      child: Text("暂无订单",style: TextStyle(fontSize: 20),),
    );
  }

  Widget _ticketsWidget(){
    return SingleChildScrollView(
      child: Column(
          children: _list.map((e) => AllTicketCard(orderGeneral: e,)).toList()
      ),
    );
  }

  Future<void> _getOrder() async {
    ResultEntity requestMap = await TicketAndOrderApi.getOrderAll();
    if (requestMap.result) {
      _list.clear();
      _list.addAll(requestMap.data);
      _body = _list.isEmpty?_noTicketWidget():_ticketsWidget();
    }else{
      Fluttertoast.showToast( msg: requestMap.message);
    }
    setState((){});
  }

}