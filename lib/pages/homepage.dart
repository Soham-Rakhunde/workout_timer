import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/pages/savedAccesspage.dart';
import 'package:workout_timer/pages/timerpage.dart';
import 'package:workout_timer/services/GenericFunctions.dart';
import 'package:workout_timer/services/NeuButton.dart';
import 'package:workout_timer/services/animIcon/gradientIcon.dart';
import 'package:workout_timer/services/myTextField.dart';
import 'package:workout_timer/services/timeValueHandler.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  AnimationController playGradientControl;
  Animation<Color> colAnim1, colAnim2;
  ValueNotifier<String> _titleName = ValueNotifier<String>('Timer');
  TextEditingController dialogController = TextEditingController();
  double _opacity = 0;
  double screenWidth;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  List<String> savedList = List<String>();
  SharedPref savedData = SharedPref();

  @override
  void initState() {
    super.initState();
    for (String controllerName in controller.keys) {
      initListenerMaker(controllerName);
    }
    playGradientControl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      reverseDuration: Duration(milliseconds: 1000),
    );
    colAnim1= ColorTween(
      begin: darkGradient,
      end: lightGradient,
    ).animate(playGradientControl);
    colAnim2 = ColorTween(
      begin: lightGradient,
      end: darkGradient,
    ).animate(playGradientControl);

    _opacity =0;

    playGradientControl.forward();
    playGradientControl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        playGradientControl.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        playGradientControl.forward();
      }
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // isHomeOpen
      //     ? backgroundColor
      //     : drawerColor,
      statusBarIconBrightness: isHomeOpen ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isHomeOpen ? backgroundColor : drawerColor,
      systemNavigationBarIconBrightness:
          isHomeOpen ? Brightness.dark : Brightness.light,
      systemNavigationBarDividerColor:
          isHomeOpen ? backgroundColor : drawerColor,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    for(String controllerName in controller.keys){
      controller[controllerName].dispose();
    }
    dialogController.dispose();
    playGradientControl.dispose();
  }

  void addRemove(bool flag,String _controllerName) {
    int intValue = int.parse(controller[_controllerName].text);
    intValue = intValue - (flag ? -1 : 1);
    if(_controllerName == 'sets'){
      if(intValue<=0){
        intValue = 1;
      }else if (intValue>=100){
        intValue = 99;
      }
    }else if(_controllerName == 'breakSec'){
      if(intValue<0){
        intValue = 59;
        addRemove(false, 'breakMin');
      }else if (intValue>=60){
        intValue = 00;
        addRemove(true, 'breakMin');
      }
    }else if(_controllerName == 'periodSec'){
      if(intValue<0){
        intValue = 59;
        addRemove(false, 'periodMin');
      }else if (intValue>=60) {
        intValue = 00;
        addRemove(true, 'periodMin');
      }
    }else{
      if(intValue<0){
        intValue = 59;
      }else if (intValue>=60) {
        intValue = 00;
      }
    }
    String v = '$intValue';
    v = v.length == 1 ? '0$v' : v;
    setState(() {
      controller[_controllerName].text = v;
    });
  }

  double adjusted(double val) => val*screenWidth*perPixel;

  @override
  Widget build(BuildContext context) {
    _opacity = 1;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return ValueListenableBuilder(
      valueListenable: indexOfMenu,
      builder: (context, val, child) {
        return child;
      },
      child: AnimatedContainer(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        duration: Duration(milliseconds: 450),
        curve: Curves.easeInOutQuart,
        transform: Matrix4.translationValues(xOffset, yOffset, 100)
          ..scale(scaleFactor),
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: double.infinity,
        onEnd: (() {
          if (isHomeOpen && indexOfMenu.value == 0) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              // isHomeOpen
              //     ? backgroundColor
              //     : drawerColor,
              statusBarIconBrightness:
              isHomeOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarColor:
              isHomeOpen ? backgroundColor : drawerColor,
              systemNavigationBarIconBrightness:
              isHomeOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarDividerColor:
              isHomeOpen ? backgroundColor : drawerColor,
            ));
          }
        }),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(isHomeOpen ? 0 : 28),
        ),
        child: GestureDetector(
          onTap: (() {
            if (!isHomeOpen && indexOfMenu.value == 0) {
              setState(() {
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isHomeOpen = true;
              });
            }
          }),
          onHorizontalDragEnd: ((_) {
            if (!isHomeOpen && indexOfMenu.value == 0) {
              setState(() {
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isHomeOpen = true;
              });
            }
          }),
          child:
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
            opacity: _opacity,
            child: AbsorbPointer(
              absorbing: !isHomeOpen,
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
                          child: ValueListenableBuilder<String>(
                            valueListenable: _titleName,
                            builder: (context, value, child) {
                              return Text(
                                _titleName.value,
                                style: TextStyle(
                                  color: Color(0xFF707070),
                                  letterSpacing: 2.0,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
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
                              isHomeOpen = false;
                              SystemChrome.setSystemUIOverlayStyle(
                                  SystemUiOverlayStyle(
                                statusBarColor: Colors.transparent,
                                // isHomeOpen
                                //     ? backgroundColor
                                //     : drawerColor,
                                statusBarIconBrightness: isHomeOpen
                                    ? Brightness.dark
                                    : Brightness.light,
                                systemNavigationBarColor:
                                    isHomeOpen ? backgroundColor : drawerColor,
                                systemNavigationBarIconBrightness: isHomeOpen
                                    ? Brightness.dark
                                    : Brightness.light,
                                systemNavigationBarDividerColor:
                                    isHomeOpen ? backgroundColor : drawerColor,
                              ));
                            });
                          }),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: Text(
                              'TIME / SET',
                              style: kTextStyle,
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NeuButton(
                                ico: Icon(
                                  Icons.remove_rounded,
                                  size: 30,
                                  color: textColor,
                                ),
                                onPress: (() {
                                  addRemove(false, 'periodSec');
                                }),
                              ),
                              Container(
                                width: 40,
                                alignment: Alignment.center,
                                child: myTextField(
                                  controllerName: 'periodMin',
                                  func: (val) {
                                    setState(() {
                                      retain['periodMin'] = val;
                                      controller['periodMin'].text = val;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                  child: Text(
                                ':',
                                style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: textColor,
                                ),
                              )),
                              Container(
                                width: 40,
                                alignment: Alignment.center,
                                child: myTextField(
                                  controllerName: 'periodSec',
                                  func: (val) {
                                    setState(() {
                                      retain['periodSec'] = val;
                                      controller['periodSec'].text = val;
                                    });
                                  },
                                ),
                              ),
                              NeuButton(
                                ico: Icon(
                                  Icons.add_rounded,
                                  size: 30,
                                  color: textColor,
                                ),
                                onPress: (() {
                                  addRemove(true, 'periodSec');
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'BREAK',
                            style: kTextStyle,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NeuButton(
                                ico: Icon(
                                  Icons.remove_rounded,
                                  size: 30,
                                  color: textColor,
                                ),
                                onPress: (() {
                                  addRemove(false, 'breakSec');
                                }),
                              ),
                              Container(
                                width: 40,
                                alignment: Alignment.center,
                                child: myTextField(
                                  controllerName: 'breakMin',
                                  func: (val) {
                                    setState(() {
                                      retain['breakMin'] = val;
                                      controller['breakMin'].text = val;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                child: Text(
                                  ':',
                                  style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              Container(
                                  width: 40,
                                  alignment: Alignment.center,
                                  child: myTextField(
                                    controllerName: 'breakSec',
                                    func: (val) {
                                      setState(() {
                                        retain['breakSec'] = val;
                                        controller['breakSec'].text = val;
                                      });
                                    },
                                  )),
                              NeuButton(
                                ico: Icon(
                                  Icons.add_rounded,
                                  size: 30,
                                  color: textColor,
                                ),
                                onPress: (() {
                                  addRemove(true, 'breakSec');
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'SETS',
                            style: kTextStyle,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NeuButton(
                                ico: Icon(
                                  Icons.remove_rounded,
                                  size: 30,
                                  color: textColor,
                                ),
                                onPress: (() {
                                  addRemove(false, 'sets');
                                }),
                              ),
                              Container(
                                width: 90,
                                child: myTextField(
                                  controllerName: 'sets',
                                  func: (val) {
                                    setState(() {
                                      retain['sets'] = val;
                                      controller['sets'].text = val;
                                    });
                                  },
                                ),
                              ),
                              NeuButton(
                                ico: Icon(
                                  Icons.add_rounded,
                                  size: 30,
                                  color: textColor,
                                ),
                                onPress: (() {
                                  addRemove(true, 'sets');
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Hero(
                          tag: 'leftButton',
                          child: NeuButton(
                            ico: Icon(
                              Icons.bookmark_border_rounded,
                              size: 30,
                              color: textColor,
                            ),
                            onPress: (() async {
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
                                        return savedPage();
                                      }));
                            }),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: playGradientControl,
                          builder: (BuildContext context, Widget child) {
                            return NeuButton(
                              ico: GradientIcon(
                                icon: Icons.play_arrow_rounded,
                                size: 55,
                                gradient: RadialGradient(colors: <Color>[
                                  colAnim1.value,
                                  colAnim2.value,
                                ], focal: Alignment.center),
                              ),
                              length: screenWidth / 4.6,
                              breadth: screenWidth / 4.6,
                              radii: 50,
                              onPress: (() async {
                                if (controller['periodSec'] == '') {
                                  controller['periodSec'] = '30';
                                }
                                if (controller['periodMin'] == '') {
                                  controller['periodMin'] = '0';
                                }
                                if (controller['periodSec'] == '') {
                                  controller['periodSec'] = '30';
                                }
                                if (controller['breakMin'] == '') {
                                  controller['breakMin'] = '0';
                                }
                                if (controller['breakSec'] == '') {
                                  controller['breakSec'] = '30';
                                }
                                if (controller['sets'] == '') {
                                  controller['sets'] = '3';
                                }
                                final periodTime = TimeClass(
                                  name: 'Workout',
                                  sec: int.parse(controller['periodMin'].text) *
                                          60 +
                                      int.parse(controller['periodSec'].text),
                                );
                                final breakTime = TimeClass(
                                  name: 'Break',
                                  sec: int.parse(controller['breakMin'].text) *
                                          60 +
                                      int.parse(controller['breakSec'].text),
                                );
                                await Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 700),
                                        reverseTransitionDuration:
                                            Duration(milliseconds: 250),
                                        transitionsBuilder:
                                            (BuildContext context,
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
                                              int.parse(
                                                  controller['sets'].text),
                                            ],
                                          );
                                        }));
                              }),
                            );
                          },
                        ),
                        Hero(
                          tag: 'rightButton',
                          child: NeuButton(
                            ico: Icon(
                              Icons.save_outlined,
                              size: 30,
                              color: textColor,
                            ),
                            onPress: (() async {
                              await createDialog(context);
                              if (controller['periodSec'] == '') {
                                controller['periodSec'] = '30';
                              }
                              if (controller['periodMin'] == '') {
                                controller['periodMin'] = '0';
                              }
                              if (controller['periodSec'] == '') {
                                controller['periodSec'] = '30';
                              }
                              if (controller['breakMin'] == '') {
                                controller['breakMin'] = '0';
                              }
                              if (controller['breakSec'] == '') {
                                controller['breakSec'] = '30';
                              }
                              if (controller['sets'] == '') {
                                controller['sets'] = '3';
                              }
                              savedList = await savedData.read();
                              SavedWorkout _data = SavedWorkout(
                                name: stringFormatter(dialogController.text),
                                pSec: int.parse(controller['periodSec'].text),
                                pMin: int.parse(controller['periodMin'].text),
                                bSec: int.parse(controller['breakSec'].text),
                                bMin: int.parse(controller['breakMin'].text),
                                setsCount: int.parse(controller['sets'].text),
                              );
                              // print('Encoded ${jsonEncode(_data.toMap())}');
                              savedList.add(jsonEncode(_data.toMap()));
                              // print('new data $savedList');
                              await savedData.save(savedList);
                            }),
                          ),
                        ),
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

  void initListenerMaker(String key){
    if(retain[key]=='-1'){
      if(key == 'sets'){
        setState(() {
          retain[key] = '03';
          controller[key].text = '03';
        });
      }else if((key == 'breakSec') || (key == 'periodSec')){
        setState(() {
          retain[key] = '30';
          controller[key].text = '30';
        });
      }else{
        setState(() {
          retain[key] = '00';
          controller[key].text = '00';
        });
      }
    }else{
      setState(() {
        controller[key].text = retain[key];
      });
    }
    controller[key].addListener(() {
      controller[key].selection = TextSelection(
        baseOffset: controller[key].text.length,
        extentOffset: controller[key].text.length,
      );
    });
  }

  Future<String> createDialog (BuildContext context){
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          backgroundColor: backgroundColor,
          titlePadding: EdgeInsets.fromLTRB(30,30,30,10),
          contentPadding: EdgeInsets.fromLTRB(30,10,30,10),
          actionsPadding: EdgeInsets.only(top:10,bottom: 15, right: MediaQuery.of(context).size.width/4),
          title: Center(
            child: Text(
              'Enter Workout Name',
              style: TextStyle(
                color: Color(0xFF707070),
                fontSize: 22,
              ),
            ),
          ),
          content: AnimatedBuilder(
              animation: playGradientControl,
              builder: (BuildContext context, Widget child) {
                return Container(
                  height: 150,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        colAnim1.value,
                        colAnim2.value,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: shadowColor, offset: Offset(8, 6), blurRadius: 12),
                      BoxShadow(
                          color: lightShadowColor,
                          offset: Offset(-8, -6),
                          blurRadius: 12),
                    ],
                  ),
                  child: TextField(
                    controller: dialogController,
                    style: kTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    decoration: kInputDecor,
                    cursorColor: Colors.grey,
                  ),
                );
              }
          ),
          actions: [
            Center(
              child: MaterialButton(
                onPressed: ((){
                  if(dialogController.value.text!= '') {
                    Navigator.pop(context);
                    _titleName.value = stringFormatter(dialogController.value.text);
                  }
                }),
                child: Text(
                  'Save',
                  style: kTextStyle.copyWith(
                    fontSize: 25,
                    fontFamily: 'MontserratBold',
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

}