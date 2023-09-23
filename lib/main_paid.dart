import 'package:flutter/cupertino.dart';
import 'package:puth_story/main.dart';
import 'package:puth_story/utils/flavor_config.dart';

void main() {
  FlavorConfig(
    flavor: FlavorType.paid,
  );

  runApp(const MyApp());
}