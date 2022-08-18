import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:train_client_flutter/api/api.dart';
import 'package:train_client_flutter/ui/passenger/add_passenger.dart';

import '../../bean/bean.dart';
import '../../widget/cards.dart';

class MyPassengerPage extends StatefulWidget{
  const MyPassengerPage({Key? key}) : super(key: key);
  static const routeName = '/my_passenger';

  @override
  State<StatefulWidget> createState() => MyPassengerState();
}

class MyPassengerState extends State<MyPassengerPage>{
  late List<Passenger> list = [];
  Widget _body = const Center(child: CircularProgressIndicator());

  @override
  void initState() {
    super.initState();
    _getPassenger();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("乘员列表"),
        actions: [
          TextButton(
              onPressed: () async {
                Passenger? p = await Get.to(() => const AddPassengerPage());
                if(p != null){
                  list.add(p);
                  setState((){_body = _resultBody();});
                }
              }, child: const Text('添加',
            style: TextStyle(fontSize: 16, color: Colors.white),))
        ],),
      body: _body
    );
  }

  Widget _resultBody(){
    return SingleChildScrollView(
      child: Column(
        children: [
          _tipsCard(),
          const SizedBox(height: 24,),
          list.isEmpty ? _noTicketWidget() : _ticketsWidget()
        ],
      ),
    );
  }

  Widget _tipsCard(){
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
        children: list.map((e) => PassengerInfoCard(passenger: e,)).toList()
      ),
    );
  }

  Future<void> _getPassenger() async {
    ResultEntity requestMap = await PassengerApi.getAllPassenger();
    if (requestMap.result) {
      list.clear();
      list.addAll(requestMap.data);
      _body = _resultBody();
    }else{
      Fluttertoast.showToast( msg: requestMap.message);
    }
    setState((){});
  }

}