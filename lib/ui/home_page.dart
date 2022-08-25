import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:train_client_flutter/constant.dart';
import 'package:train_client_flutter/widget/cards.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_HomePageState();
}

class _HomePageState extends State<HomePage>{

  @override
  void initState() {
    super.initState();
    if(Constant.allStationList.isNotEmpty){
      Constant.initStationInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(title: const Text('首页'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Stack(
              children: <Widget>[
                Image.asset("images/home_background.png"),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenH * 0.18,),
                const Padding(padding: EdgeInsets.fromLTRB(8, 0, 8, 12),
                  child: RouteSelectCard(),),
                Padding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: SizedBox(height: 190, child: _buttonsGridView())),
                Padding(padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
                  child: Row(
                    children: const [
                      Text('酒店预定',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Expanded(child: SizedBox(width: 10,)),
                      Text('去领券，享更多优惠', style: TextStyle(color: Colors.grey),),
                      Icon(Icons.keyboard_arrow_right, color: Colors.grey,)
                    ],),),
                Padding(padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                    child: SizedBox(height: 840, child: _hohtelsGridView())),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape:  const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "查看更多酒店",
                    textAlign: TextAlign.center,
                  ),
                ),],),
                const SizedBox(height: 20,)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonsGridView(){
    return GridView(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
        ),
        children:<Widget>[
          _buttonsGridViewItem(Icons.event,'车站大屏'),
          _buttonsGridViewItem(Icons.luggage,'行李寄存'),
          _buttonsGridViewItem(Icons.drive_eta,'约车'),
          _buttonsGridViewItem(Icons.support_agent,'客服服务'),
          _buttonsGridViewItem(Icons.payment,'铁路e卡通'),
          _buttonsGridViewItem(Icons.restaurant,'餐饮·特产'),
          _buttonsGridViewItem(Icons.shopping_cart,'铁路商城'),
          _buttonsGridViewItem(Icons.dashboard_customize,'更多服务'),
        ]
    );
  }

  Widget _buttonsGridViewItem(IconData data, String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: () {
          Fluttertoast.showToast(msg: '待开发');
        }, icon: Icon(data, color: Colors.blue,), ),
        Text(name)
      ],
    );
  }

  Widget _hohtelsGridView(){
    return GridView(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children:const <Widget>[
          HotelCard(num: 1),
          HotelCard(num: 2),
          HotelCard(num: 3),
          HotelCard(num: 4),
          HotelCard(num: 5),
          HotelCard(num: 6),
          HotelCard(num: 7),
          HotelCard(num: 8),
        ]
    );
  }
}