import 'package:flutter/material.dart';

//particles: 10,
//   foregroundColor: Color(0xff59ab5b),
//   backgroundColor: Color(0xff0a5a55),
//   size: 0.62,
//   speed: 7.69,
//   offset: 0.37,
//   blendMode: BlendMode.plus,
ValueNotifier<int> indexOfMenu =
    ValueNotifier<int>(0); //Timer,Stats,Donate,About,Rate
Map retain = {
  'sets': '-1',
  'breakMin': '-1',
  'breakSec': '-1',
  'periodMin': '-1',
  'periodSec': '-1'
};
Map controller = {
  'sets': TextEditingController(text: '3'),
  'breakSec': TextEditingController(text: '30'),
  'breakMin': TextEditingController(text: '30'),
  'periodSec': TextEditingController(text: '30'),
  'periodMin': TextEditingController(text: '30'),
};
const kTextStyle =  TextStyle(
    letterSpacing: 2.0,
    fontSize: 20,
);
const kInputDecor = InputDecoration(
  border: InputBorder.none,
);

Color backgroundColor = Color(0xFFF1F2F6);
Color shadowColor = Color(0xFFDADFF9);
Color lightShadowColor = Colors.white;
Color textColor = Color(0xFF707070);
Color seekBarLightColor = Color(0xFFB8ECED);
Color seekBarDarkColor = Color(0xFF37C8DF);
Color lightGradient = Color(0xFFc2e9fb);
Color darkGradient = Color(0xFFA1C4FD);
Color drawerColor = Color.fromRGBO(10, 90,85, 1);

const turqoiseGradient = [
  Color.fromRGBO(91, 253, 199, 1),
  Color.fromRGBO(129, 182, 205, 1),
];
const greenGradient = [
  Color.fromRGBO(223, 250, 92, 1),
  Color.fromRGBO(129, 250, 112, 1)
];
const orangeGradient = [
  Color.fromRGBO(253, 255, 93, 1),
  Color.fromRGBO(251, 173, 86, 1),
];
const redGradient = [
  Color.fromRGBO(254, 154, 92, 1),
  Color.fromRGBO(255, 93, 91, 1),
];

List<List<Color>> gradientList = [
  sunset,
  sea,
  mango,
  sky,
  fire,
];
List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
final List<String> voiceModels = [
  'Amy',
  'Brian',
  'Emma',
  'Joanna',
  'Joey',
  'Matthew',
  'Olivia',
  'Salli'
];