import 'package:flutter/material.dart';

class ColoredEllipse extends StatelessWidget {
  double width;
  List<Color> colors;

  ColoredEllipse(this.width, this.colors);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
        gradient: RadialGradient(
            colors: colors as List<Color>,
            center: Alignment.lerp(Alignment.topLeft, Alignment.center, 0.7)!,
            stops: [0.15, 1]),
        borderRadius: BorderRadius.all(Radius.circular(width / 2)),
      ),
    );
  }
}
