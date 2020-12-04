import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/services/NeuButton.dart';

class DonatePage extends StatefulWidget {
  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage>
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
      isDonateOpen = false;
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
          if (isDonateOpen && indexOfMenu.value == 2) {
            print('5animabout');
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: isDonateOpen ? backgroundColor : drawerColor,
              statusBarIconBrightness:
                  isDonateOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarColor:
                  isDonateOpen ? backgroundColor : drawerColor,
              systemNavigationBarIconBrightness:
                  isDonateOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarDividerColor:
                  isDonateOpen ? backgroundColor : drawerColor,
            ));
          }
        }),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(isDrawerOpen ? 28 : 0),
        ),
        child: GestureDetector(
          onTap: (() {
            if (!isDonateOpen && indexOfMenu.value == 2) {
              setState(() {
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isDonateOpen = true;
              });
            }
          }),
          onHorizontalDragEnd: ((_) {
            if (!isDonateOpen && indexOfMenu.value == 2) {
              setState(() {
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isDonateOpen = true;
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
                    Expanded(
                      flex: 6,
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
                            ico: Icon(
                              Icons.menu,
                              size: 30,
                              color: textColor,
                            ),
                            onPress: (() {
                              setState(() {
                                xOffset = adjusted(250);
                                yOffset = adjusted(140);
                                scaleFactor = 0.7;
                                isDrawerOpen = true;
                                isDonateOpen = false;
                                SystemChrome.setSystemUIOverlayStyle(
                                    SystemUiOverlayStyle(
                                  statusBarColor: isDonateOpen
                                      ? backgroundColor
                                      : drawerColor,
                                  statusBarIconBrightness: isDonateOpen
                                      ? Brightness.dark
                                      : Brightness.light,
                                  systemNavigationBarColor: isDonateOpen
                                      ? backgroundColor
                                      : drawerColor,
                                  systemNavigationBarIconBrightness:
                                      isDonateOpen
                                          ? Brightness.dark
                                          : Brightness.light,
                                  systemNavigationBarDividerColor: isDonateOpen
                                      ? backgroundColor
                                      : drawerColor,
                                ));
                              });
                            }),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 20,
                      child: Container(),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
