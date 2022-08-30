import 'package:flutter/material.dart';
import 'package:train_client_flutter/ui/train_route/route_nonstop.dart';

import '../../bean/bean.dart';
import '../../util/date_util.dart';

class RouteRebookPage extends StatefulWidget{
  final String title;
  final DateTime date;
  final String orderId;
  final String fromStationId;
  final String toStationId;
  final List<PassengerToPay> passengerList;
  final String originalRTainRouteId;

  const RouteRebookPage({
    Key? key,
    required this.title,
    required this.date,
    required this.fromStationId,
    required this.toStationId,
    required this.passengerList,
    required this.orderId,
    required this.originalRTainRouteId
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RouteRebookState();
}

class _RouteRebookState extends State<RouteRebookPage>{
  late String title;
  late bool _canBeforeDay;
  late bool _canAfterDay;
  int currentIndex = 0;
  Widget? nostop;
  late DateTime _date = DateTime.now();
  late String fromStationId;
  late String toStationId;


  @override
  void initState() {
    super.initState();
    _date = widget.date;
    title = widget.title;
    fromStationId = widget.fromStationId;
    toStationId = widget.toStationId;
    _changeDate(_date);
    nostop = RouteNoStopPage(date: _date, fromStationId: fromStationId,
      toStationId: toStationId, isRebook: true,
      passengerList: widget.passengerList,orderId: widget.orderId,
      originalRTainRouteId: widget.originalRTainRouteId,);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text(title),
              centerTitle: true,
              elevation: 5,
              leading: BackButton(onPressed: () {
                Navigator.pop(context);
              }),
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: TextButton(
                                  onPressed: _canBeforeDay
                                      ? () {
                                    _changeDate(_date.subtract(const Duration(days: 1)));
                                    nostop = RouteNoStopPage(
                                        key:UniqueKey(),
                                        date: _date,
                                        fromStationId: fromStationId,
                                        toStationId: toStationId,
                                      isRebook: true,
                                      passengerList: widget.passengerList,
                                      orderId: widget.orderId,
                                      originalRTainRouteId: widget.originalRTainRouteId,
                                    );
                                    setState((){});
                                  }
                                      : null,
                                  child: const Text(
                                    '前一天',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                            Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                                  onPressed: () async {
                                    DateTime? time = await showDatePicker(
                                        context: context,
                                        initialDate: _date.isAfter(DateTime.now())
                                            ? _date
                                            : DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(const Duration(days: 10)));
                                    if (time != null) {
                                      _changeDate(time);
                                        nostop = RouteNoStopPage(
                                            key:UniqueKey(),
                                            date: _date,
                                            fromStationId: fromStationId,
                                            toStationId: toStationId,
                                          isRebook: true,
                                          passengerList: widget.passengerList,
                                          orderId: widget.orderId,
                                          originalRTainRouteId: widget.originalRTainRouteId,
                                        );

                                      setState((){});
                                    }
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                            '${DateUtil.dateMonthAndDay(_date)} (${DateUtil.weekday(_date)})',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontSize: 15)),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        child: Icon(
                                          size: 20,
                                          Icons.calendar_today_rounded,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                                child: TextButton(
                                  onPressed: _canAfterDay
                                      ? () {
                                    _changeDate(_date.add(const Duration(days: 1)));
                                    nostop = RouteNoStopPage(
                                        key:UniqueKey(),
                                        date: _date,
                                        fromStationId: fromStationId,
                                        toStationId: toStationId,
                                      isRebook: true,
                                      passengerList: widget.passengerList,
                                      orderId: widget.orderId,
                                      originalRTainRouteId: widget.originalRTainRouteId,
                                    );
                                    setState((){});
                                  }
                                      : null,
                                  child: const Text(
                                    '后一天',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),
            body: nostop,
          ),
        )
    );
  }

  void _changeDate(DateTime date) {
    DateTime now =
    DateTime.parse(DateTime.now().toIso8601String().substring(0, 10));
    _date = DateTime.parse(_date.toIso8601String().substring(0, 10));
    date = DateTime.parse(date.toIso8601String().substring(0, 10));
    _date = date;
    _canBeforeDay = _date.isAfter(now);
    _canAfterDay = _date.isBefore(now.add(const Duration(days: 10)));
    setState(() {});
  }

}
