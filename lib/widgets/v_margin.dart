import 'package:flutter/widgets.dart';

class VMargin extends StatelessWidget {
  final double height;

  const VMargin({super.key, this.height = 10.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
