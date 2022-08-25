import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:train_client_flutter/constant.dart';
import 'package:train_client_flutter/ui/order/order_detail.dart';
import 'package:train_client_flutter/ui/order/order_unpaied.dart';
import 'package:train_client_flutter/ui/passenger/passenger_edit.dart';
import 'package:train_client_flutter/util/utils.dart';

import '../bean/bean.dart';
import '../ui/station_page.dart';
import '../ui/train_route/tab.dart';

class RouteSelectCard extends StatefulWidget{
  const RouteSelectCard({Key? key}) : super(key: key);

  @override
  RouteSelectCardState createState() =>RouteSelectCardState();
}

class RouteSelectCardState extends State<RouteSelectCard>{
   Station _fromStation = Station.name(stationName: '未选择');
   Station _toStation = Station.name(stationName: '未选择');
   DateTime _date = DateTime.now();
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
              _stationButton(isFromStation: true),
              const Expanded(child: SizedBox()),
              IconButton(
                color:Colors.blue,
                iconSize: 28,
                icon: const Icon(Icons.published_with_changes),
                onPressed: () {
                  Station t = _fromStation;
                  _fromStation = _toStation;
                  _toStation = t;
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
              const Expanded(child: SizedBox()),
              _stationButton(isFromStation: false),
              const SizedBox(width: 16,),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 24,),
              GestureDetector(
                child: Text(
                  _timeFormat(_date),
                  style: const TextStyle(fontSize: 22, color: Colors.black),),
                onTap: () async {
                   var res =  await showDatePicker(
                    context: context,
                    initialDate: _date,
                    // 初始化选中日期
                    firstDate: DateTime.now(),
                    // 开始日期
                    lastDate: DateTime(2022,10,1),
                    // 结束日期
                    textDirection: TextDirection.ltr,
                    // 文字方向
                    currentDate: DateTime.now(),
                    // 当前日期
                    // helpText: "helpText",
                    // 左上方提示
                    cancelText: "取消",
                    // 取消按钮文案
                    confirmText: "确认",
                    // 确认按钮文案
                    errorFormatText: "格式错误",
                    // 格式错误提示
                    errorInvalidText: "超出允许日期范围",
                    // 输入不在 first 与 last 之间日期提示

                    fieldLabelText: "日期输入",
                    // 输入框上方提示
                    fieldHintText: "输入为空",
                    // 输入框为空时内部提示
                    initialDatePickerMode: DatePickerMode.day,
                    // 日期选择模式，默认为天数选择
                    useRootNavigator: true,
                  );
                   if(res != null){
                     if(mounted){
                       setState((){_date = res;});
                     }
                   }
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
                      if(_fromStation.stationName == '未选择'
                          || _toStation.stationName == '未选择'){
                        Fluttertoast.showToast(msg: '请选择出发地及目的地');
                      }else{
                        Get.to(()=>TrainRouteTabPage(
                          fromStationId: _fromStation.stationId,
                          toStationId: _toStation.stationId,
                          date: _date,
                          title: '${_fromStation.stationName}<>${_toStation.stationName}',
                        ));
                      }
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

  Widget _stationButton({required bool isFromStation}){
     return TextButton(
        child: Text(isFromStation? _fromStation.stationName : _toStation.stationName,
          style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold),),
        onPressed: () async {
          Station? stationResult = await Get.to(() => const StationPage());
          if (stationResult != null) {
            if(isFromStation){
              setState(() {
                _fromStation = stationResult;
              });
            }else{
              setState(() {
                _toStation = stationResult;
              });
            }
          }
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
  const UserCard({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8,),
          Row(
            children: [
              const SizedBox(width: 18,),
              SizedBox(width: 64,
                  child: ClipOval(
                    child: Image.asset('images/default_head.jpg'),)),
              const SizedBox(width: 14,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6,),
                  Text(
                    user.userName!,
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
                                8, 1, 8, 0),
                              child: Text(user.role == 'common'?'普通会员':'VIP会员',
                                style: const TextStyle(fontSize: 12),),
                            )
                        ),
                      )),
                      const SizedBox(width: 8,),
                    SizedBox(height: 22, child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: Container(
                          color: Colors.white,
                          child: Padding(padding: const EdgeInsets.fromLTRB(
                              8, 0, 4, 1),
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
                              8, 0, 4, 1),
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
          Expanded(child: _imageButtonsItem(context, const ImageIcon(AssetImage('icons/passenger.png')), '乘员列表', '/my_passenger')),
          Expanded(child: _buttonsItem(context, const Icon(Icons.pending_actions_outlined, size: 28,), '时刻表', '/timetable')),
          Expanded(child: _buttonsItem(context, const Icon(Icons.confirmation_num_outlined, size: 28,), '优惠券', 'route'))
        ],
      ),),
    );
  }

  Widget _buttonsItem(BuildContext context, Icon icon, String name, String route) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, route);
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

  Widget _imageButtonsItem(BuildContext context, ImageIcon icon, String name, String route) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, route);
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

