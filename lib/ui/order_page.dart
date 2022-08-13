import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'order_tips.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('订单'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 8,),
                Row(
                  children:  [
                    const SizedBox(width: 20,),
                    const Text('火车票订单', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20,),),
                    const Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context)
                            .push( MaterialPageRoute(builder: (_) {
                          return const OrderTipsPage();
                        }));
                      },
                      child:  const Text('温馨提示', style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                          color: Colors.blue),
                    )
                   ,),
                    const SizedBox(width: 18,),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8,),
                Row(
                  children: [
                    Expanded(child: _buttonsItem(context,Icons.account_balance_wallet_outlined, '待支付', '/ticket_unpaid')),
                    Expanded(child: _buttonsItem(context,Icons.assignment_outlined, '已支付', 'route')),
                    Expanded(child: _buttonsItem(context,Icons.assignment_turned_in_outlined, '全部订单', 'route')),
                    Expanded(child: _buttonsItem(context,Icons.local_mall_outlined, '我的车票', 'route')),
                  ],
                ),
                const SizedBox(height: 16,)
              ],
            ),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(msg: "待开发");
              },
              child: Image.asset('images/orders_background.jpg'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonsItem(BuildContext context, IconData data, String name, String route) {
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
                Icon(data, color: Colors.blue,size: 34,),
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