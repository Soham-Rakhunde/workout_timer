import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_timer/main.dart';

import '../constants.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  double screenWidth;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

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
  }

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
            onWillPop: () async {
              print('wp');
              if (isAboutOpen && indexOfMenu.value == 3) {
                setState(() {
                  print('is in it');
                  xOffset = 250;
                  yOffset = 140;
                  scaleFactor = 0.7;
                  isDrawerOpen = true;
                  isAboutOpen = false;
                  print('6popabout');
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
                });
              }
              return false;
            },
            child: Scaffold(),
          ),
        ),
      ),
    );
  }
}
