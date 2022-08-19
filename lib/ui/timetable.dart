import 'package:timelines/timelines.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:train_client_flutter/api/api.dart';

import '../bean/bean.dart';

class TimeTablePage extends StatefulWidget{
  const TimeTablePage({Key? key}) : super(key: key);
  static const routeName = '/timetable';

  @override
  State<StatefulWidget> createState() =>_TimeTableState();

}

class _TimeTableState extends State<TimeTablePage>{
  final TextEditingController _routeController = TextEditingController();
  List<TrainRouteAtom> list = [];
  bool _isOff = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Color.fromARGB(1, 33, 150, 243),
                Colors.transparent
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        // child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _title(),
              _searchCard(),
              Expanded(child: _resultCard())

            ],
          ),
        // )
      ),
    );
  }

  Widget _title(){
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 12,),
          Text('时刻表',style: TextStyle(fontSize: 28, color: Colors.white),),
          Text('轻松安排出行，享受完美旅程',style: TextStyle(fontSize: 12, color: Colors.white))
        ],
      ),
    );
  }

  Widget _searchCard() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(left: 12),
                child: TextField(
                  style: const TextStyle(
                      fontSize: 22
                  ),
                  controller: _routeController,
                  decoration: const InputDecoration(
                    labelText: "车次号",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(10, 26, 10, 0),
                    hintText: "例如: G40",
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.grey,
                      textBaseline: TextBaseline.ideographic,),
                    helperText: '',
                  ),
                ),),
              const SizedBox(height: 3,),
              const Divider(),
              Row(
                children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: ElevatedButton(
                      onPressed: getTrainRouteDetail,
                      child: const Text('详细信息'),
                    ),
                  ))
                ],
              ),
            ],
          ),
        )
    );
  }

  Widget _resultCard() {
    return Offstage(
      offstage: _isOff,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              _timeLineTitle(),
              Expanded(child: Timeline.tileBuilder(
                theme: TimelineThemeData(
                  nodePosition: 0.2
                ),
                builder: TimelineTileBuilder.connectedFromStyle(
                  contentsAlign: ContentsAlign.basic,
                  oppositeContentsBuilder: (context, index) =>
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(list[index].startTime),
                      ),
                  contentsBuilder: (context, index) =>
                      _timeLineRow(list[index]),
                  connectorStyleBuilder: (context,
                      index) => ConnectorStyle.solidLine,
                  indicatorStyleBuilder: (context,
                      index) => IndicatorStyle.dot,
                  itemCount: list.length,
                ),

              ),),
              SizedBox(
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                  Text('滑动查看完整时刻表')
                ],),)
            ],
          )
      ),
    );
  }

  Future<void> getTrainRouteDetail() async {
    if(_routeController.text.length>1 && _routeController.text.length <6){
      ResultEntity resultEntity = await TrainRouteApi.getTrainRouteDetail(_routeController.text);
      if(resultEntity.result){
        list.clear();
        List<TrainRouteAtom> result  = resultEntity.data;
        list.addAll(result);
        _calculateDuration(list);
        if(list.isEmpty){
          Fluttertoast.showToast(msg: '未查询到信息');
        }else{
          setState((){_isOff = false;});
        }
      }else{
        Fluttertoast.showToast(msg: resultEntity.message);
      }
    }else{
      Fluttertoast.showToast(msg: '车次不正确');
    }
  }

  void _calculateDuration(List<TrainRouteAtom> list){
    for(int i = 1; i < list.length; i++){
      list[i].duration = 60 * (int.parse(list[i].arriveTime.substring(0,2))
          - int.parse(list[i-1].startTime.substring(0,2)))
          + (int.parse(list[i].arriveTime.substring(3,5))
          - int.parse(list[i-1].startTime.substring(3,5)));
    }
  }

  Widget _timeLineTitle(){
    int r = 3;
    return Row(
      children: [
        const SizedBox(width: 16,),
        Expanded(flex:r, child: const Text('开点')),
        const Expanded(flex:1, child: Text('')),
        Expanded(flex:r, child: const Text('停靠站')),
        Expanded(flex:r, child: const Text('停留')),
        Expanded(flex:r, child: const Text('到点')),
        Expanded(flex:r, child: const Text('历时')),
      ],
    );
  }

  Widget _timeLineRow(TrainRouteAtom atom){
    return Row(
      children: [
        const SizedBox(width: 20,),
        Expanded(child: Text(atom.stationName)),
        Expanded(child: Text(atom.stopoverTime != 0?'${atom.stopoverTime}分钟':'始发站')),
        Expanded(child: Text(atom.arriveTime)),
        Expanded(child: Text('${atom.duration}分钟')),
      ],
    );
  }
}