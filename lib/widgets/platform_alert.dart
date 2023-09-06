import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> showPlatformAlert(BuildContext context, String message){
  switch(defaultTargetPlatform){
    case TargetPlatform.iOS:
      return showCupertinoDialog(context: context, builder: (context) => CupertinoAlertDialog(
        title: const Text("Alert"),
        content: Text(message),
        actions: [
          CupertinoDialogAction(child: const Text("Ok"), onPressed: () => Navigator.of(context).pop(),)
        ],
      ));
    default:
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Alert"),
          content: Text(message),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Ok"))
          ],
        )
      );

  }
}