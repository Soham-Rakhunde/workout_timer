import 'dart:ui';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/services/BarChart.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  double screenWidth;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  AnimationController playGradientControl;
  Animation edges;
  Animation<Color> colAnim1, colAnim2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    setState(() {
      xOffset = 250;
      yOffset = 140;
      scaleFactor = 0.7;
      isDrawerOpen = true;
      isStatsOpen = false;
    });
    playGradientControl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
      reverseDuration: Duration(milliseconds: 450),
    );
    edges = Tween<double>(
      begin: 28.0,
      end: 0.0,
    ).animate(playGradientControl);
    colAnim1 = ColorTween(
      begin: darkGradient,
      end: lightGradient,
    ).animate(playGradientControl);
    colAnim2 = ColorTween(
      begin: lightGradient,
      end: darkGradient,
    ).animate(playGradientControl);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (isStatsOpen) {
      setState(() {
        xOffset = adjusted(250);
        yOffset = adjusted(140);
        playGradientControl.forward();
        scaleFactor = 0.7;
        isDrawerOpen = true;
        isStatsOpen = false;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isStatsOpen ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: isStatsOpen ? backgroundColor : drawerColor,
          systemNavigationBarIconBrightness:
              isStatsOpen ? Brightness.dark : Brightness.light,
          systemNavigationBarDividerColor:
              isStatsOpen ? backgroundColor : drawerColor,
        ));
      });
      return true;
    } else
      return false;
  }

  double adjusted(double val) => val * screenWidth * perPixel;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
      valueListenable: indexOfMenu,
      builder: (context, val, child) {
        return child;
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 450),
        curve: Curves.easeInOutQuart,
        transform: Matrix4.translationValues(xOffset, yOffset, 100)
          ..scale(scaleFactor),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        onEnd: (() {
          if (isStatsOpen && indexOfMenu.value == 1) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  isStatsOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarColor:
                  isStatsOpen ? backgroundColor : drawerColor,
              systemNavigationBarIconBrightness:
                  isStatsOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarDividerColor:
              isStatsOpen ? backgroundColor : drawerColor,
            ));
          }
        }),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(edges.value),
        ),
        child: GestureDetector(
          onTap: (() {
            if (!isStatsOpen && indexOfMenu.value == 1) {
              setState(() {
                xOffset = 0;
                playGradientControl.reverse();
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isStatsOpen = true;
              });
            }
          }),
          onHorizontalDragEnd: ((_) {
            if (!isStatsOpen && indexOfMenu.value == 1) {
              setState(() {
                xOffset = 0;
                playGradientControl.reverse();
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isStatsOpen = true;
              });
            }
          }),
          child: AbsorbPointer(
            absorbing: !isStatsOpen,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(edges.value),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 450),
                    child: Container(
                      child: Image.asset(
                        'assets/images/img.jpeg',
                        fit: BoxFit.fill,
                      ),
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(edges.value),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(edges.value),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50,),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.grey.withOpacity(0.4),
                                        Colors.grey.withOpacity(0.01),
                                      ]
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30)),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            'Statistics',
                                            style: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: 2.0,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 40,),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 60),
                                    child: Text(
                                      'Coming Soon',
                                      style: TextStyle(
                                        color: backgroundColor,
                                        letterSpacing: 3.5,
                                        fontSize: 27,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50,),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.grey.withOpacity(0.4),
                                        Colors.grey.withOpacity(0.01),
                                      ]
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30)),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.6),)
                              ),
                              child: BarChartSample1(),
                            ),
                          ),
                        ),
                        SizedBox(height: 50,),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
