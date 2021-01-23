import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/services/NeuButton.dart';
import 'package:workout_timer/services/progressBuilder.dart';
import 'package:workout_timer/services/timeValueHandler.dart';

class TimerPage extends StatefulWidget {
  TimerPage({this.args, this.isRest, this.breakTime, this.totalTime});

  List<SetClass> args = [];
  bool isRest;
  TimeClass breakTime;
  int totalTime;

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

  ValueNotifier<int> groupNum = ValueNotifier<int>(1);

  int s, totalTime;

  ValueNotifier<bool> resumeFlag = ValueNotifier<bool>(true);

  String voice;

  bool isVoice;

  SharedPref savedData = SharedPref();

  int flexFactor;

  List<SetClass> setList = [];
  bool isRest;
  TimeClass breakT;

  bool firstInstance = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstInstance = true;
    _getData();
    Wakelock.enable();
  }

  @override
  void dispose() {
    super.dispose();
    tickTime.dispose();
    progress.dispose();
    resumeFlag.dispose();
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
    print('as $time');
    while (timeInSec.value >= 0) {
      print('a');
      while (!resumeFlag.value) {
        print('b');
        await Future.delayed(Duration(milliseconds: 400));
      }
      if (i.value > s) {
        print('broke');
        break;
      }
      print('c');
      tickTime.value = ((time - timeInSec.value) / time) * 100;
      if (timeInSec.value != 0) progress.value += 100 / totalTime;
      if (timeInSec.value <= 5 && timeInSec.value > 0 && isVoice) {
        print('d');
        audioPlayer.play('${timeInSec.value}-$voice.mp3');
      }
      await Future.delayed(Duration(seconds: 1));
      print('e');
      timeInSec.value--;
    }
    print('f');
    tickTime.value = ((time - timeInSec.value) / time) * 100;
    print('ds');
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
    print('1');
    if (timeInSec.value > 0) {
      print('2');
        for (int index = 0; index < setList.length; index++) {
          print('4');
        groupNum.value = index + 1;
        s = setList[index].sets;
        for (i.value = 1; i.value <= setList[index].sets; i.value++) {
          print('5');
          for (int j = 0; j < setList[index].timeList.length; j++) {
            print('6');
            if (isVoice)
              audioPlayer.play(
                  '${setList[index].timeList[j].isWork ? 'start' : 'rest'}-$voice.mp3');
            _titleName.value =
                '${setList[index].grpName}${isRest ? '' : '-'}${setList[index].timeList[j].name}';
            timeInSec.value = setList[index].timeList[j].sec;
            if (timeInSec.value > 0)
              await startTimer(setList[index].timeList[j].sec);
            print(isRest);
            if (i.value != s && isRest) {
              print('7');
              _titleName.value = breakT.name;
              timeInSec.value = breakT.sec;
              if (i.value != s + 1 && isVoice) {
                audioPlayer.play('rest-$voice.mp3');
              }
              if (timeInSec.value > 0) await startTimer(breakT.sec);
            }
          }
        }
        print('8');
      }
      //   i.value++;
      //   print('9');
      // } while (i.value <= s);
      i.value--;
    }
    timeInSec.value = 0;
    if (isVoice) {
      AudioCache finishPlayer = AudioCache(prefix: 'assets/audio/$voice/');
      finishPlayer.play('finish-$voice.mp3');
      audioPlayer.clearCache();
      isVoice = false;
    }
    // i.value = s + 1;
    // timeInSec.value = 0;
    Navigator.pop(context);
  }

  @override
  build(BuildContext context) {
    flexFactor = (MediaQuery.of(context).size.width - 50) ~/ 10;
    if (firstInstance) {
      setList = widget.args;
      s = setList.first.sets;
      isRest = widget.isRest;
      breakT = widget.breakTime;
      totalTime = isRest
          ? (setList.first.timeList.first.sec * s + breakT.sec * (s - 1))
          : widget.totalTime;
    }
    return WillPopScope(
      onWillPop: () async => createAlertDialog(context),
      child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              return Center(child: Text('Loading'));
            } else {
              if (firstInstance) {
                timerFunc();
                firstInstance = false;
              }
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
                        Spacer(
                          flex: 3 * flexFactor,
                        ),
                        Expanded(
                          flex: 3 * flexFactor,
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
                        Spacer(
                          flex: 2 * flexFactor,
                        ),
                        Expanded(
                          flex: 20 * flexFactor,
                          child: Container(
                            // width: MediaQuery.of(context).size.width - 50,
                            height: MediaQuery.of(context).size.width - 50,
                            child: buildStack(
                              tickTime: tickTime,
                              timeInSec: timeInSec,
                              i: i,
                            ),
                          ),
                        ),
                        Spacer(
                          flex: 3 * flexFactor,
                        ),
                        Expanded(
                          flex: 7 * flexFactor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      40,
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
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          'Set',
                                          style: kTextStyle.copyWith(
                                            letterSpacing: 0.5,
                                            color: isDark.value
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: ValueListenableBuilder(
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
                                      ),
                                    ],
                                  )),
                              Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      40,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          'Progress',
                                          style: kTextStyle.copyWith(
                                            letterSpacing: 0.5,
                                            color: isDark.value
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: ValueListenableBuilder(
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
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Spacer(
                          flex: 3 * flexFactor,
                        ),
                        Expanded(
                          flex: 4 * flexFactor,
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
                                    Wakelock.disable();
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
                                flex: isRest ? 4 : 1,
                              ),
                              isRest
                                  ? Spacer(
                                      flex: 2,
                                    )
                                  : Expanded(
                                      flex: 15,
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //       color: shadowColor,
                                          //       offset: Offset(8, 6),
                                          //       blurRadius: 12),
                                          //   BoxShadow(
                                          //       color: lightShadowColor,
                                          //       offset: Offset(-8, -6),
                                          //       blurRadius: 12),
                                          // ],
                                        ),
                                        child: ValueListenableBuilder<int>(
                                            valueListenable: groupNum,
                                            builder:
                                                (context, snapshot, widget) {
                                              return FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  'Group $snapshot of ${setList.length}',
                                                  style: kTextStyle.copyWith(
                                                    letterSpacing: 0.1,
                                                    color: isDark.value
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                              Spacer(
                                flex: isRest ? 4 : 1,
                              ),
                              ValueListenableBuilder(
                                valueListenable: resumeFlag,
                                builder: (context, value, child) {
                                  return Hero(
                                    tag: 'rightButton',
                                    child: Center(
                                      child: NeuButton(
                                        flag: resumeFlag.value,
                                        animated: true,
                                        ico: AnimatedIcons.pause_play,
                                        onPress: (() {
                                          resumeFlag.value = !resumeFlag.value;
                                        }),
                                      ),
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
                        Spacer(
                          flex: 1 * flexFactor,
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
              onPressed: () {
                Wakelock.disable();
                Navigator.pop(context, true);
              },
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
