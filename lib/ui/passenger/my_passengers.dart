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
  bool _loading = true;
  List<bool> selectList = [];
  late List<Passenger> passengerList = [];
  List<Passenger> deletePassengers = []; //要删除的ID数组
  bool _isOff = true; //相关组件显示隐藏控制，true代表隐藏
  bool _checkValue = false; //总的复选框控制开关
  String deleteButtonName = '选择删除';

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
        Offstage(
        offstage: !_isOff,
          child: TextButton(
              onPressed: () async {
                Passenger? p = await Get.to(() => const AddPassengerPage());
                if(p != null){
                  passengerList.add(p);
                  selectList.add(false);
                  if(mounted){setState((){});}
                }
              },
              child: const Text('添加',
                style: TextStyle(fontSize: 16, color: Colors.white),)),
        ),
          TextButton(
              onPressed: () {
                for (int i = 0; i <selectList.length;i++) {
                  selectList[i] = false; //列表设置为未选中
                }
                deletePassengers = []; //重置
                if(mounted){
                  setState(() {
                    _isOff = !_isOff; //显示隐藏总开关
                    _checkValue = false; //所选框设置为未选中
                  });
                }
              },
              child: Text(deleteButtonName,
                style: const TextStyle(fontSize: 16, color: Colors.white),))
        ],),
      body: _loading?const Center(child: CircularProgressIndicator()) : mainContent()
    );
  }

  Widget mainContent() {
    if (passengerList.isEmpty) {
      return _noTicketWidget();
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            _ticketsWidget(),
            _getItemBottom(),
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
        return _createGridViewItem(index ,passenger : passengerList[index]);
      },
      itemCount: passengerList.length,
    );
  }

  //底部操作样式
  Widget _getItemBottom() {
    return Offstage(
      offstage: _isOff,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Container(
            height: 40,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _checkValue,
                      onChanged: (value) {
                        _selectAll(value);
                      },
                    ),
                    const Text('全选'),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      child: const Text('取消',style: TextStyle(fontSize: 16),),
                      onTap: (){
                        if(mounted){setState((){  _isOff = true;});}
                      },
                    ),
                    const SizedBox(width: 24,),
                    InkWell(
                      child: const Text('删除',style: TextStyle(fontSize: 16),),
                      onTap: (){
                        _delete(deletePassengers);
                      },
                    ),
                    const SizedBox(width: 16,),
                  ],
                )
              ],
            )),
      ),
    );
  }

  //单个crad
  Widget _createGridViewItem(int index,{required Passenger passenger}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
      child: Row(
        children: <Widget>[
          Offstage(
            offstage: _isOff,
            child: Checkbox(
              value: selectList[index],
              onChanged: (value) {
                if (value == false) {
                  deletePassengers.remove(passenger);
                } else {
                  deletePassengers.add(passenger);
                }
                setState(() {
                  selectList[index] = value!;
                });
              },
            ),
          ),
          Expanded(child: PassengerInfoCard(passenger : passenger))
        ],
      )
    );
  }

  Future<void> _getPassenger() async {
    ResultEntity requestMap = await PassengerApi.getAllPassenger();
    if (requestMap.result) {
      passengerList.clear();
      passengerList.addAll(requestMap.data);
      _initSelectList();
      _loading = false;
    }else{
      Fluttertoast.showToast( msg: requestMap.message);
    }
    setState((){});
  }

  void _initSelectList(){
    for (int i = 0; i <passengerList.length;i++) {
      selectList.add(false);
    }
  }

  //底部复选框的操作逻辑
  _selectAll(value) {
    deletePassengers = []; //要删除的数组ID重置
    for(int i = 0;i<selectList.length;i++) {
      selectList[i] = value;
      if (value == true) {
        deletePassengers.add(passengerList[i]);
      }
    }

    if(mounted){
      setState(() {
        _checkValue = value;
      });
    }
  }

  Future<void> _delete(List<Passenger> deletePassengers) async {
    bool? delete = await _showDeleteConfirmDialog();
    if (delete != null) {
      if(deletePassengers.isEmpty){
        Fluttertoast.showToast(msg: '请选择乘员');
      }else{
        for(Passenger p in deletePassengers){
          await PassengerApi.deletePassenger(p);
        }
        _isOff = true;
        if(mounted){setState((){});}
      }
    }
  }

  Future<bool?> _showDeleteConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text("您确定要删除该乘员吗?\n该操作会同时删除该乘员的订票记录"),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(), //关闭对话框
            ),
            TextButton(
              child: const Text("删除"),
              onPressed: () {
                Navigator.of(context).pop(true); //关闭对话框
              },
            ),
          ],
        );
      },
    );
  }

}