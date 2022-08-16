import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_client_flutter/api/api.dart';
import 'package:train_client_flutter/ui/login.dart';
import 'package:train_client_flutter/widget/cards.dart';
class MinePage extends StatefulWidget{
  const MinePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>MinePageState();

}

class MinePageState extends State<MinePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的'),),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Color.fromARGB(1, 33, 150, 243),Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.center,
            )),
        child: Column(
          children:  [
            UserApi.isLogin ? UserCard(user: UserApi.curUser!):unLoginCard(),
            const UserButtonCard(),
            const UserServicesCard()
          ],
        ),
      )

    );
  }

  Widget unLoginCard(){
    return GestureDetector(
      child: Container(
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
                  children: const [
                    SizedBox(height: 6,),
                    Text(
                      '未登录',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      textAlign: TextAlign.start,),
                    SizedBox(height: 6,),
                    Text('便捷出行就在12306',style: TextStyle( color: Colors.white),),
                    SizedBox(height: 18,)
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      onTap: (){
        Get.to(() => const LoginPage());
      },
    );
  }

}