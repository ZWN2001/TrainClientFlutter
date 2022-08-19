import 'package:flutter/material.dart';

class MyDialog{
  static Future<bool?> showDeleteConfirmDialog({required BuildContext context,
    required String tips}) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: Text(tips),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(), //关闭对话框
            ),
            TextButton(
              child: const Text("确定"),
              onPressed: () {
                Navigator.of(context).pop(true); //关闭对话框
              },
            ),
          ],
        );
      },
    );
  }
}