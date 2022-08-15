import 'package:flutter/material.dart';
import 'package:train_client_flutter/ui/home_page.dart';
import 'package:train_client_flutter/ui/mine_page.dart';
import 'package:train_client_flutter/ui/order_page.dart';
import 'package:train_client_flutter/ui/travel_service.dart';

class MainPage extends StatefulWidget{
  const MainPage({Key? key}) : super(key: key);
  static const routeName = '/main_page';

  @override
  State<StatefulWidget> createState() =>_MainPageState();

}
class _MainPageState extends State<MainPage>{

  final List<BottomNavigationBarItem> bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.subway_outlined),
      label: "首页",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.work_outline),
      label: "出行服务",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.format_align_left_outlined),
      label: "订单",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: "我的",
    ),
  ];

  int currentIndex = 0;

  final pages = [const HomePage(),const TravelService(),const OrderPage(),const MinePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _changePage(index);
        },
      ),
      body: pages[currentIndex],
    );
  }

  void _changePage(int index) {
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
    }
  }
}