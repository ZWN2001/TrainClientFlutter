import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:train_client_flutter/constant.dart';

import '../bean/bean.dart';

class RouteCard extends StatefulWidget{
  const RouteCard({Key? key}) : super(key: key);

  @override
  RouteCardState createState() =>RouteCardState();
}

class RouteCardState extends State<RouteCard>{
   String _fromStation = '未知1';
   String _toStation = '未知2';
   final DateTime _date = DateTime.now();
   double sideMargin = 12;

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
              const SizedBox(width: 16,),
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
              const SizedBox(width: 16,),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 24,),
              //TODO:日期处理
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
              const SizedBox(width: 24,),
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
              const SizedBox(width: 24,),
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
              fontSize: 25,
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
  const HotelCard({Key? key, required this.num}) : super(key: key);
  final int num;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: GestureDetector(
        child: Card(
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'images/hotel$num.jpg',
                      fit: BoxFit.fitHeight,
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 2, 6, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Constant.hotelNameList[num - 1], maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                        const SizedBox(height: 6,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text('${Constant.hotelMarks[num - 1]}',
                              style: const TextStyle(fontSize: 17, color: Colors
                                  .blue, fontWeight: FontWeight.bold),),
                            const Text(
                              "分", style: TextStyle(fontSize: 11, color: Colors
                                .blue),),
                            const SizedBox(width: 12,),
                            const Text(
                              '￥', style: TextStyle(fontSize: 11, color: Colors
                                .red, fontWeight: FontWeight.bold),),
                            Text("${Constant.price[num - 1]}",
                              style: const TextStyle(fontSize: 19, color: Colors
                                  .red, fontWeight: FontWeight.bold),),
                            const SizedBox(width: 2,),
                            const Text(
                              '起', style: TextStyle(fontSize: 11, color: Colors
                                .grey, fontWeight: FontWeight.bold),),
                            const SizedBox(width: 6,),
                            Text('￥${Constant.originPrice[num - 1]}',
                              style: const TextStyle(fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey),),
                          ],),
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
        onTap: (){
          Fluttertoast.showToast(msg: '待开发');
        },
      )
    );
  }

}

class UserCard extends StatelessWidget{
  const UserCard({Key? key, required this.userName}) : super(key: key);
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8,),
          Row(
            children: [
              const SizedBox(width: 14,),
              SizedBox(width: 64,
                  child: ClipOval(
                    child: Image.asset('images/default_head.jpg'),)),
              const SizedBox(width: 14,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6,),
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                    textAlign: TextAlign.start,),
                  const SizedBox(height: 4,),
                  Row(
                    children: [
                    SizedBox(height: 22, child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: Container(
                          color: Colors.white,
                          child: Padding(padding: const EdgeInsets.fromLTRB(
                              8, 0, 4, 0),
                            child: Row(children: const [
                              Text('手机核验成功', style: TextStyle(fontSize: 12),),
                              Icon(Icons.check_circle, color: Colors.green,
                                size: 18,)
                            ]
                            ),
                          )
                      ),
                    )),
                    const SizedBox(width: 8,),
                    SizedBox(height: 22, child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: Container(
                          color: Colors.white,
                          child: Padding(padding: const EdgeInsets.fromLTRB(
                              8, 0, 4, 0),
                            child: Row(
                                children: const [
                                  Text(
                                    '已实名认证', style: TextStyle(fontSize: 12),),
                                  Icon(Icons.check_circle, color: Colors.green,
                                    size: 18,)
                                ]
                            ),
                          )
                      ),
                    )),
                  ],),
                  const SizedBox(height: 18,)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class UserButtonCard extends StatelessWidget{
  const UserButtonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          Expanded(child: _imageButtonsItem(const ImageIcon(AssetImage('icons/passenger.png')), '乘车人', 'route')),
          Expanded(child: _buttonsItem(const Icon(Icons.pending_actions_outlined, size: 28,), '时刻表', 'route')),
          Expanded(child: _buttonsItem(const Icon(Icons.confirmation_num_outlined, size: 28,), '优惠券', 'route'))
        ],
      ),),
    );
  }

  Widget _buttonsItem(Icon icon, String name, String route) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
            onPressed: () {
              //TODO
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(width: 0, color: Colors.transparent),
            ),
            child: Column(
              children: [
                const SizedBox(height: 4,),
                icon,
                // Icon(data, color: Colors.blue,size: 34,),
                const SizedBox(height: 4,),
                Text(name,style: const TextStyle(color: Colors.black,fontSize: 16),),
                const SizedBox(height: 4,),
              ],
            )
        )
      ],
    );
  }

  Widget _imageButtonsItem(ImageIcon icon, String name, String route) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
            onPressed: () {
              //TODO
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(width: 0, color: Colors.transparent),
            ),
            child: Column(
              children: [
                const SizedBox(height: 4,),
                icon,
                // Icon(data, color: Colors.blue,size: 34,),
                const SizedBox(height: 4,),
                Text(name,style: const TextStyle(color: Colors.black,fontSize: 16),),
                const SizedBox(height: 4,),
              ],
            )
        )
      ],
    );
  }
}

