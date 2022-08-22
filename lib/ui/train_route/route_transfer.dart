import 'package:flutter/material.dart';

import '../../bean/bean.dart';
import '../../widget/cards.dart';


class RouteTransferPage extends StatefulWidget{
  const RouteTransferPage({Key? key, required this.date}) : super(key: key);
  final DateTime date;

  @override
  State<StatefulWidget> createState() => RouteTransferState();

}

class RouteTransferState extends State<RouteTransferPage>{
  TrainRoute trainRoute = TrainRoute.fromJson({});
  TicketRouteTimeInfo timeInfo = TicketRouteTimeInfo.fromJson({});
  List<TrainRoute> trainRouteList = [];
  List<TicketRouteTimeInfo> ticketRouteTimeInfoList = [];

  @override
  void initState() {
    super.initState();
    trainRouteList.add(trainRoute);
    ticketRouteTimeInfoList.add(timeInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: ListView.builder(
            itemBuilder: (index,context){
              return const RouteSelectCard();
            },
            itemCount: 0,
          )
      ),
    );
  }

}