import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../api/api.dart';
import '../../bean/bean.dart';
import '../../widget/cards.dart';

class MyTicketPage extends StatefulWidget{
  const MyTicketPage({Key? key}) : super(key: key);
  static const routeName = '/my_ticket';

  @override
  State<StatefulWidget> createState() => MyTicketState();

}

class MyTicketState extends State<MyTicketPage>{
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
      appBar: AppBar(title: const Text("我的车票"),),
      body: _body,
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
          children: _list.map((e) => TicketPaiedCard(orderGeneral: e,)).toList()
      ),
    );
  }

  Future<void> _getOrder() async {
    ResultEntity requestMap = await TicketAndOrderApi.getMyTicket();
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