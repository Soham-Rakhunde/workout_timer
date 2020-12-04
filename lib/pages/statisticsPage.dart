import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/main.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
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
      isStatsOpen = false;
    });
  }

  double adjusted(double val) => val * screenWidth * perPixel;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (isStatsOpen && indexOfMenu.value == 1) {
          setState(() {
            xOffset = adjusted(250);
            yOffset = adjusted(140);
            scaleFactor = 0.7;
            isDrawerOpen = true;
            isStatsOpen = false;
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: isStatsOpen ? backgroundColor : drawerColor,
              statusBarIconBrightness:
                  isStatsOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarColor:
                  isStatsOpen ? backgroundColor : drawerColor,
              systemNavigationBarIconBrightness:
                  isStatsOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarDividerColor:
                  isStatsOpen ? backgroundColor : drawerColor,
            ));
          });
        }
        return false;
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOutQuart,
        transform: Matrix4.translationValues(xOffset, yOffset, 100)
          ..scale(scaleFactor),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        onEnd: (() {
          if (isStatsOpen && indexOfMenu.value == 1) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: isStatsOpen ? backgroundColor : drawerColor,
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
          borderRadius: BorderRadius.circular(28),
        ),
        child: GestureDetector(
          onTap: (() {
            if (!isStatsOpen && indexOfMenu.value == 1) {
              setState(() {
                xOffset = 0;
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
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isStatsOpen = true;
              });
            }
          }),
          child: Scaffold(
            backgroundColor: drawerColor,
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(isStatsOpen ? 0 : 28),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
