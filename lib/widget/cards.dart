import 'package:flutter/material.dart';

class RouteCard extends StatefulWidget{
  const RouteCard({Key? key}) : super(key: key);

  @override
  RouteCardState createState() =>RouteCardState();
}

class RouteCardState extends State<RouteCard>{
   String _fromStation = '未知1';
   String _toStation = '未知2';
   final DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),),
      child: Column(
        children: [
          const SizedBox(height: 12,),
          Row(
            children: [
              const SizedBox(width: 8,),
              _stationButton(_fromStation),
              const Expanded(child: SizedBox()),
              IconButton(
                color:Colors.blue,
                iconSize: 28,
                icon: const Icon(Icons.published_with_changes),
                onPressed: () {
                  String t = _fromStation;
                  _fromStation = _toStation;
                  _toStation = t;
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
              const Expanded(child: SizedBox()),
              _stationButton(_toStation),
              const SizedBox(width: 8,),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 16,),
              GestureDetector(
                child: Text(
                  _timeFormat(_date),
                  style: const TextStyle(fontSize: 22, color: Colors.black),),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    // 初始化选中日期
                    firstDate: DateTime(2020, 6),
                    // 开始日期
                    lastDate: DateTime(2021, 6),
                    // 结束日期
                    textDirection: TextDirection.ltr,
                    // 文字方向
                    currentDate: DateTime(2020, 10, 20),
                    // 当前日期
                    helpText: "helpText",
                    // 左上方提示
                    cancelText: "cancelText",
                    // 取消按钮文案
                    confirmText: "confirmText",
                    // 确认按钮文案
                    errorFormatText: "errorFormatText",
                    // 格式错误提示
                    errorInvalidText: "errorInvalidText",
                    // 输入不在 first 与 last 之间日期提示

                    fieldLabelText: "fieldLabelText",
                    // 输入框上方提示
                    fieldHintText: "fieldHintText",
                    // 输入框为空时内部提示

                    initialDatePickerMode: DatePickerMode.day,
                    // 日期选择模式，默认为天数选择
                    useRootNavigator: true,
                    // 是否为根导航器
                    // 设置不可选日期，这里将 2020-10-15，2020-10-16，2020-10-17 三天设置不可选
                    // selectableDayPredicate: (dayTime) {
                    //   if (dayTime == DateTime(2020, 10, 15) ||
                    //       dayTime == DateTime(2020, 10, 16) ||
                    //       dayTime == DateTime(2020, 10, 17)) {
                    //     return false;
                    //   }
                    //   return true;
                    // },
                  );
                }
              ),
              const SizedBox(width: 4,),
              Padding(padding: const EdgeInsets.only(bottom: 2),
                  child: Text(_weekDayFormat(_date)),)
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              const SizedBox(width: 16,),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    child: const Text('查询车票',style: TextStyle(fontSize: 20),),
                    onPressed: () {
                      //TODO:查询
                    },
                  ),
                )
              ),
              const SizedBox(width: 16,),
            ],
          ),
          const SizedBox(height: 12,),
        ],
      ),
    );
  }

  Widget _stationButton(String station){
     return TextButton(
        child: Text(station,
          style: const TextStyle(
              fontSize: 28,
              color: Colors.black,
              fontWeight: FontWeight.bold),),
        onPressed: (){
           //TODO:跳转并处理返回值
        },
     );
  }

  String _timeFormat(DateTime date){
    return '${int.parse(date.month.toString())}月${int.parse(date.day.toString())}日';
  }

  String _weekDayFormat(DateTime date){
    String day = '一';
    switch (date.weekday){
      case 1 : day = '一';break;
      case 2 : day = '二';break;
      case 3 : day = '三';break;
      case 4 : day = '四';break;
      case 5 : day = '五';break;
      case 6 : day = '六';break;
      case 7 : day = '日';break;
    }
    return '周$day';
  }
}

class HotelCard extends StatelessWidget{
  const HotelCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(

    );
  }

}