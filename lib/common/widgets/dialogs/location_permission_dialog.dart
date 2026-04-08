import 'package:cri_v3/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

DialogRoute<dynamic> locationDialogRoute({
  required String title,
  required String contentTxt,
  String btnTxt = 'ok',
  VoidCallback? onPressed,
}) {
  return DialogRoute(
    context: globalNavigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(contentTxt),
        actions: [
          TextButton(
            onPressed:
                onPressed ??
                () {
                  Navigator.of(context).pop();
                },
            child: Text(btnTxt),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('exit'),
          ),
        ],
      );
    },
  );
}
