import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class NewPlatformAlertDoesntWork extends Page{
  final String message;

  const NewPlatformAlertDoesntWork({
    super.key,
    required this.message
  });

  @override
  Route createRoute(BuildContext context) {
    return CupertinoDialogRoute(
      settings: this,
      barrierDismissible: true,
      barrierColor: Colors.black,
      builder: (BuildContext context) {
        return Text(message);
      },
      context: context,
    );
  }
}


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
            // still figure it out how to get there, since https://ulusoyca.medium.com/flutter-for-single-page-scrollable-websites-with-navigator-2-0-part-6-navigation-16b4f5a1981f not provide full example of how to use it
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Ok"))
          ],
        )
      );

  }
}