class OrderPassengerCard extends StatelessWidget{
  const OrderPassengerCard({Key? key, required this.passenger}) : super(key: key);
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
                      Text('${Constant.seatIdToTypeMap[passenger.seatTypeId.toString()]}  ￥${passenger.price}',//TODO
                        style: const TextStyle(color: Colors.deepOrange,fontSize: 18),)
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

class OrderPassengerWithSeatInfoCard extends StatelessWidget{
  const OrderPassengerWithSeatInfoCard({Key? key, required this.passenger, required this.carriageId, required this.seat}) : super(key: key);
  final PassengerToPay passenger;
  final int carriageId;
  final int seat;

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
                      Text('${Constant.seatIdToTypeMap[passenger.seatTypeId]}  ￥${passenger.price}',//TODO
                        style: const TextStyle(color: Colors.deepOrange,fontSize: 18),)
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
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      Text('车厢号：$carriageId', style: const TextStyle(fontSize: 16),),
                      const SizedBox(width: 16,),
                      Text('座位编号：$carriageId', style: const TextStyle(fontSize: 16),),
                    ],
                  ),
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
                        style: TextStyle(fontSize: 16),),
                      const SizedBox(height: 4,),
                      Text(Constant.stationIdMap[orderGeneral.fromStationId]!.stationName,
                        style: const TextStyle(fontSize: 21),),
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
                        style: TextStyle(fontSize: 16),),
                      const SizedBox(height: 4,),
                      Text(Constant.stationIdMap[orderGeneral.toStationId]!.stationName,
                        style: const TextStyle(fontSize: 21),),
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
                          Get.to(()=>OrderDetailPage(orderId: orderGeneral.orderId));
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

class AllTicketCard extends StatelessWidget{
  const AllTicketCard({Key? key, required this.orderGeneral}) : super(key: key);

  final OrderGeneral orderGeneral;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                color: getColor(orderGeneral.orderStatus),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                    child: Row(
                      children: [
                        Text('订单号:  ${orderGeneral.orderId}',
                          style: const TextStyle(color: Colors.white),),
                        const SizedBox(width: 12,),
                        Text('订单状态:  ${orderGeneral.orderStatus}',
                          style: const TextStyle(color: Colors.white),)
                      ],
                    )
                ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('出发站',
                        style: TextStyle(fontSize: 15),),
                      const SizedBox(height: 4,),
                      Text(Constant.stationIdMap[orderGeneral.fromStationId]!.stationName,
                        style: const TextStyle(fontSize: 21),),
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
                        style: TextStyle(fontSize: 15),),
                      const SizedBox(height: 4,),
                      Text(Constant.stationIdMap[orderGeneral.toStationId]!.stationName,
                        style: const TextStyle(fontSize: 21),),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: const Text('详细信息'),
                      onPressed: (){
                        if(orderGeneral.orderStatus == '未支付'){
                          Get.to(()=>const OrderUnpaiedPage());
                        }else{
                          Get.to(()=>OrderDetailPage(orderId: orderGeneral.orderId));
                        }
                      },
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Color getColor(String status){
    switch (status){
      case OrderStatus.CANCEL:
        return Colors.orange;
      case OrderStatus.TIMEOUT:
        return Colors.red;
      case OrderStatus.UN_PAY:
        return Colors.amberAccent;
      case OrderStatus.PAIED:
        return Colors.green;
      case OrderStatus.REFUNDED:
        return Colors.deepPurpleAccent;
      default:
        return Colors.blue;

    }
  }

}

class PassengerInfoCard extends StatelessWidget{
  const PassengerInfoCard({Key? key, required this.passenger}) : super(key: key);
  final Passenger passenger;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      child: Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(passenger.passengerName, style: const TextStyle(
                              color: Colors.green, fontSize: 18),),
                          const SizedBox(width: 16,),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(3), // 圆角
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, bottom: 2),
                              child: Text(
                                passenger.role == 'common' ? '成人' : '学生',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height:12,),
                      Text(IDUtil.getObscureID(passenger.passengerId,),
                          style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  const Icon(Icons.edit)
                ],
              )
          ),
        ),
      onTap: (){
        Navigator.of(context)
            .push( MaterialPageRoute(builder: (_) {
          return PassengerEditPage(passenger: passenger);
        }));
      },
    );
  }
}

///是经停还是始终
class PassStartEndIcon{
  static const double textSize = 12;
  static Widget stationPassIcon(double size){
    return SizedBox(
      width: size,
      height: size,
      child: const Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))
        ),
        color: Colors.blueAccent,
        child: Center(
          child: Text('过', style: TextStyle(color: Colors.white,fontSize: textSize)),
        ),
      ),
    );
  }

  static Widget stationStartIcon(double size){
    return SizedBox(
      width: size,
      height: size,
      child: const Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))
        ),
        color: Colors.orange,
        child: Center(
          child: Text('始', style: TextStyle(color: Colors.white,fontSize: textSize)),
        ),
      ),
    );
  }

  static Widget stationEndIcon(double size){
    return SizedBox(
      width: size,
      height: size,
      child: const Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))
        ),
        color: Colors.green,
        child: Center(
          child: Text('终', style: TextStyle(color: Colors.white,fontSize: textSize)),
        ),
      ),
    );
  }
}
