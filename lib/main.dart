import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const appTitle = "Puth Story";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    switch(defaultTargetPlatform){
      case TargetPlatform.iOS:
        return iOSScaffold(context, const Text("hallo"));
      default:
        return androidScaffold(context, const Text("hello android"));
    }
  }

  Widget iOSScaffold(BuildContext context, Widget child){
    return CupertinoApp(
      home: CupertinoPageScaffold(
        backgroundColor: Colors.grey,
        navigationBar: const CupertinoNavigationBar(
          middle: Text(appTitle),
        ),
        child: child,
      ),
    );
  }

  Widget androidScaffold(BuildContext context, Widget child){
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: AppBar(
              centerTitle: true,
              toolbarHeight: 150,
              title: const Text(appTitle),
            ),
          ),
          body: child
      ),
    );
  }
}
