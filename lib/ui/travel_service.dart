import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TravelService extends StatelessWidget{
  const TravelService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('出行服务'), automaticallyImplyLeading: false),
      body: GestureDetector(
        child: Image.asset('images/travel_service.jpg'),
        onTap: (){
          Fluttertoast.showToast(msg: '待开发');
        },
      ),
    );
  }
}