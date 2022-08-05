import 'package:flutter/material.dart';
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
          children: const [
            // SizedBox(height: 12,)
            UserCard(userName: '赵炜宁',),
            UserButtonCard(),
            UserServicesCard()
          ],
        ),
      )

    );
  }

}