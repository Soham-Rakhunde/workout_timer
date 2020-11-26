import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/pages/aboutPage.dart';
import 'package:workout_timer/pages/drawerPage.dart';
import 'package:workout_timer/pages/homepage.dart';
import 'package:workout_timer/pages/timerpage.dart';

bool isDrawerOpen = false;
bool isHomeOpen = true;
bool isAboutOpen = false;
const perPixel = 0.0025641025641026;

void main() {
  Future.delayed(Duration(milliseconds: 1)).then(
      (value) => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Color(0xFFF1F2F6),
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

  void indexOfMenuCallback() {
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('1main');
    return Scaffold(
      backgroundColor: drawerColor,
      body: Stack(
        children: [
          drawerPage(),
          Positioned(
            left: 200,
            top: 180,
            child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .6,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * .6,
                padding: EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Image.asset('assets/progressImg.png')
            ),
          ),
          Positioned(
            left: 240,
            top: 180,
            child: Container(
              height: MediaQuery.of(context).size.height*.6,
              width: 20,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 12
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: indexOfMenu,
            builder: (context, value, _) {
              print('2stackmain');
              return IndexedStack(
                index: indexOfMenu.value,
                children: [
                  HomePage(),
                  Container(color: Colors.red,),
                  Container(color: Colors.blue,),
                  AboutPage(),
                  Container(color: Colors.green,),
                ],
              );
            },
          ),
          // AnimatedBuilder(
          //   animation: _animationController,
          //   builder: (BuildContext context, Widget child) {
          //     print('builder');
          //     if(indexOfMenu.value == 0){
          //       print('');
          //     }else if(indexOfMenu.value == 3){
          //       Navigator.push(context, PageRouteBuilder(
          //         transitionDuration: Duration(milliseconds:700),
          //         reverseTransitionDuration: Duration(milliseconds:250),
          //         transitionsBuilder:(BuildContext context,Animation<double> animation,Animation<double> secAnimation, Widget child){
          //           return FadeTransition(
          //             opacity: animation,
          //             child: child,
          //           );
          //         },
          //         pageBuilder: (BuildContext context,Animation<double> animation,Animation<double> secAnimation){
          //           return AboutPage();
          //         }
          //     ));
          //   }
          //
          // },
          // ),
        ],
      ),
    );
  }
}