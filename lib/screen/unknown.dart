import 'package:flutter/material.dart';

class UnknownPage extends StatefulWidget {

  final Function() onBack;

  const UnknownPage({super.key, required this.onBack});

  @override
  State<UnknownPage> createState() => _UnknownPageState();
}

class _UnknownPageState extends State<UnknownPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Unknown Page"),
          ElevatedButton(onPressed: widget.onBack, child: const Text("Back to Home"))
        ],
      ),
    );
  }
}
