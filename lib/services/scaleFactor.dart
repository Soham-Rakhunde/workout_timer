import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static double screenWidth = 1080;
  static double screenHeight = 2340;
  static double sw = 1;
  static double sh = 1;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    sw = screenWidth / 1080;
    sh = screenHeight / 2340;
  }
}
