import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';
import 'package:train_client_flutter/ui/main_page.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash>{

  @override
  Widget build(BuildContext context) {
    return Material(
      child:  Scaffold(
        body:  Stack(
          children: <Widget>[
             SizedBox(
               width: MediaQuery.of(context).size.width, // 屏幕宽度
               height: MediaQuery.of(context).size.height, // 屏幕高度
               child: Image.asset(
                 "images/cover.jpg",
                 fit: BoxFit.fill,
               ),
             ),
             Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape:  const StadiumBorder(),
                ),
                onPressed: () {
                  newHomePage();
                },
                child: const Text(
                  "跳过",
                  textAlign: TextAlign.center,
                  style:  TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    countDown();
  }

  // 倒计时
  void countDown() {
    var duration =  const Duration(seconds: 5);
     Future.delayed(duration, newHomePage);
  }
  void newHomePage() {
    var routePath = Get.currentRoute;
    if(routePath != MainPage.routeName){
      Navigator.popAndPushNamed(context, MainPage.routeName);
    }
  }
}