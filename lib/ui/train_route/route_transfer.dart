import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../api/api.dart';
import '../../bean/bean.dart';
import '../../constant.dart';
import '../../util/date_util.dart';
import '../../widget/cards.dart';
import '../login.dart';
import '../order/order_confirm.dart';
import '../order/order_confirm_transfer.dart';

  class RouteTransferPage extends StatefulWidget {
    final DateTime date;
    final String fromStationId;
    final String toStationId;

    const RouteTransferPage({
      Key? key,
      required this.date,
      required this.fromStationId,
      required this.toStationId
    }) : super(key: key);

    @override
    State<StatefulWidget> createState() => RouteTransferState();
  }

  class RouteTransferState extends State<RouteTransferPage> {
    TrainRouteTransfer t = TrainRouteTransfer.fromJson({});
    List<TrainRouteTransfer> _trainRouteList = [];
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
          body: _isLoading ?
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
      ResultEntity resultEntity = await TrainRouteApi.getTrainRouteTransfer(
          widget.fromStationId, widget.toStationId, DateUtil.date(widget.date));
      if (resultEntity.result) {
        _trainRouteList = resultEntity.data;
        _trainRouteList.sort((a, b) => a.startTimeFrom.compareTo(b.startTimeFrom));
        _isLoading = false;
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: resultEntity.message);
      }
    }

    Widget _routeInfoCard(TrainRouteTransfer route) {
      return GestureDetector(
        onTap: () {
          if (UserApi.isLogin) {
            Get.to(() =>
                OrderConfirmTransferPage(route: route, departureDate: widget.date,));
          } else {
            Get.to(() => const LoginPage());
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(route.startTimeFrom, style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),),
                        Text(" ${Constant.stationIdMap[route.fromStationId]!.stationName}", style: const TextStyle(
                            fontSize: 17),)
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    Column(
                      children: [
                        Text('${route.arriveTimeTrans}到达',
                            style: const TextStyle(fontSize: 13, color: Colors.blue)),
                        const ImageIcon(AssetImage('icons/arrow.png'), size: 26,
                          color: Colors.blue,),
                        Text(route.trainRouteId1,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    Column(
                      children: [
                        Text(Constant.stationIdMap[route.transStationId]!.stationName,style: const TextStyle(fontSize: 16),),
                        const SizedBox(height: 7,),
                        Text('同站换乘\n${getDurationString(route.durationTransfer)}',
                            style: const TextStyle(color: Colors.grey,fontSize: 13)),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    Column(
                      children: [
                        Text('${route.startTimeTrans}出发',
                            style: const TextStyle(fontSize: 13, color: Colors.blue)),
                        const ImageIcon(AssetImage('icons/arrow.png'), size: 26,
                          color: Colors.blue,),
                        Text(route.trainRouteId2,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(route.arriveTimeTo, style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),),
                        Text("${Constant.stationIdMap[route.toStationId]!.stationName} ", style: const TextStyle(
                            fontSize: 17),)
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(child: Text('第一程'),),
                    ...route.ticketsFirst.keys.map((e) =>
                        Expanded(
                            child: Text(
                                '${Constant.seatIdToTypeMap[e.toString()]}:${route
                                    .ticketsFirst[e]}张')
                        )
                    ).toList(),
                  ]
                ),
                const SizedBox(height: 3,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(child: Text('第二程'),),
                    ...route.ticketsNext.keys.map((e) =>
                        Expanded(
                            child: Text(
                                '${Constant.seatIdToTypeMap[e.toString()]}:${route
                                    .ticketsNext[e]}张')
                        )
                    ).toList(),
                  ]
                ),
              ],
            ),
          ),
        ),
      );
    }

    String getDurationString(int duration){
      if(duration > 60){
        return '${duration % 60}时${duration ~/ 60}分';
      }else{
        return '$duration分';
      }
    }

  }