import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workout_timer/constants.dart';
import 'file:///D:/Software/Coding/workout_timer/lib/services/customWidgets/NeuButton.dart';
import 'file:///D:/Software/Coding/workout_timer/lib/services/customWidgets/progressBuilder.dart';
import 'package:workout_timer/services/timeValueHandler.dart';


class TimerPage extends StatelessWidget {

  TimerPage({this.args});

  List args = [];
  ValueNotifier<String> _titleName = ValueNotifier<String>('Start');
  ValueNotifier<int> timeInSec = ValueNotifier<int>(5);
  ValueNotifier<int> i = ValueNotifier<int>(1);
  ValueNotifier<double> tickTime = ValueNotifier<double>(0);
  ValueNotifier<double> progress = ValueNotifier<double>(0);
  int s,totalTime;
  ValueNotifier<bool> resumeFlag = ValueNotifier<bool>(true);
  TimeClass periodT,breakT;


  void startTimer(int time) async {
    while(timeInSec.value >= 0){
      while(!resumeFlag.value){
        await Future.delayed(Duration(milliseconds: 100));
      }
      if(i.value >s){
        break;
      }
      tickTime.value = ((time - timeInSec.value)/time)*100;
      progress.value += 100/totalTime;
      print('${progress.value}');
      await Future.delayed(Duration(seconds: 1));
      timeInSec.value--;
    }
    tickTime.value = ((time - timeInSec.value)/time)*100;
  }

  void timerFunc() async{
    tickTime.value = 100;
    timeInSec.value = 5;
    await Future.delayed(Duration(seconds: 1));
    timeInSec.value = 4;
    tickTime.value = 0;
    await Future.delayed(Duration(seconds: 1));
    tickTime.value = 100;
    timeInSec.value = 3;
    await Future.delayed(Duration(seconds: 1));
    tickTime.value = 0;
    timeInSec.value = 2;
    await Future.delayed(Duration(seconds: 1));
    tickTime.value = 100;
    timeInSec.value = 1;
    await Future.delayed(Duration(seconds: 1));
    if(timeInSec.value>0) {
      do {
        _titleName.value = periodT.name;
        timeInSec.value = periodT.sec;
        await startTimer(periodT.sec);
        if (i.value != s) {
          _titleName.value = breakT.name;
          timeInSec.value = breakT.sec;
          await startTimer(breakT.sec);
        }
        i.value++;
      } while (i.value <= s);
      i.value--;
    }
    timeInSec.value = 0;
  }

  @override
  build(BuildContext context) {
    periodT = args[0];
    breakT = args [1];
    s = args[2];
    totalTime = periodT.sec*s + breakT.sec*(s-1);
    print('$totalTime');
    timerFunc();
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child:Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backgroundColor,
          body: TweenAnimationBuilder(
            tween: Tween<double>(begin: 1,end: 0),
            duration: Duration(seconds: 1),
            builder: (BuildContext context, double value, Widget _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ValueListenableBuilder<String>(
                      valueListenable: _titleName,
                      builder: (context, value, child){
                        return Text(
                          _titleName.value,
                          style:TextStyle(
                            color: Color(0xFF707070),
                            letterSpacing: 2.0,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: MediaQuery.of(context).size.width - 50,
                    child: buildStack(
                      tickTime: tickTime,
                      timeInSec: timeInSec,
                      i: i,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width/2 - 40,
                          padding: EdgeInsets.only(top: 20,left: 25, right: 25,bottom: 20),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                  color: shadowColor, offset: Offset(8 - value*8, 6 - value*6), blurRadius: 12),
                              BoxShadow(
                                  color: lightShadowColor,
                                  offset: Offset(-8 + value*8, -6 + value*6),
                                  blurRadius: 12),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Set',
                                style: kTextStyle.copyWith(
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 20,),
                              ValueListenableBuilder(
                                valueListenable: i,
                                builder: (context, value, child) {
                                  return Text(
                                    '${i.value}/$s',
                                    style: kTextStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width/2 - 40,
                          padding: EdgeInsets.only(top: 20,left: 25, right: 25,bottom: 20),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                  color: shadowColor, offset: Offset(8, 6), blurRadius: 12),
                              BoxShadow(
                                  color: lightShadowColor,
                                  offset: Offset(-8, -6),
                                  blurRadius: 12),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Progress',
                                style: kTextStyle.copyWith(
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 20,),
                              ValueListenableBuilder(
                                valueListenable: progress,
                                builder: (context, value, child) {
                                  return Text(
                                    progress.value>=99.5?'100':'${progress.value.toStringAsFixed(0)}%',
                                    style: kTextStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        Spacer(
                          flex: 1,
                        ),
                        Hero(
                          tag: 'leftButton',
                          child: NeuButton(
                            onPress: (() {
                              i.value = s+1;
                              timeInSec.value = 0;
                              Navigator.pop(context);
                            }),
                            ico: Icon(Icons.stop_rounded,size: 30,color: textColor,),
                          ),
                        ),
                        Spacer(
                          flex: 10,
                        ),
                        ValueListenableBuilder(
                          valueListenable: resumeFlag,
                          builder: (context, value, child) {
                            return Hero(
                              tag: 'rightButton',
                              child: NeuButton(
                                flag: resumeFlag.value,
                                animated: true,
                                ico: AnimatedIcons.pause_play,
                                onPress: (() {
                                  resumeFlag.value = ! resumeFlag.value;
                                }),
                              ),
                            );
                          },
                        ),
                        Spacer(
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
