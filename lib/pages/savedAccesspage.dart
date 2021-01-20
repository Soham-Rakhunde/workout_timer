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
  List<SavedAdvanced> savedAdvListObjs;
  ValueNotifier<bool> isSimpleOpen = ValueNotifier<bool>(true);
  List<String> savedList;

  Future<List<SavedWorkout>> _getData() async {
    savedList = await _data.read('List');
    savedListObjs = savedList
        .map((item) => SavedWorkout.fromMap(jsonDecode(item)))
        .toList();
    savedList = await _data.read('Adv');
    savedAdvListObjs = savedList
        .map((item) => SavedAdvanced.fromJson(jsonDecode(item)))
        .toList();
    return savedListObjs;
  }

  // Future<List<SavedAdvanced>> _getAdvData() async {
  //
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        // this will be set
        elevation: 0,
        onTap: (index) {
          setState(() {
            isSimpleOpen.value = index == 0 ? true : false;
          });
        },
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.spa,
              size: 20,
              color: isSimpleOpen.value ? Colors.blue : null,
            ),
            title: Text(
              'Simple',
              style: TextStyle(
                color: isSimpleOpen.value ? Colors.blue : null,
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.dumbbell,
              size: 20,
              color: !isSimpleOpen.value ? Colors.blue : null,
            ),
            title: Text(
              'Advanced',
              style: TextStyle(
                color: !isSimpleOpen.value ? Colors.blue : null,
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 65, 10, 5),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'Saved Workout',
                  style: kTextStyle.copyWith(
                    color: textColor,
                    letterSpacing: 2.0,
                    fontSize: 31,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              color: backgroundColor,
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: isSimpleOpen,
                builder: (context, isSimple, _) {
                  return FutureBuilder(
                    future: _getData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (isSimple) {
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Dismissible(
                                      background: Container(
                                        padding: EdgeInsets.only(left: 30),
                                        alignment: Alignment.centerLeft,
                                        child: Wrap(
                                            direction: Axis.vertical,
                                            children: [
                                              RotatedBox(
                                                  quarterTurns: 3,
                                                  child: Center(
                                                    child: Text(
                                                      'Delete',
                                                      style:
                                                          kTextStyle.copyWith(
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
                                        savedListObjs.removeAt(index);
                                        savedList = [];
                                        savedList = savedListObjs
                                            .map((item) =>
                                                (jsonEncode(item.toMap())))
                                            .toList();
                                        await _data.save('List', savedList);
                                      },
                                      child: GestureDetector(
                                        onTap: (() async {
                                          final periodTime = TimeClass(
                                            name: snapshot.data[index].name,
                                            isWork: true,
                                            sec: Duration(
                                              minutes:
                                                  snapshot.data[index].pMin,
                                              seconds:
                                                  snapshot.data[index].pSec,
                                            ).inSeconds,
                                          );
                                          final breakTime = TimeClass(
                                            name: 'Break',
                                            isWork: false,
                                            sec: Duration(
                                              minutes:
                                                  snapshot.data[index].bMin,
                                              seconds:
                                                  snapshot.data[index].bSec,
                                            ).inSeconds,
                                          );
                                          final set1 = SetClass(
                                            timeList: [
                                              periodTime,
                                            ],
                                            sets:
                                                snapshot.data[index].setsCount,
                                          );
                                          final page = TimerPage(
                                            isRest: true,
                                            args: [set1],
                                            breakTime: breakTime,
                                          );
                                          await Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: 250),
                                                  reverseTransitionDuration:
                                                      Duration(
                                                          milliseconds: 150),
                                                  transitionsBuilder:
                                                      (BuildContext context,
                                                          Animation<double>
                                                              animation,
                                                          Animation<double>
                                                              secAnimation,
                                                          Widget child) {
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    );
                                                  },
                                                  pageBuilder:
                                                      (BuildContext context,
                                                          Animation<double>
                                                              animation,
                                                          Animation<double>
                                                              secAnimation) {
                                                    return page;
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Text(
                                                    snapshot.data[index].name ==
                                                            ''
                                                        ? 'Name'
                                                        : '${snapshot.data[index].name}',
                                                    style: kTextStyle.copyWith(
                                                      color: backgroundColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 26.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                          'Time',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color:
                                                                backgroundColor,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                          '${snapshot.data[index].pMin}:${snapshot.data[index].pSec}',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color:
                                                                backgroundColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
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
                                                      FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                          'Break',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color:
                                                                backgroundColor,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                          '${snapshot.data[index].bMin}:${snapshot.data[index].bSec}',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color:
                                                                backgroundColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
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
                                                      FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                          'Sets',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color:
                                                                backgroundColor,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                          '${snapshot.data[index].setsCount}',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color:
                                                                backgroundColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
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
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: gradientList[index % 5]
                                                          [1]
                                                      .withOpacity(0.22),
                                                  offset: Offset(8, 6),
                                                  blurRadius: 15),
                                              BoxShadow(
                                                  color: gradientList[index % 5]
                                                          [0]
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
                      } else {
                        if (savedAdvListObjs == null) {
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
                                  itemCount: savedAdvListObjs.length,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Dismissible(
                                      background: Container(
                                        padding: EdgeInsets.only(left: 30),
                                        alignment: Alignment.centerLeft,
                                        child: Wrap(
                                            direction: Axis.vertical,
                                            children: [
                                              RotatedBox(
                                                  quarterTurns: 3,
                                                  child: Center(
                                                    child: Text(
                                                      'Delete',
                                                      style:
                                                          kTextStyle.copyWith(
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
                                        savedAdvListObjs.removeAt(index);
                                        savedList = [];
                                        savedList = savedListObjs
                                            .map((item) =>
                                                (jsonEncode(item.toMap())))
                                            .toList();
                                        await _data.save('Adv', savedList);
                                      },
                                      child: GestureDetector(
                                        onTap: (() async {
                                          // final periodTime = TimeClass(
                                          //   name: snapshot.data[index].name,
                                          //   isWork: true,
                                          //   sec: Duration(
                                          //     minutes:
                                          //         snapshot.data[index].pMin,
                                          //     seconds:
                                          //         snapshot.data[index].pSec,
                                          //   ).inSeconds,
                                          // );
                                          // final breakTime = TimeClass(
                                          //   name: 'Break',
                                          //   isWork: false,
                                          //   sec: Duration(
                                          //     minutes:
                                          //         snapshot.data[index].bMin,
                                          //     seconds:
                                          //         snapshot.data[index].bSec,
                                          //   ).inSeconds,
                                          // );
                                          // final set1 = SetClass(
                                          //   timeList: [
                                          //     periodTime,
                                          //   ],
                                          //   sets: snapshot
                                          //       .data[index].setsCount,
                                          // );
                                          // final page = TimerPage(
                                          //   isRest: true,
                                          //   args: [set1],
                                          //   breakTime: breakTime,
                                          // );
                                          // await Navigator.pushReplacement(
                                          //     context,
                                          //     PageRouteBuilder(
                                          //         transitionDuration:
                                          //             Duration(
                                          //                 milliseconds:
                                          //                     250),
                                          //         reverseTransitionDuration:
                                          //             Duration(
                                          //                 milliseconds:
                                          //                     150),
                                          //         transitionsBuilder:
                                          //             (BuildContext context,
                                          //                 Animation<double>
                                          //                     animation,
                                          //                 Animation<double>
                                          //                     secAnimation,
                                          //                 Widget child) {
                                          //           return FadeTransition(
                                          //             opacity: animation,
                                          //             child: child,
                                          //           );
                                          //         },
                                          //         pageBuilder: (BuildContext
                                          //                 context,
                                          //             Animation<double>
                                          //                 animation,
                                          //             Animation<double>
                                          //                 secAnimation) {
                                          //           return page;
                                          //         }));
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Text(
                                                    savedAdvListObjs[index]
                                                                .name ==
                                                            ''
                                                        ? 'Name'
                                                        : '${savedAdvListObjs[index].name}',
                                                    style: kTextStyle.copyWith(
                                                      color: backgroundColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 26.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment
                                              //           .spaceEvenly,
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment
                                              //           .center,
                                              //   children: [
                                              //     Column(
                                              //       children: [
                                              //         FittedBox(
                                              //           fit:
                                              //               BoxFit.fitWidth,
                                              //           child: Text(
                                              //             'Time',
                                              //             style: kTextStyle
                                              //                 .copyWith(
                                              //               color:
                                              //                   backgroundColor,
                                              //               fontSize: 20,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //         FittedBox(
                                              //           fit:
                                              //               BoxFit.fitWidth,
                                              //           child: Text(
                                              //             '${snapshot.data[index].pMin}:${snapshot.data[index].pSec}',
                                              //             style: kTextStyle
                                              //                 .copyWith(
                                              //               color:
                                              //                   backgroundColor,
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .bold,
                                              //               fontSize: 20,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //     Container(
                                              //       height: 45,
                                              //       width: 1.3,
                                              //       color: backgroundColor,
                                              //     ),
                                              //     Column(
                                              //       children: [
                                              //         FittedBox(
                                              //           fit:
                                              //               BoxFit.fitWidth,
                                              //           child: Text(
                                              //             'Break',
                                              //             style: kTextStyle
                                              //                 .copyWith(
                                              //               color:
                                              //                   backgroundColor,
                                              //               fontSize: 20,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //         FittedBox(
                                              //           fit:
                                              //               BoxFit.fitWidth,
                                              //           child: Text(
                                              //             '${snapshot.data[index].bMin}:${snapshot.data[index].bSec}',
                                              //             style: kTextStyle
                                              //                 .copyWith(
                                              //               color:
                                              //                   backgroundColor,
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .bold,
                                              //               fontSize: 20,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //     Container(
                                              //       height: 45,
                                              //       width: 1.3,
                                              //       color: backgroundColor,
                                              //     ),
                                              //     Column(
                                              //       children: [
                                              //         FittedBox(
                                              //           fit:
                                              //               BoxFit.fitWidth,
                                              //           child: Text(
                                              //             'Sets',
                                              //             style: kTextStyle
                                              //                 .copyWith(
                                              //               color:
                                              //                   backgroundColor,
                                              //               fontSize: 20,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //         FittedBox(
                                              //           fit:
                                              //               BoxFit.fitWidth,
                                              //           child: Text(
                                              //             '${snapshot.data[index].setsCount}',
                                              //             style: kTextStyle
                                              //                 .copyWith(
                                              //               color:
                                              //                   backgroundColor,
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .bold,
                                              //               fontSize: 20,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: gradientList[index % 5],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: gradientList[index % 5]
                                                          [1]
                                                      .withOpacity(0.22),
                                                  offset: Offset(8, 6),
                                                  blurRadius: 15),
                                              BoxShadow(
                                                  color: gradientList[index % 5]
                                                          [0]
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
                      }
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
