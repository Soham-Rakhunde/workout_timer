import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/pages/DonatePage.dart';
import 'package:workout_timer/pages/aboutPage.dart';
import 'package:workout_timer/pages/drawerPage.dart';
import 'package:workout_timer/pages/homepage.dart';
import 'package:workout_timer/pages/settingsPage.dart';
import 'package:workout_timer/pages/statisticsPage.dart';
import 'package:workout_timer/pages/timerpage.dart';
import 'package:workout_timer/services/scaleFactor.dart';
import 'package:workout_timer/services/timeValueHandler.dart';

ValueNotifier<bool> isDark = ValueNotifier<bool>(false);
bool isDrawerOpen = false;
bool isHomeOpen = true;
bool isAboutOpen = false;
bool isStatsOpen = false;
bool isDonateOpen = false;
bool isSettingsOpen = false;
const perPixel = 0.0025641025641026;

void main() {
  Future.delayed(Duration(milliseconds: 1)).then(
      (value) => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            // isHomeOpen
            //     ? backgroundColor
            //     : drawerColor,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0xFFF1F2F6),
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarDividerColor: Color(0xFFF1F2F6),
          ))
  );
  Future.delayed(Duration(milliseconds: 1)).then(
    (value) => SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        ]
      )
  );
  runApp(MaterialApp(
    debugShowMaterialGrid: false,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Montserrat',
    ),
    initialRoute: '/home',
    routes: {
      '/home': (context) => mainPage(),
      '/timer': (context) => TimerPage(),
    },
  ));
}

class mainPage extends StatefulWidget {
  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<mainPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  SharedPref savedData = SharedPref();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 500),
    );
  }

  Future<bool> _getData() async {
    isDark.value = await savedData.readBool('isDark');
    backgroundColor = backgroundC[isDark.value ? 1 : 0];
    shadowColor = shadowC[isDark.value ? 1 : 0];
    lightShadowColor = lightShadowC[isDark.value ? 1 : 0];
    textColor = textC[isDark.value ? 1 : 0];
    return isDark.value;
  }

  double screenWidth;

  double adjusted(double val) => val * screenWidth * perPixel;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => true,
      child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              return Center(
                  child: Image.asset(
                'assets/icon.png',
                width: screenWidth / 5,
              ));
            } else {
              return Scaffold(
                backgroundColor: drawerColor,
                body: Stack(
                  children: [
                    drawerPage(),
                    Positioned(
                      left: 200,
                      top: 140 + SizeConfig.screenHeight * 0.05,
                      child: GestureDetector(
                        onTap: () async {
                          final periodTime = TimeClass(
                            name: 'Workout',
                            sec: int.parse(controller['periodMin'].text) * 60 +
                                int.parse(controller['periodSec'].text),
                          );
                          final breakTime = TimeClass(
                            name: 'Break',
                            sec: int.parse(controller['breakMin'].text) * 60 +
                                int.parse(controller['breakSec'].text),
                          );
                          await Navigator.push(
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
                        },
                        child: ValueListenableBuilder(
                          valueListenable: isDark,
                          builder: (context, val, child) {
                            return Container(
                                height: MediaQuery.of(context).size.height * .6,
                                width: MediaQuery.of(context).size.width * .6,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(17),
                                  child: Image.asset(
                                    'assets/progressImg${isDark.value ? 1 : 0}.${isDark.value ? 'jpg' : 'png'}',
                                    alignment: Alignment.centerLeft,
                                  ),
                                ));
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      left: 240,
                      top: 140 + SizeConfig.screenHeight * 0.05,
                      child: ValueListenableBuilder(
                        valueListenable: isDark,
                        builder: (context, val, child) {
                          return Container(
                            height: MediaQuery.of(context).size.height * .6,
                            width: SizeConfig.sw * 20,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: shadowColor, blurRadius: 12),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: indexOfMenu,
                      builder: (context, value, _) {
                        return IndexedStack(
                          index: indexOfMenu.value,
                          children: [
                            HomePage(),
                            StatisticsPage(),
                            DonatePage(),
                            AboutPage(),
                            SettingsPage(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}