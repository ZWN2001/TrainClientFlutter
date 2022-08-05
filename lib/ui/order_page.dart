import 'package:flutter/material.dart';

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
                  children: const [
                    SizedBox(width: 20,),
                    Text('火车票订单', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20,),),
                    Expanded(child: SizedBox()),
                    Text('温馨提示', style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        color: Colors.blue),),
                    SizedBox(width: 18,),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8,),
                Row(
                  children: [
                    Expanded(child: _buttonsItem(Icons.account_balance_wallet_outlined, '待支付', 'route')),
                    Expanded(child: _buttonsItem(Icons.assignment_outlined, '已支付', 'route')),
                    Expanded(child: _buttonsItem(Icons.assignment_turned_in_outlined, '全部订单', 'route')),
                    Expanded(child: _buttonsItem(Icons.local_mall_outlined, '我的车票', 'route')),
                  ],
                ),
                const SizedBox(height: 16,)
              ],
            ),
            const SizedBox(height: 10,),
            Image.asset('images/orders_background.jpg'),
          ],
        ),
      ),
    );
  }

  Widget _buttonsItem(IconData data, String name, String route) {
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