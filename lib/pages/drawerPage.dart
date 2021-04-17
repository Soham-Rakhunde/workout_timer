import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_timer/main.dart';

import '../constants.dart';



class drawerPage extends StatefulWidget {

  @override
  _drawerPageState createState() => _drawerPageState();
}

class _drawerPageState extends State<drawerPage> {
  double screenWidth;

  double adjusted(double val) => val * screenWidth * perPixel;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 25, 0, 5),
        child: ValueListenableBuilder(
          valueListenable: isDark,
          builder: (context, val, child) {
            return child;
          },
          child: ValueListenableBuilder(
            valueListenable: indexOfMenu,
            builder: (context, val, child) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Workout Timer',
                          style: TextStyle(
                            color: Colors.teal[200],
                            letterSpacing: 2.0,
                            fontSize: 30,
                            fontFamily: 'MontserratBold',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'High-intensity interval training',
                          style: TextStyle(
                            color: Colors.teal,
                            letterSpacing: 1.5,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    AnimatedContainer(
                      width: 170,
                      height: MediaQuery.of(context).size.height * 9 / 20,
                      duration: Duration(milliseconds: 250),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                indexOfMenu.value = 0;
                              });
                            }),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timer,
                                    size: 25,
                                    color: Colors.teal[
                                        indexOfMenu.value == 0 ? 200 : 500],
                                  ),
                                  SizedBox(width: screenWidth / 20),
                                  Text(
                                    'Timer',
                                    style: TextStyle(
                                      fontFamily: 'MontserratBold',
                                      color: Colors.teal[
                                          indexOfMenu.value == 0 ? 200 : 500],
                                      letterSpacing: 1.5,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 4 / 85,
                          ),
                          GestureDetector(
                            //advanced
                            onTap: (() {
                              setState(() {
                                indexOfMenu.value = 5;
                              });
                            }),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.dumbbell,
                                    size: 20,
                                    color: Colors.teal[
                                        indexOfMenu.value == 5 ? 200 : 500],
                                  ),
                                  SizedBox(width: screenWidth / 20),
                                  Text(
                                    'Advanced',
                                    style: TextStyle(
                                      fontFamily: 'MontserratBold',
                                      color: Colors.teal[
                                          indexOfMenu.value == 5 ? 200 : 500],
                                      letterSpacing: 0.4,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 4 / 85,
                          ),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                indexOfMenu.value = 1;
                              });
                            }),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Icon(
                                        Icons.stacked_line_chart_rounded,
                                        size: 25,
                                        color: Colors.teal[
                                            indexOfMenu.value == 1 ? 200 : 500],
                                      ),
                                      if (!openedAfterDbUpdate)
                                        Positioned(
                                          // draw a red marble
                                          top: -5.0,
                                          right: -5.0,
                                          child: new Icon(
                                              Icons.brightness_1_rounded,
                                              size: 10.0,
                                              color: Colors.redAccent),
                                        )
                                    ],
                                  ),
                                  SizedBox(width: screenWidth / 20),
                                  Text(
                                    'Statistics',
                                    style: TextStyle(
                                      fontFamily: 'MontserratBold',
                                      color: Colors.teal[
                                          indexOfMenu.value == 1 ? 200 : 500],
                                      letterSpacing: 1.5,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 4 / 85,
                          ),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                indexOfMenu.value = 2;
                              });
                            }),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 5),
                                  FaIcon(
                                    FontAwesomeIcons.dollarSign,
                                    size: 22,
                                    color: Colors.teal[
                                        indexOfMenu.value == 2 ? 200 : 500],
                                  ),
                                  SizedBox(width: screenWidth / 15),
                                  Text(
                                    'Support',
                                    style: TextStyle(
                                      fontFamily: 'MontserratBold',
                                      color: Colors.teal[
                                          indexOfMenu.value == 2 ? 200 : 500],
                                      letterSpacing: 1.5,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 4 / 85,
                          ),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                indexOfMenu.value = 3;
                              });
                              // Navigator.push(context,
                              //     PageRouteBuilder(
                              //     transitionDuration: Duration(milliseconds:150),
                              //     reverseTransitionDuration: Duration(milliseconds:150),
                              //     transitionsBuilder:(BuildContext context,Animation<double> animation,Animation<double> secAnimation, Widget child){
                              //       return ScaleTransition(
                              //         scale: animation,
                              //         alignment: Alignment.lerp(Alignment.center, Alignment.centerRight, 0.9),
                              //         child: child,
                              //       );
                              //     },
                              //     pageBuilder: (BuildContext context,Animation<double> animation,Animation<double> secAnimation){
                              //       return AboutPage();
                              //     }
                              // ));
                            }),
                            // onTap: ()=>createDialog(context),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 25,
                                    color: Colors.teal[
                                        indexOfMenu.value == 3 ? 200 : 500],
                                  ),
                                  SizedBox(width: screenWidth / 20),
                                  Text(
                                    'About',
                                    style: TextStyle(
                                      fontFamily: 'MontserratBold',
                                      color: Colors.teal[
                                          indexOfMenu.value == 3 ? 200 : 500],
                                      letterSpacing: 1.5,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 4 / 85,
                          ),
                          GestureDetector(
                            onTap: (() async {
                              if (await canLaunch(
                                  'https://play.google.com/store/apps/details?id=com.rakhunde.workout_timer')) {
                                await launch(
                                    'https://play.google.com/store/apps/details?id=com.rakhunde.workout_timer');
                              } else {
                                throw 'Could not launch https://play.google.com/store/apps/details?id=com.rakhunde.workout_timer';
                              }
                            }),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star_border_rounded,
                                    size: 25,
                                    color: Colors.teal[500],
                                  ),
                                  SizedBox(width: screenWidth / 20),
                                  Text(
                                    'Rate',
                                    style: TextStyle(
                                      fontFamily: 'MontserratBold',
                                      color: Colors.teal[500],
                                      letterSpacing: 1.5,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          indexOfMenu.value = 4;
                        });
                      }),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.settings,
                                size: 23,
                                color: Colors
                                    .teal[indexOfMenu.value == 4 ? 200 : 500],
                              ),
                              SizedBox(
                                width: screenWidth / 40,
                              ),
                              Text(
                                'Settings',
                                style: TextStyle(
                                  fontFamily: 'MontserratBold',
                                  color: Colors
                                      .teal[indexOfMenu.value == 4 ? 200 : 500],
                                  letterSpacing: 1.5,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: screenWidth / 20,
                              ),
                              Container(
                                height: 20,
                                width: 2.5,
                                color: Colors.teal,
                              ),
                              SizedBox(
                                width: screenWidth / 20,
                              ),
                              GestureDetector(
                                onTap: (() {
                                  SystemChannels.platform
                                      .invokeMethod('SystemNavigator.pop');
                                }),
                                child: Text(
                                  'Exit',
                                  style: TextStyle(
                                    fontFamily: 'MontserratBold',
                                    color: Colors.teal,
                                    letterSpacing: 1.5,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ]);
            },
          ),
        ),
      ),
    );
  }

  Future<String> createDialog (BuildContext context){
    return showDialog(
      context: context,
      builder: (context) {
        return AboutDialog(
          applicationName: 'Workout Timer',
          applicationVersion: '1.0.0',
        );
      },
    );
  }
}
