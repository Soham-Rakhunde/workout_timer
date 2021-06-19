import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/pages/DonatePage.dart';
import 'package:workout_timer/pages/aboutPage.dart';
import 'package:workout_timer/pages/advancedPage.dart';
import 'package:workout_timer/pages/drawerPage.dart';
import 'package:workout_timer/pages/homepage.dart';
import 'package:workout_timer/pages/settingsPage.dart';
import 'package:workout_timer/pages/statisticsPage.dart';
import 'package:workout_timer/pages/timerpage.dart';
import 'package:workout_timer/services/scaleFactor.dart';
import 'package:workout_timer/services/timeValueHandler.dart';

ValueNotifier<bool?> isDark = ValueNotifier<bool?>(false);
bool openedAfterDbUpdate = false;
bool? isContrast = false;
bool isDrawerOpen = false;
bool isHomeOpen = true;
bool isAboutOpen = false;
bool isStatsOpen = false;
bool isDonateOpen = false;
bool isSettingsOpen = false;
bool isAdvancedOpen = false;
const perPixel = 0.0025641025641026;
DisplayMode? selected;
List<SetClass>? editGroups = [];

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
          )));
  Future.delayed(Duration(milliseconds: 1))
      .then((value) => SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]));
  // InAppPurchaseConnection.enablePendingPurchases();
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

class _mainPageState extends State<mainPage> {
  SharedPref savedData = SharedPref();

  DisplayMode? selected;

  List<DisplayMode> modesList = <DisplayMode>[];

  int? refreshId = 1;

  Future<bool> fetchModes() async {
    try {
      modesList = await FlutterDisplayMode.supported;

      /// On OnePlus 7 Pro:
      /// #1 1080x2340 @ 60Hz
      /// #2 1080x2340 @ 90Hz
      /// #3 1440x3120 @ 90Hz
      /// #4 1440x3120 @ 60Hz
      /// On OnePlus 8 Pro:
      /// #1 1080x2376 @ 60Hz
      /// #2 1440x3168 @ 120Hz
      /// #3 1440x3168 @ 60Hz
      /// #4 1080x2376 @ 120Hz
    } on PlatformException catch (e) {
      print(e);

      /// e.code =>
      /// noAPI - No API support. Only Marshmallow and above.
      /// noActivity - Activity is not available. Probably app is in background
    }
    selected = await FlutterDisplayMode.active;
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool?> _getData() async {
    isDark.value = await savedData.readBool('isDark');
    String? temp = await savedData.readString('ReleaseDateOfDatabase');
    openedAfterDbUpdate = temp != null;
    isContrast = await savedData.readBool('isContrast');
    backgroundColor = backgroundC[isDark.value! ? 1 : 0];
    shadowColor = shadowC[isDark.value! ? 1 : 0];
    lightShadowColor = lightShadowC[isDark.value! ? 1 : 0];
    textColor = isContrast! ? Colors.black : textC[isDark.value! ? 1 : 0];
    await fetchModes();
    if (modesList.length > 1) {
      refreshId = await savedData.readInt('deviceModeId');
      modesList.forEach((element) async {
        if (element.id == refreshId) {
          await FlutterDisplayMode.setPreferredMode(element);
          if (mounted) {
            setState(() {});
          }
        }
      });
    }
    return isDark.value;
  }

  late double screenWidth;

  double adjusted(double val) => val * screenWidth * perPixel;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // final DisplayMode mode = await getCurrentMode();
        // fetchModes();
        // print(mode);
        // print(mode.toString());
        return true;
      },
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
                            isWork: true,
                            sec: Duration(
                              minutes: int.parse(controller['periodMin'].text),
                              seconds: int.parse(controller['periodSec'].text),
                            ).inSeconds,
                          );
                          final breakTime = TimeClass(
                            name: 'Break',
                            isWork: false,
                            sec: Duration(
                              minutes: int.parse(controller['breakMin'].text),
                              seconds: int.parse(controller['breakSec'].text),
                            ).inSeconds,
                          );
                          final set1 = SetClass(
                            grpName: '',
                            timeList: [
                              periodTime,
                            ],
                            sets: int.parse(controller['sets'].text),
                          );
                          final page = TimerPage(
                            isRest: true,
                            args: [set1],
                            breakTime: breakTime,
                          );
                          await Navigator.push(
                              context,
                              PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 250),
                                  reverseTransitionDuration:
                                      Duration(milliseconds: 150),
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
                                    return page;
                                  }));
                        },
                        child: ValueListenableBuilder(
                          valueListenable: isDark,
                          builder: (context, dynamic val, child) {
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
                                    'assets/progressImg${isDark.value! ? 1 : 0}.${isDark.value! ? 'jpg' : 'png'}',
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
                        builder: (context, dynamic val, child) {
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
                            AdvancedPage(),
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