import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/services/timeValueHandler.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  double screenWidth;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  SharedPref savedData = SharedPref();
  ValueNotifier<bool> isVoice = ValueNotifier<bool>(true);
  ValueNotifier<String> selection = ValueNotifier<String>('Voice');
  ValueNotifier<String> Voice = ValueNotifier<String>('');
  AudioCache audioPlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = AudioCache(prefix: 'assets/audio/');

    setState(() {
      xOffset = 250;
      yOffset = 140;
      scaleFactor = 0.7;
      isDrawerOpen = true;
      isSettingsOpen = false;
    });
  }

  double adjusted(double val) => val * screenWidth * perPixel;

  Future<bool> _getData() async {
    isVoice.value = await savedData.readBool('isVoice');
    Voice.value = await savedData.readString('Voice');
    if (isVoice.value) {
      if (Voice.value == 'beep') {
        selection.value = 'beeps';
      } else {
        selection.value = 'voices';
      }
    } else {
      selection.value = 'off';
    }
    return isVoice.value;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
      valueListenable: indexOfMenu,
      builder: (context, val, child) {
        return child;
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 450),
        curve: Curves.easeInOutQuart,
        transform: Matrix4.translationValues(xOffset, yOffset, 100)
          ..scale(scaleFactor),
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        onEnd: (() {
          if (isSettingsOpen && indexOfMenu.value == 4) {
            print('5animabout');
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  isSettingsOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarColor:
                  isSettingsOpen ? backgroundColor : drawerColor,
              systemNavigationBarIconBrightness:
                  isSettingsOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarDividerColor:
                  isSettingsOpen ? backgroundColor : drawerColor,
            ));
          }
        }),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(isDrawerOpen ? 28 : 0),
        ),
        child: GestureDetector(
          onTap: (() {
            if (!isSettingsOpen && indexOfMenu.value == 4) {
              setState(() {
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isSettingsOpen = true;
              });
            }
          }),
          onHorizontalDragEnd: ((_) {
            if (!isSettingsOpen && indexOfMenu.value == 4) {
              setState(() {
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isSettingsOpen = true;
              });
            }
          }),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isStatsOpen ? 0 : 28),
              ),
              child: Column(
                // mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 27),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                color: textColor,
                                letterSpacing: 2.0,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          RawMaterialButton(
                            padding: EdgeInsets.all(10.0),
                            shape: CircleBorder(),
                            child: Icon(
                              Icons.menu,
                              size: 35,
                              color: textColor,
                            ),
                            onPressed: (() {
                              setState(() {
                                xOffset = adjusted(250);
                                yOffset = adjusted(140);
                                scaleFactor = 0.7;
                                isDrawerOpen = true;
                                isSettingsOpen = false;
                                SystemChrome.setSystemUIOverlayStyle(
                                    SystemUiOverlayStyle(
                                      statusBarColor: Colors.transparent,
                                      statusBarIconBrightness: isSettingsOpen
                                          ? Brightness.dark
                                          : Brightness.light,
                                      systemNavigationBarColor: isSettingsOpen
                                          ? backgroundColor
                                          : drawerColor,
                                      systemNavigationBarIconBrightness:
                                      isSettingsOpen
                                          ? Brightness.dark
                                          : Brightness.light,
                                      systemNavigationBarDividerColor:
                                      isSettingsOpen
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
                        flex: 0,
                        child: SizedBox()
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 60,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(width: 2, color: textColor),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30, top: 30),
                              child: Text(
                                'Audio Alerts',
                                style: TextStyle(
                                  color: textColor,
                                  letterSpacing: 2.0,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ValueListenableBuilder(
                                  valueListenable: selection,
                                  builder: (context, val, _) {
                                    return FutureBuilder(
                                        future: _getData(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          if (snapshot.data == null) {
                                            return Center(
                                                child: Text('Loading'));
                                          }
                                          else {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: SizedBox(),
                                                ),
                                                Expanded(
                                                  flex: 10,
                                                  child: GestureDetector(
                                                    onTap: (() async {
                                                      await savedData.saveBool(
                                                          'isVoice', true);
                                                      isVoice.value = true;
                                                      selection.value =
                                                      'voices';
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                  .circular(
                                                                  20)),
                                                            ),
                                                            backgroundColor: backgroundColor,
                                                            titlePadding: EdgeInsets
                                                                .fromLTRB(
                                                                30, 30, 30, 10),
                                                            contentPadding: EdgeInsets
                                                                .fromLTRB(
                                                                30, 10, 30, 10),
                                                            actionsPadding: EdgeInsets
                                                                .only(top: 10,
                                                                bottom: 15,
                                                                right: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width / 4),
                                                            title: Center(
                                                              child: Text(
                                                                'Select Voice Model',
                                                                style: TextStyle(
                                                                  color: Color(
                                                                      0xFF707070),
                                                                  fontSize: 22,
                                                                ),
                                                              ),
                                                            ),
                                                            content: SingleChildScrollView(
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                child: Column(
                                                                  // mainAxisSize: MainAxisSize.min,
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: voiceModels
                                                                      .map((
                                                                      e) =>
                                                                      RadioListTile(
                                                                        activeColor: drawerColor,
                                                                        title: Center(
                                                                          child: Text(
                                                                            e,
                                                                            style: TextStyle(
                                                                              color: Color(
                                                                                  0xFF707070),
                                                                              fontSize: 19,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        value: e
                                                                            .toLowerCase(),
                                                                        groupValue: Voice
                                                                            .value,
                                                                        selected: Voice
                                                                            .value ==
                                                                            e
                                                                                .toLowerCase(),
                                                                        onChanged: (
                                                                            val) async {
                                                                          await audioPlayer
                                                                              .load(
                                                                              '${e
                                                                                  .toLowerCase()}/greet-${e
                                                                                  .toLowerCase()}.mp3');
                                                                          Voice
                                                                              .value =
                                                                              e
                                                                                  .toLowerCase();
                                                                          await audioPlayer
                                                                              .play(
                                                                              '${e
                                                                                  .toLowerCase()}/greet-${e
                                                                                  .toLowerCase()}.mp3');
                                                                          await savedData
                                                                              .saveString(
                                                                              'Voice',
                                                                              e
                                                                                  .toLowerCase());
                                                                          audioPlayer
                                                                              .clearCache();
                                                                          Navigator
                                                                              .of(
                                                                              context)
                                                                              .pop();
                                                                        },
                                                                      ))
                                                                      .toList(),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }),
                                                    child: Container(
                                                      width: (MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width - 60) / 3 - 15,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        color: isVoice.value &&
                                                            Voice.value !=
                                                                'beep'
                                                            ? textColor
                                                            : Colors
                                                            .transparent,
                                                        border: Border.all(
                                                            width: 1,
                                                            color: textColor),
                                                        borderRadius: BorderRadius
                                                            .circular(20),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Voice',
                                                          style: TextStyle(
                                                            color: isVoice
                                                                .value &&
                                                                Voice.value !=
                                                                    'beep'
                                                                ? backgroundColor
                                                                : textColor,
                                                            letterSpacing: 2.0,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: SizedBox(),
                                                ),
                                                Expanded(
                                                  flex: 10,
                                                  child: GestureDetector(
                                                    onTap: (() async {
                                                      await audioPlayer.load(
                                                          'beep/1-beep.mp3');
                                                      await savedData.saveBool(
                                                          'isVoice', true);
                                                      await savedData
                                                          .saveString(
                                                          'Voice', 'beep');
                                                      Voice.value = 'beep';
                                                      isVoice.value = true;
                                                      selection.value = 'beeps';
                                                      await audioPlayer.play(
                                                          'beep/1-beep.mp3');
                                                    }),
                                                    child: Container(
                                                      width: (MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width - 60) / 3 - 15,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        color: isVoice.value &&
                                                            Voice.value ==
                                                                'beep'
                                                            ? textColor
                                                            : Colors
                                                            .transparent,
                                                        border: Border.all(
                                                            width: 1,
                                                            color: textColor),
                                                        borderRadius: BorderRadius
                                                            .circular(20),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Beeps',
                                                          style: TextStyle(
                                                            color: isVoice
                                                                .value &&
                                                                Voice.value ==
                                                                    'beep'
                                                                ? backgroundColor
                                                                : textColor,
                                                            letterSpacing: 2.0,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: SizedBox(),
                                                ),
                                                Expanded(
                                                  flex: 10,
                                                  child: GestureDetector(
                                                    onTap: (() async {
                                                      await savedData.saveBool(
                                                          'isVoice', false);
                                                      isVoice.value = false;
                                                      selection.value = 'off';
                                                    }),
                                                    child: Container(
                                                      width: (MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width - 60) / 3 - 15,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        color: isVoice.value
                                                            ? Colors.transparent
                                                            : textColor,
                                                        border: Border.all(
                                                            width: 1,
                                                            color: textColor),
                                                        borderRadius: BorderRadius
                                                            .circular(20),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Off',
                                                          style: TextStyle(
                                                            color: isVoice.value
                                                                ? textColor
                                                                : backgroundColor,
                                                            letterSpacing: 2.0,
                                                            fontSize: 17,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: SizedBox(),
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                    );
                                  }
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: SizedBox()
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 60,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(width: 2, color: textColor),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30, top: 30),
                              child: Text(
                                'Dark Mode',
                                style: TextStyle(
                                  color: textColor,
                                  letterSpacing: 2.0,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Text(
                                  'Coming Soon!',
                                  style: TextStyle(
                                    color: textColor,
                                    letterSpacing: 2.0,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 10,
                        child: SizedBox()
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
