import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:train_client_flutter/api/api.dart';
import 'package:train_client_flutter/bean/bean.dart';
import 'package:train_client_flutter/ui/login.dart';
import 'package:train_client_flutter/widget/cards.dart';

import '../widget/dialog.dart';
class MinePage extends StatefulWidget{
  const MinePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>MinePageState();

}

class MinePageState extends State<MinePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('我的'), elevation: 0, automaticallyImplyLeading: false),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Color.fromARGB(1, 33, 150, 243),
                  Colors.transparent
                ],
                begin: Alignment.topCenter,
                end: Alignment.center,
              )),
          child: Column(
            children: [
              UserApi.isLogin
                  ? UserCard(user: UserApi.curUser!)
                  : unLoginCard(),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: UserButtonCard(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: userServicesCard(),
              ),

            ],
          ),
        )

    );
  }

  Widget unLoginCard() {
    return GestureDetector(
      child: Container(
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
                  children: const [
                    SizedBox(height: 6,),
                    Text(
                      '未登录',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      textAlign: TextAlign.start,),
                    SizedBox(height: 6,),
                    Text('便捷出行就在12306', style: TextStyle(color: Colors.white),),
                    SizedBox(height: 18,)
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      onTap: () {
        Get.to(() => const LoginPage());
      },
    );
  }

  Widget userServicesCard() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12,),
          const Text('   温馨服务', style: TextStyle(fontSize: 20),),
          const SizedBox(height: 5,),
          const Divider(color: Colors.grey, thickness: 1,),
          userServicesItem('开通会员', () {}),
          userServicesItem('列车查询', () {}),
          userServicesItem('退出登录', _logout),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    if (UserApi.isLogin) {
      bool? delete = await MyDialog.showDeleteConfirmDialog(context: context,
          tips: "确定退出登录吗？");
      if (delete != null) {
        ResultEntity resultEntity = await UserApi.logout();
        if(resultEntity.result){
          setState((){});
        }else{
          Fluttertoast.showToast(msg: resultEntity.message);
        }
      }
    } else {
      Fluttertoast.showToast(msg: '请先登录');
    }
  }

  Widget userServicesItem(String name, void Function()? ontap) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          const SizedBox(height: 12,),
          Row(
            children: [
              Text('   $name', style: const TextStyle(fontSize: 16),),
              const Expanded(child: SizedBox()),
              const Icon(Icons.keyboard_arrow_right)
            ],
          ),
          const SizedBox(height: 12,),
        ],
      ),
    );
  }

}