class UserServicesCard extends StatelessWidget{
  const UserServicesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('温馨服务',style: TextStyle(fontSize: 20),),
            const Divider(color: Colors.grey,),
            userServicesItem('列车查询',''),
            const Divider(color: Colors.grey,),
            userServicesItem('列车查询',''),
            const Divider(color: Colors.grey,),
            userServicesItem('列车查询',''),

          ],
        ),
      )
    );
  }

  Widget userServicesItem(String name,String route){
    return  GestureDetector(
      child: Row(
        children: [
          Text(name,style: const TextStyle(fontSize: 16),),
          const Expanded(child: SizedBox()),
          const Icon(Icons.keyboard_arrow_right)
        ],

      ),
      onTap: (){
        //TODO
      },
    );
  }

}

class PassengerCard extends StatelessWidget{
  const PassengerCard({Key? key, required this.passenger}) : super(key: key);
  final PassengerToPay passenger;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(passenger.passengerName,
                        style: const TextStyle(fontSize: 18),),
                      const SizedBox(width: 8,),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.circular(3), // 圆角
                        ),
                        child: Padding(padding: const EdgeInsets.only(
                            left: 4, right: 4, bottom: 2),
                          child: Text(
                            passenger.role == 'common' ? '成人票' : '学生票',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.blue),),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Text('￥${passenger.price}',style: const TextStyle(color: Colors.deepOrange,fontSize: 18),)
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      const Text('中国居民身份证', style: TextStyle(color: Colors.grey,fontSize: 16),),
                      const Expanded(child: SizedBox()),
                      Padding(padding: const EdgeInsets.only(top: 4),
                        child: Text(passenger.passengerId, style: const TextStyle(fontSize: 16),),
                      )
                    ],
                  )
                ],
              ),
            )
        )
    );
  }
}

class TicketPaiedCard extends StatelessWidget{
  const TicketPaiedCard({Key? key, required this.orderGeneral}) : super(key: key);

  final OrderGeneral orderGeneral;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('订单号:  ${orderGeneral.orderId}'),
              const Divider(),
              const SizedBox(height: 8,),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('出发站',
                        style: TextStyle(fontSize: 18),),
                      const SizedBox(height: 4,),
                      Text(orderGeneral.fromStationId,
                        style: const TextStyle(fontSize: 24),),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Column(
                    children: [
                      Text(orderGeneral.trainRouteId, style: const TextStyle(fontSize: 18)),
                      const ImageIcon(AssetImage('icons/arrow.png'),size: 26,color: Colors.blue,),
                      Text('发车时间：${orderGeneral.departureDate}',style: const TextStyle(color: Colors.grey),),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('目的站',
                        style: TextStyle(fontSize: 18),),
                      const SizedBox(height: 4,),
                      Text(orderGeneral.toStationId,
                        style: const TextStyle(fontSize: 24),),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12,),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                        child: const Text('详细信息'),
                        onPressed: (){

                        },
                      ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  
}
