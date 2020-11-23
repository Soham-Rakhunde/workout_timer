import 'package:flutter/material.dart';

Map retain = {
  'sets' : '-1',
  'breakMin' : '-1',
  'breakSec' : '-1',
  'periodMin' : '-1',
  'periodSec' : '-1'
};
Map controller = {
  'sets': TextEditingController(text: '3'),
  'breakSec' : TextEditingController(text: '30'),
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
