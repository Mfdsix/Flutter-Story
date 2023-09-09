import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class PlatformAlert extends Page{
  final String message;

  const PlatformAlert({
    super.key,
    required this.message
  });

  @override
  Route createRoute(BuildContext context) {
    return CupertinoDialogRoute(
      settings: this,
      barrierDismissible: true,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return Text(message);
      },
      context: context,
    );
  }
}


Future<void> _oldshowPlatformAlert(BuildContext context, String message){
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