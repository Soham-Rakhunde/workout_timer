import 'package:flutter/material.dart';

String stringFormatter(String s){
  String a;
  a = s.toLowerCase();
  a= a[0].toUpperCase() + a.substring(1);
  return a;
}
