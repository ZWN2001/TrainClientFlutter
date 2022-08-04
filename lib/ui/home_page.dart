import 'package:flutter/material.dart';
import 'package:train_client_flutter/widget/cards.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_HomePageState();

}

class _HomePageState extends State<HomePage>{
  final Image _background = Image.asset("images/home_background.jpg");

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(title: const Text('首页'),),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Stack(
              children: <Widget>[
                _background,
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.lerp(
                          Alignment.topCenter, Alignment.center, 0.55)!,
                      end: Alignment.lerp(
                          Alignment.topCenter, Alignment.center, 0.7)!,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.6),
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.8),
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(1.0),
                        Colors.white.withOpacity(1.0),
                        Colors.white.withOpacity(1.0),
                        Colors.white.withOpacity(1.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenH * 0.18,),
                const Padding(padding: EdgeInsets.fromLTRB(8, 0, 8, 12),
                  child: RouteCard(),),
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
        IconButton(onPressed: () {}, icon: Icon(data, color: Colors.blue,), ),
        Text(name)
      ],
    );
  }
}