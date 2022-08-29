import 'package:flutter/material.dart';
import 'package:train_client_flutter/ui/train_route/route_nonstop.dart';
import 'package:train_client_flutter/ui/train_route/route_transfer.dart';

import '../../util/date_util.dart';

class TrainRouteTabPage extends StatefulWidget{
  final String title;
  final DateTime date;
  final String fromStationId;
  final String toStationId;

  const TrainRouteTabPage({
    Key? key,
    required this.title,
    required this.date,
    required this.fromStationId,
    required this.toStationId
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrainRouteTabState();
}

class _TrainRouteTabState extends State<TrainRouteTabPage>{
  late String title;
  late bool _canBeforeDay;
  late bool _canAfterDay;
  int currentIndex = 0;
  Widget? nostop;
  Widget? transfer;

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
    nostop = RouteNoStopPage(date: _date, fromStationId: fromStationId, toStationId: toStationId,);
    transfer = RouteTransferPage(date: _date, fromStationId: fromStationId, toStationId: toStationId);
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
                  preferredSize: const Size.fromHeight(100),
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
                                    if(currentIndex == 0){
                                      nostop = RouteNoStopPage(
                                          key:UniqueKey(),
                                        date: _date,
                                        fromStationId: fromStationId,
                                        toStationId: toStationId
                                      );
                                    }else{
                                      transfer = RouteTransferPage(
                                          key:UniqueKey(),
                                          date: _date,
                                          fromStationId: fromStationId,
                                          toStationId: toStationId);
                                    }
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
                                      if(currentIndex == 0){
                                        nostop = RouteNoStopPage(
                                            key:UniqueKey(),
                                            date: _date,
                                            fromStationId: fromStationId,
                                            toStationId: toStationId
                                        );
                                      }else{
                                        transfer = RouteTransferPage(
                                            key:UniqueKey(),
                                            date: _date,
                                            fromStationId: fromStationId,
                                            toStationId: toStationId);
                                      }
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
                                    if(currentIndex == 0){
                                      nostop = RouteNoStopPage(
                                          key:UniqueKey(),
                                          date: _date,
                                          fromStationId: fromStationId,
                                          toStationId: toStationId
                                      );
                                    }else{
                                      transfer = RouteTransferPage(
                                          key:UniqueKey(),
                                          date: _date,
                                          fromStationId: fromStationId,
                                          toStationId: toStationId);
                                    }
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
                      Material(
                        child: TabBar(
                          //是否可以横向滚动
                          isScrollable: false,
                          //设置未选中时的字体颜色，tabs里面的字体样式有限级最高
                          unselectedLabelColor: Colors.grey,
                          //设置选中时的字体颜色，tabs里面的字体样式优先级最高
                          labelColor: Colors.blue,
                          //选中下划线的长度，label时跟文字内容长度一样，tab时跟一个Tab的长度一样
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Container(
                              alignment: Alignment.center,
                              height: 46,
                              child: const Text('直达'),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 46,
                              child: const Text('中转'),
                            ),
                          ],
                          onTap: (int index){
                            currentIndex = index;
                            setState((){});
                          },
                        ),
                      ),
                    ],
                  )
              ),
            ),
            body: currentIndex == 0 ? nostop : transfer,
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
