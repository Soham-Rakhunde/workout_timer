import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/services/NeuButton.dart';

import '../constants.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  double screenWidth;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  AnimationController playGradientControl;
  Animation<Color> colAnim1, colAnim2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      xOffset = 250;
      yOffset = 140;
      scaleFactor = 0.7;
      isDrawerOpen = true;
      isAboutOpen = false;
    });
    playGradientControl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      reverseDuration: Duration(milliseconds: 1000),
    );
    colAnim1 = ColorTween(
      begin: darkGradient,
      end: lightGradient,
    ).animate(playGradientControl);
    colAnim2 = ColorTween(
      begin: lightGradient,
      end: darkGradient,
    ).animate(playGradientControl);
  }

  double adjusted(double val) => val * screenWidth * perPixel;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    print('In the page');
    return ValueListenableBuilder(
      valueListenable: indexOfMenu,
      builder: (context, val, child) {
        return child;
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOutQuart,
        transform: Matrix4.translationValues(xOffset, yOffset, 100)
          ..scale(scaleFactor),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        onEnd: (() {
          if (isAboutOpen && indexOfMenu.value == 3) {
            print('5animabout');
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: isAboutOpen ? backgroundColor : drawerColor,
              statusBarIconBrightness:
              isAboutOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarColor:
              isAboutOpen ? backgroundColor : drawerColor,
              systemNavigationBarIconBrightness:
              isAboutOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarDividerColor:
              isAboutOpen ? backgroundColor : drawerColor,
            ));
          }
        }),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(isDrawerOpen ? 28 : 0),
        ),
        child: GestureDetector(
          onTap: (() {
            if (!isAboutOpen && indexOfMenu.value == 3) {
              setState(() {
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isAboutOpen = true;
              });
            }
          }),
          onHorizontalDragEnd: ((_) {
            if (!isAboutOpen && indexOfMenu.value == 3) {
              setState(() {
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isAboutOpen = true;
              });
            }
          }),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(isStatsOpen ? 0 : 28),
              ),
              child: Column(
                // mainAxisAlignment:MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50, bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 27),
                          child: Text(
                            'About',
                            style: TextStyle(
                              color: Color(0xFF707070),
                              letterSpacing: 2.0,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        NeuButton(
                          ico: Icon(Icons.menu, size: 30, color: textColor,),
                          onPress: (() {
                            setState(() {
                              xOffset = adjusted(250);
                              yOffset = adjusted(140);
                              scaleFactor = 0.7;
                              isDrawerOpen = true;
                              isAboutOpen = false;
                              SystemChrome.setSystemUIOverlayStyle(
                                  SystemUiOverlayStyle(
                                    statusBarColor: isAboutOpen
                                        ? backgroundColor
                                        : drawerColor,
                                    statusBarIconBrightness:
                                    isAboutOpen ? Brightness.dark : Brightness
                                        .light,
                                    systemNavigationBarColor:
                                    isAboutOpen ? backgroundColor : drawerColor,
                                    systemNavigationBarIconBrightness:
                                    isAboutOpen ? Brightness.dark : Brightness
                                        .light,
                                    systemNavigationBarDividerColor:
                                    isAboutOpen ? backgroundColor : drawerColor,
                                  ));
                            });
                          }),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(100),
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

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
