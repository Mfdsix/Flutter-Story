import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const PlatformScaffold({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return _iOSScaffold();
      default:
        return _androidScaffold();
    }
  }

  Widget _androidScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          title: Text(title),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child
          ),
        ),
      ),
    );
  }

  Widget _iOSScaffold() {
    return CupertinoPageScaffold(
      backgroundColor: Colors.grey,
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
