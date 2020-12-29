import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wakelock/wakelock.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/services/NeuButton.dart';
import 'package:workout_timer/services/progressBuilder.dart';
import 'package:workout_timer/services/timeValueHandler.dart';

class TimerPage extends StatefulWidget {
  TimerPage({this.args});

  List args = [];

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  AudioCache audioPlayer;

  ValueNotifier<String> _titleName = ValueNotifier<String>('Start');

  ValueNotifier<int> timeInSec = ValueNotifier<int>(5);

  ValueNotifier<int> i = ValueNotifier<int>(1);

  ValueNotifier<double> tickTime = ValueNotifier<double>(0);

  ValueNotifier<double> progress = ValueNotifier<double>(0);

  int s, totalTime;

  ValueNotifier<bool> resumeFlag = ValueNotifier<bool>(true);

  TimeClass periodT, breakT;

  String voice;

  bool isVoice;

  SharedPref savedData = SharedPref();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    Wakelock.enable();
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
  }

  Future<bool> _getData() async {
    isVoice = await savedData.readBool('isVoice');
    voice = await savedData.readString('Voice');
    if (isVoice) {
      audioPlayer = AudioCache(prefix: 'assets/audio/$voice/');
      audioPlayer.loadAll([
        'greet-$voice.mp3',
        'start-$voice.mp3',
        'rest-$voice.mp3',
        'finish-$voice.mp3',
        '1-$voice.mp3',
        '2-$voice.mp3',
        '3-$voice.mp3',
        '4-$voice.mp3',
        '5-$voice.mp3',
      ]);
    }
    return isVoice;
  }

  void startTimer(int time) async {
    while (timeInSec.value >= 0) {
      while (!resumeFlag.value) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      if (i.value > s) {
        break;
      }
      tickTime.value = ((time - timeInSec.value) / time) * 100;
      progress.value += 100 / totalTime;
      if (timeInSec.value <= 5 && timeInSec.value > 0 && isVoice) {
        audioPlayer.play('${timeInSec.value}-$voice.mp3');
      }
      await Future.delayed(Duration(seconds: 1));
      timeInSec.value--;
    }
    tickTime.value = ((time - timeInSec.value)/time)*100;
  }

  void timerFunc() async{
    tickTime.value = 100;
    timeInSec.value = 5;
    if (isVoice) audioPlayer.play('5-$voice.mp3');
    await Future.delayed(Duration(seconds: 1));
    timeInSec.value = 4;
    tickTime.value = 0;
    if (isVoice) audioPlayer.play('4-$voice.mp3');
    await Future.delayed(Duration(seconds: 1));
    tickTime.value = 100;
    timeInSec.value = 3;
    if (isVoice) audioPlayer.play('3-$voice.mp3');
    await Future.delayed(Duration(seconds: 1));
    tickTime.value = 0;
    timeInSec.value = 2;
    if (isVoice) audioPlayer.play('2-$voice.mp3');
    await Future.delayed(Duration(seconds: 1));
    tickTime.value = 100;
    timeInSec.value = 1;
    if (isVoice) audioPlayer.play('1-$voice.mp3');
    await Future.delayed(Duration(seconds: 1));
    if(timeInSec.value>0) {
      do {
        if (isVoice) audioPlayer.play('start-$voice.mp3');
        _titleName.value = periodT.name;
        timeInSec.value = periodT.sec;
        await startTimer(periodT.sec);
        if (i.value != s) {
          _titleName.value = breakT.name;
          timeInSec.value = breakT.sec;
          if (i.value != s + 1 && isVoice) {
            audioPlayer.play('rest-$voice.mp3');
          }
          await startTimer(breakT.sec);
        }
        i.value++;
      } while (i.value <= s);
      i.value--;
    }
    if (isVoice) audioPlayer.clearCache();
    timeInSec.value = 0;
  }

  @override
  build(BuildContext context) {
    periodT = widget.args[0];
    breakT = widget.args[1];
    s = widget.args[2];
    totalTime = periodT.sec * s + breakT.sec * (s - 1);
    return WillPopScope(
      onWillPop: () async => createAlertDialog(context),
      child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              return Center(child: Text('Loading'));
            } else {
              timerFunc();
              return Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: backgroundColor,
                body: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 1, end: 0),
                  duration: Duration(seconds: 1),
                  builder: (BuildContext context, double value, Widget _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: ValueListenableBuilder<String>(
                            valueListenable: _titleName,
                            builder: (context, value, child) {
                              return Text(
                                _titleName.value,
                                style: TextStyle(
                                  color: textColor,
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
                                width:
                                    MediaQuery.of(context).size.width / 2 - 40,
                                padding: EdgeInsets.only(
                                    top: 20, left: 25, right: 25, bottom: 20),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                        color: shadowColor,
                                        offset: Offset(
                                            8 - value * 8, 6 - value * 6),
                                        blurRadius: 12),
                                    BoxShadow(
                                        color: lightShadowColor,
                                        offset: Offset(
                                            -8 + value * 8, -6 + value * 6),
                                        blurRadius: 12),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Set',
                                      style: kTextStyle.copyWith(
                                        letterSpacing: 0.5,
                                        color: isDark.value
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: i,
                                      builder: (context, value, child) {
                                        return Text(
                                          '${i.value}/$s',
                                          style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 40,
                                            color: isDark.value
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )),
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 40,
                                padding: EdgeInsets.only(
                                    top: 20, left: 25, right: 25, bottom: 20),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(32),
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
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Progress',
                                      style: kTextStyle.copyWith(
                                        letterSpacing: 0.5,
                                        color: isDark.value
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: progress,
                                      builder: (context, value, child) {
                                        return Text(
                                          progress.value >= 99.5
                                              ? '100'
                                              : '${progress.value.toStringAsFixed(0)}%',
                                          style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 40,
                                            color: isDark.value
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )),
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
                                    if (isVoice) {
                                      AudioCache finishPlayer = AudioCache(
                                          prefix: 'assets/audio/$voice/');
                                      finishPlayer.play('finish-$voice.mp3');
                                      audioPlayer.clearCache();
                                      isVoice = false;
                                    }
                                    i.value = s + 1;
                                    timeInSec.value = 0;
                                    Navigator.pop(context);
                                  }),
                                  ico: Icon(
                                    Icons.stop_rounded,
                                    size: 30,
                                    color: textColor,
                                  ),
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
                                        resumeFlag.value = !resumeFlag.value;
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
              );
            }
          }),
    );
  }

  Future<bool> createAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          backgroundColor: backgroundColor,
          titlePadding: EdgeInsets.fromLTRB(30, 30, 30, 10),
          actionsPadding: EdgeInsets.only(top: 10, bottom: 15),
          title: Center(
            child: Text(
              'Do you want to end the Workout',
              style: TextStyle(
                color: textColor,
                fontSize: 22,
              ),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'No',
                style: kTextStyle.copyWith(
                  fontSize: 25,
                  color: isDark.value ? Colors.white : Colors.black,
                  fontFamily: 'MontserratBold',
                ),
              ),
            ),
            MaterialButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Yes',
                style: kTextStyle.copyWith(
                  fontSize: 25,
                  color: isDark.value ? Colors.white : Colors.black,
                  fontFamily: 'MontserratBold',
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
