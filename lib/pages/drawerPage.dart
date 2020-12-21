import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store_redirect/store_redirect.dart';
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
          valueListenable: indexOfMenu,
          builder: (context, val, child) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon(
                        //   Icons.watch_later_outlined,
                        //   size: 50,
                        //   color: Colors.teal[200],
                        // ),
                        // SizedBox(width:10),
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
                      ]),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              indexOfMenu.value = 0;
                              print('${indexOfMenu.value}');
                            });
                          }),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer,
                                size: 25,
                                color: Colors
                                    .teal[indexOfMenu.value == 0 ? 200 : 500],
                              ),
                              SizedBox(width: 15),
                              Text(
                                'Timer',
                                style: TextStyle(
                                  fontFamily: 'MontserratBold',
                                  color: Colors
                                      .teal[indexOfMenu.value == 0 ? 200 : 500],
                                  letterSpacing: 1.5,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              indexOfMenu.value = 1;
                              print('${indexOfMenu.value}');
                            });
                          }),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.stacked_line_chart_rounded,
                                size: 25,
                                color: Colors
                                    .teal[indexOfMenu.value == 1 ? 200 : 500],
                              ),
                              SizedBox(width: 15),
                              Text(
                                'Stats',
                                style: TextStyle(
                                  fontFamily: 'MontserratBold',
                                  color: Colors
                                      .teal[indexOfMenu.value == 1 ? 200 : 500],
                                  letterSpacing: 1.5,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              indexOfMenu.value = 2;
                              print('${indexOfMenu.value}');
                            });
                          }),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 5),
                              FaIcon(
                                FontAwesomeIcons.dollarSign,
                                size: 22,
                                color: Colors
                                    .teal[indexOfMenu.value == 2 ? 200 : 500],
                              ),
                              SizedBox(width: 20),
                              Text(
                                'Support',
                                style: TextStyle(
                                  fontFamily: 'MontserratBold',
                                  color: Colors
                                      .teal[indexOfMenu.value == 2 ? 200 : 500],
                                  letterSpacing: 1.5,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              indexOfMenu.value = 3;
                            });
                            print('${indexOfMenu.value}');
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 25,
                                color: Colors
                                    .teal[indexOfMenu.value == 3 ? 200 : 500],
                              ),
                              SizedBox(width: 15),
                              Text(
                                'About',
                                style: TextStyle(
                                  fontFamily: 'MontserratBold',
                                  color: Colors
                                      .teal[indexOfMenu.value == 3 ? 200 : 500],
                                  letterSpacing: 1.5,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              StoreRedirect.redirect();
                            });
                          }),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_border_rounded,
                                size: 25,
                                color: Colors.teal[500],
                              ),
                              SizedBox(width: 15),
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
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        indexOfMenu.value = 4;
                      });
                      print('${indexOfMenu.value}');
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
                              width: 10,
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
                              width: 15,
                            ),
                            Container(
                              height: 20,
                              width: 2.5,
                              color: Colors.teal,
                            ),
                            SizedBox(
                              width: 15,
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
