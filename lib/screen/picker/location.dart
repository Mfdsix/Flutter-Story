import 'package:flutter/cupertino.dart';
import 'package:puth_story/widgets/platform_scaffold.dart';

class LocationPage extends StatefulWidget {
  final Function() onSend;

  const LocationPage({super.key, required this.onSend});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context){
    return PlatformScaffold(title: "Pick Location", child: Container());
  }
}