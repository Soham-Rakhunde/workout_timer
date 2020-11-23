import 'package:flutter/material.dart';
import 'package:workout_timer/services/timeValueHandler.dart';

class savedPage extends StatefulWidget {
  @override
  _savedPageState createState() => _savedPageState();
}

class _savedPageState extends State<savedPage> {
  SharedPref _data = SharedPref();
  List list = [];
  String varia;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (() async {
          list = await _data.read();
          setState(() {
            print('$list');
            varia = '$list';
          });
        }),
      ),
    );
  }
}
