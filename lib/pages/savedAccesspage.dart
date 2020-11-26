import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 27),
              child: Text(
                'Saved Workout',
                style: kTextStyle.copyWith(
                  color: Color(0xFF707070),
                  letterSpacing: 2.0,
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: backgroundColor,
            ),
            Expanded(
              child: FutureBuilder(
                future: _getData(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: Text('Loading'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          background: Container(
                            padding: EdgeInsets.only(left: 30),
                            alignment: Alignment.centerLeft,
                            child: Wrap(direction: Axis.vertical, children: [
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
                                sec: int.parse(controller['periodMin'].text) *
                                        60 +
                                    int.parse(controller['periodSec'].text),
                              );
                              final breakTime = TimeClass(
                                name: 'Break',
                                sec: int.parse(controller['breakMin'].text) *
                                        60 +
                                    int.parse(controller['breakSec'].text),
                              );
                              await Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 700),
                                      reverseTransitionDuration:
                                          Duration(milliseconds: 250),
                                      transitionsBuilder: (BuildContext context,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                      color: shadowColor,
                                      offset: Offset(8, 6),
                                      blurRadius: 12),
                                  BoxShadow(
                                      color: lightShadowColor,
                                      offset: Offset(-8, -6),
                                      blurRadius: 12),
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
      ),
    );
  }
}
