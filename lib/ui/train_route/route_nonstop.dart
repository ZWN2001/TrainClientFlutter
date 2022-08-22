import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:train_client_flutter/api/api.dart';
import 'package:train_client_flutter/constant.dart';

import '../../bean/bean.dart';
import '../../widget/cards.dart';

class RouteNoStopPage extends StatefulWidget{
  final DateTime date;
  final String fromStationId;
  final String toStationId;

  const RouteNoStopPage({
    Key? key,
    required this.date,
    required this.fromStationId,
    required this.toStationId
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => RouteNoStopState();
}

class RouteNoStopState extends State<RouteNoStopPage>{
  List<TrainRoute> _trainRouteList = [];
  // final Map<TrainRoute, TicketRouteTimeInfo> _ticketRouteTimeInfoMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _isLoading ?
      const Center(child: CircularProgressIndicator()) : _routeList()
    );
  }

  Widget _routeList() {
    return _trainRouteList.isEmpty ? const Center(child: Text('暂无车次'),)
        : ListView.builder(
      itemBuilder: (context, index) {
        return _routeInfoCard(_trainRouteList[index]);
      },
      itemCount: _trainRouteList.length,
    );
  }

  Future<void> _getData() async {
    ResultEntity resultEntity = await TrainRouteApi.getTrainRoute(
        widget.fromStationId, widget.toStationId, widget.date.day);
    if(resultEntity.result){
      _trainRouteList = resultEntity.data;
      // for (TrainRoute element in _trainRouteList) {
      //   ResultEntity r = await TrainRouteApi.getTrainRouteTimeInfo(
      //       element.trainRouteId, element.fromStationId, element.toStationId);
      //   if(r.result) {
      //     _ticketRouteTimeInfoMap[element] = r.data;
      //   }
      // }
      _isLoading = false;
      setState((){});
    }else{
      Fluttertoast.showToast(msg: resultEntity.message);
    }
  }

  Widget _routeInfoCard(TrainRoute route){
    double size = 26;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(route.startTime, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        route.formIsStart ? PassStartEndIcon.stationStartIcon(size) : PassStartEndIcon.stationPassIcon(size),
                        Text(Constant.stationIdMap[route.fromStationId]!.stationName, style: const TextStyle(fontSize: 16),)
                      ],
                    )

                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text(route.trainRouteId, style: const TextStyle(fontSize: 18)),
                    const ImageIcon(AssetImage('icons/arrow.png'),size: 26,color: Colors.blue,),
                    Text('历时 ${route.durationInfo}',style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(route.arriveTime, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        route.toIsEnd ? PassStartEndIcon.stationEndIcon(size) : PassStartEndIcon.stationPassIcon(size),
                        Text(Constant.stationIdMap[route.toStationId]!.stationName, style: const TextStyle(fontSize: 16),)
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}