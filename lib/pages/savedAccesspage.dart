import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/pages/timerpage.dart';
import 'package:workout_timer/services/timeValueHandler.dart';

class savedPage extends StatefulWidget {
  @override
  _savedPageState createState() => _savedPageState();
}

class _savedPageState extends State<savedPage> {
  SharedPref _data = SharedPref();
  List<SavedWorkout> savedListObjs;

  List<String> savedList;

  Future<List<SavedWorkout>> _getData() async {
    savedList = await _data.read();
    print('savedList');
    savedListObjs = savedList
        .map((item) => SavedWorkout.fromMap(jsonDecode(item)))
        .toList();
    return savedListObjs;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 65, 0, 5),
              child: Text(
                'Saved Workout',
                style: kTextStyle.copyWith(
                  color: textColor,
                  letterSpacing: 2.0,
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: backgroundColor,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  return Center(child: Text('Loading'));
                } else {
                  return snapshot.data.length == 0
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: FaIcon(
                                FontAwesomeIcons.puzzlePiece,
                                size: 100,
                                color: Colors.teal,
                              )),
                              SizedBox(
                                height: 40,
                              ),
                              Center(
                                  child: Text(
                                'No Data Saved',
                                style: TextStyle(fontSize: 25),
                              )),
                              Center(
                                  child: Text(
                                'Save data from homescreen',
                                style: TextStyle(fontSize: 20),
                              )),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              background: Container(
                                padding: EdgeInsets.only(left: 30),
                                alignment: Alignment.centerLeft,
                                child:
                                    Wrap(direction: Axis.vertical, children: [
                                  RotatedBox(
                                      quarterTurns: 3,
                                      child: Center(
                                        child: Text(
                                          'Delete',
                                          style: kTextStyle.copyWith(
                                            color: textColor,
                                            fontSize: 25,
                                          ),
                                        ),
                                      )),
                                ]),
                                // child: Icon(Icons.delete_outline_rounded,size: 40,color: textColor,)
                              ),
                        direction: DismissDirection.startToEnd,
                        key: UniqueKey(),
                        onDismissed: (direction) async {
                          print(index);
                          savedListObjs.removeAt(index);
                          savedList = [];
                          savedList = savedListObjs
                              .map((item) => (jsonEncode(item.toMap())))
                              .toList();
                          print('$savedList');
                          await _data.save(savedList);
                        },
                        child: GestureDetector(
                          onTap: (() async {
                            if (controller['periodSec'] == '') {
                              controller['periodSec'] = '30';
                            }
                            if (controller['periodMin'] == '') {
                              controller['periodMin'] = '0';
                            }
                            if (controller['periodSec'] == '') {
                              controller['periodSec'] = '30';
                            }
                            if (controller['breakMin'] == '') {
                              controller['breakMin'] = '0';
                            }
                            if (controller['breakSec'] == '') {
                              controller['breakSec'] = '30';
                            }
                            if (controller['sets'] == '') {
                              controller['sets'] = '3';
                            }
                            final periodTime = TimeClass(
                              name: 'Workout',
                              sec:
                                  int.parse(controller['periodMin'].text) * 60 +
                                      int.parse(controller['periodSec'].text),
                            );
                            final breakTime = TimeClass(
                              name: 'Break',
                              sec: int.parse(controller['breakMin'].text) * 60 +
                                  int.parse(controller['breakSec'].text),
                            );
                            await Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                              Duration(milliseconds: 250),
                                          reverseTransitionDuration:
                                              Duration(milliseconds: 150),
                                          transitionsBuilder: (BuildContext
                                                  context,
                                              Animation<double> animation,
                                              Animation<double> secAnimation,
                                              Widget child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                        Animation<double> secAnimation) {
                                      return TimerPage(
                                        args: [
                                          periodTime,
                                          breakTime,
                                          int.parse(controller['sets'].text),
                                        ],
                                      );
                                    }));
                          }),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 25),
                            height: 140,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    snapshot.data[index].name == ''
                                        ? 'Name'
                                        : '${snapshot.data[index].name}',
                                    style: kTextStyle.copyWith(
                                      color: backgroundColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26.5,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Time',
                                          style: kTextStyle.copyWith(
                                            color: backgroundColor,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          '${snapshot.data[index].pMin}:${snapshot.data[index].pSec}',
                                          style: kTextStyle.copyWith(
                                            color: backgroundColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 45,
                                      width: 1.3,
                                      color: backgroundColor,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Break',
                                          style: kTextStyle.copyWith(
                                            color: backgroundColor,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          '${snapshot.data[index].bMin}:${snapshot.data[index].bSec}',
                                          style: kTextStyle.copyWith(
                                            color: backgroundColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 45,
                                      width: 1.3,
                                      color: backgroundColor,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Sets',
                                          style: kTextStyle.copyWith(
                                            color: backgroundColor,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          '${snapshot.data[index].setsCount}',
                                          style: kTextStyle.copyWith(
                                            color: backgroundColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: gradientList[index % 5],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                    color: gradientList[index % 5][1]
                                        .withOpacity(0.22),
                                    offset: Offset(8, 6),
                                    blurRadius: 15),
                                BoxShadow(
                                    color: gradientList[index % 5][0]
                                        .withOpacity(0.22),
                                    offset: Offset(-8, -6),
                                    blurRadius: 15),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
