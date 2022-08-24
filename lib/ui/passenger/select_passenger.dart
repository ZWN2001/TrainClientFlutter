import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../api/api.dart';
import '../../bean/bean.dart';
import '../../widget/cards.dart';
import 'add_passenger.dart';

class SelectPassengerPage extends StatefulWidget{
  const SelectPassengerPage({Key? key, required this.addedPassengers, }) : super(key: key);
  final List<Passenger> addedPassengers;//已经选的

  @override
  State<StatefulWidget> createState() => SelectPassengerState();

}

class SelectPassengerState extends State<SelectPassengerPage>{
  bool _loading = true;
  List<bool> selectList = [];
  late final List<Passenger> _passengerList = [];
  late final List<Passenger> _addedPassengers; //要的ID数组

  @override
  void initState() {
    super.initState();
    _getPassenger();
    _addedPassengers = widget.addedPassengers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("选择乘员"),
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
          actions: [
            TextButton(
                onPressed: () async {
                  List<Passenger> list = [];
                  list.addAll(_addedPassengers);
                  Get.back(result: list);
                },
                child: const Text('完成',
                  style: TextStyle(fontSize: 16, color: Colors.white),)),
          ],),
        body: _loading?const Center(child: CircularProgressIndicator()) : _mainContent()
    );
  }

  Widget _mainContent() {
    if (_passengerList.isEmpty) {
      return _noTicketWidget();
    } else {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_box_rounded,color: Colors.orange),
                    SizedBox(width: 6,),
                    Text('添加乘员',style: TextStyle(color: Colors.orange,fontSize: 18),)
                  ],
                ),
              ),
              onPressed: () async {
                Passenger? p = await Get.to(() => const AddPassengerPage());
                if(p != null){
                  _passengerList.add(p);
                  selectList.add(false);
                  if(mounted){setState((){});}
                }
              },
            ),),
            Expanded(
                child: _ticketsWidget(),
            ),
          ],
        ),
      );
    }
  }

  Widget _noTicketWidget(){
    return const Center(
      child: Text("暂无乘员",style: TextStyle(fontSize: 20),),
    );
  }

  Widget _ticketsWidget(){
    return ListView.builder(
      itemBuilder: (context, index) {
        return _createGridViewItem(index ,passenger : _passengerList[index]);
      },
      itemCount: _passengerList.length,
    );
  }

  //单个crad
  Widget _createGridViewItem(int index,{required Passenger passenger}) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: selectList[index],
              onChanged: (value) {
                if (value == false) {
                  _addedPassengers.remove(passenger);
                  setState(() {
                    selectList[index] = value!;
                  });
                } else {
                  if(_addedPassengers.length == 3){
                    Fluttertoast.showToast(msg: '乘员不能超过三人');
                  }else{
                    _addedPassengers.add(passenger);
                    setState(() {
                      selectList[index] = value!;
                    });
                  }
                }

              },
            ),
            Expanded(child: PassengerInfoCard(passenger : passenger))
          ],
        )
    );
  }

  Future<void> _getPassenger() async {
    ResultEntity requestMap = await PassengerApi.getAllPassenger();
    if (requestMap.result) {
      _passengerList.clear();
      _passengerList.addAll(requestMap.data);
      for (int i = 0; i < _passengerList.length; i++) {
        bool have = false;
        for (var element in _addedPassengers) {
          if(element.passengerId == _passengerList[i].passengerId){
            have = true;
          }
        }
          selectList.add(have);
      }
      _loading = false;
    }else{
      Fluttertoast.showToast( msg: requestMap.message);
    }
    setState((){});
  }
}