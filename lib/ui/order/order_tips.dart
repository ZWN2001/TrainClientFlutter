import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OrderTipsPage extends StatelessWidget{
  const OrderTipsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String url = "https://mobile.12306.cn/otsmobile/h5/otsbussiness/info/orderWarmTips.html?eventId=orderCenter%E6%B8%A9%E9%A6%A8%E6%8F%90%E7%A4%BA&eventName=%E6%A0%87%E5%87%86%E7%89%88%E7%82%B9%E5%87%BB%E6%B8%A9%E9%A6%A8%E6%8F%90%E7%A4%BA&valueName=H5_CROSS_PAGE_DATA_PASSING_VALUE&notifyName=H5_CROSS_PAGE_DATA_PASSING_1660309437834";
    return Scaffold(
      appBar: AppBar(title: const Text('温馨提示'),),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

}