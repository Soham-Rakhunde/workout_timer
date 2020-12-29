import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/services/colorEllipse.dart';
import 'package:workout_timer/services/timeValueHandler.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double screenWidth;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  SharedPref savedData = SharedPref();
  ValueNotifier<bool> isVoice = ValueNotifier<bool>(true);
  ValueNotifier<String> selection = ValueNotifier<String>('Voice');
  ValueNotifier<String> Voice = ValueNotifier<String>('');
  AudioCache audioPlayer;
  double positionOffset = 70;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = AudioCache(prefix: 'assets/audio/');
    BackButtonInterceptor.add(myInterceptor);
    setState(() {
      xOffset = 250;
      yOffset = 140;
      scaleFactor = 0.7;
      isDrawerOpen = true;
      isSettingsOpen = false;
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (isSettingsOpen) {
      setState(() {
        xOffset = adjusted(250);
        yOffset = adjusted(140);
        positionOffset = 70;
        scaleFactor = 0.7;
        isDrawerOpen = true;
        isSettingsOpen = false;
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
      });
      return true;
    } else
      return false;
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
      valueListenable: isDark,
      builder: (context, val, child) {
        return child;
      },
      child: ValueListenableBuilder(
        valueListenable: indexOfMenu,
        builder: (context, val, child) {
          return child;
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 450),
          curve: Curves.easeInOutQuart,
          transform: Matrix4.translationValues(xOffset, yOffset, 100)
            ..scale(scaleFactor),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                  positionOffset = 0;
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
                  positionOffset = 0;
                  scaleFactor = 1;
                  isDrawerOpen = false;
                  isSettingsOpen = true;
                });
              }
            }),
            child: AbsorbPointer(
              absorbing: !isSettingsOpen,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isSettingsOpen ? 0 : 28),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(isSettingsOpen ? 0 : 28)),
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.easeInOutBack,
                          left: 10 - positionOffset,
                          bottom: -70 - positionOffset,
                          child: ColoredEllipse(250,
                              [Colors.purpleAccent[200], Colors.purple[700]])),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeInOutBack,
                        right: -150 - positionOffset,
                        bottom: screenWidth / 2 + 100,
                        child: ColoredEllipse(250, [
                          Color.fromRGBO(179, 255, 171, 1),
                          Color.fromRGBO(18, 255, 247, 1)
                        ]),
                      ),
                      AnimatedPositioned(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.easeInOutBack,
                          left: screenWidth / 2 - 90 - positionOffset,
                          bottom: 200 - positionOffset,
                          child: ColoredEllipse(
                              150, [Colors.pinkAccent[100], Colors.pink[800]])),
                      AnimatedPositioned(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.easeInOutBack,
                          right: -70 - positionOffset,
                          bottom: screenWidth / 2 - 100 - positionOffset,
                          child: ColoredEllipse(150, [mango[1], mango[0]])),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeInOutBack,
                        right: -50 - positionOffset,
                        top: 80 - positionOffset,
                        child: ColoredEllipse(200, [sea.last, sea.first]),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeInOutBack,
                        left: screenWidth / 2 - 50 - positionOffset,
                        top: 300 - positionOffset,
                        child: ColoredEllipse(
                            110, [Colors.greenAccent, Colors.teal]),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeInOutBack,
                        left: 40 - positionOffset,
                        top: 70 - positionOffset,
                        child: ColoredEllipse(150, [sunset.last, sunset.first]),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeInOutBack,
                        left: -20 - positionOffset,
                        top: 350,
                        child: ColoredEllipse(
                            140, [Colors.orangeAccent, Colors.deepOrange]),
                      ),
                      Column(
                          // mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Settings',
                                    style: TextStyle(
                                      color: textColor.withAlpha(1000),
                                      letterSpacing: 2.0,
                                      fontFamily: 'MontserratBold',
                                      fontSize: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(flex: 0, child: SizedBox()),
                            Expanded(
                              flex: 8,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 60,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.white.withOpacity(0.4),
                                              Colors.white.withOpacity(0.01),
                                            ]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.8),
                                        )),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30, top: 30),
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
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: ValueListenableBuilder(
                                              valueListenable: selection,
                                              builder: (context, val, _) {
                                                return FutureBuilder(
                                                    future: _getData(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<dynamic>
                                                            snapshot) {
                                                      if (snapshot.data ==
                                                          null) {
                                                        return Center(
                                                            child: Text(
                                                                'Loading'));
                                                      } else {
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: SizedBox(),
                                                            ),
                                                            Expanded(
                                                              flex: 10,
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    (() async {
                                                                  await savedData
                                                                      .saveBool(
                                                                          'isVoice',
                                                                          true);
                                                                  isVoice.value =
                                                                      true;
                                                                  selection
                                                                          .value =
                                                                      'voices';
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(20)),
                                                                        ),
                                                                        backgroundColor:
                                                                            backgroundColor,
                                                                        titlePadding: EdgeInsets.fromLTRB(
                                                                            30,
                                                                            30,
                                                                            30,
                                                                            10),
                                                                        contentPadding: EdgeInsets.fromLTRB(
                                                                            30,
                                                                            10,
                                                                            30,
                                                                            10),
                                                                        actionsPadding: EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            bottom:
                                                                                15,
                                                                            right:
                                                                                MediaQuery.of(context).size.width / 4),
                                                                        title:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Select Voice Model',
                                                                            style:
                                                                                TextStyle(
                                                                              color: textColor,
                                                                              fontSize: 22,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        content:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                double.infinity,
                                                                            child:
                                                                                Column(
                                                                              // mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: voiceModels
                                                                                  .map((e) => RadioListTile(
                                                                                        activeColor: drawerColor,
                                                                                        title: Center(
                                                                                          child: Text(
                                                                                            e,
                                                                                            style: TextStyle(
                                                                                              color: textColor,
                                                                                              fontSize: 19,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        value: e.toLowerCase(),
                                                                                        groupValue: Voice.value,
                                                                                        selected: Voice.value == e.toLowerCase(),
                                                                                        onChanged: (val) async {
                                                                                          await audioPlayer.load('${e.toLowerCase()}/greet-${e.toLowerCase()}.mp3');
                                                                                          Voice.value = e.toLowerCase();
                                                                                          await audioPlayer.play('${e.toLowerCase()}/greet-${e.toLowerCase()}.mp3');
                                                                                          await savedData.saveString('Voice', e.toLowerCase());
                                                                                          audioPlayer.clearCache();
                                                                                          Navigator.of(context).pop();
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
                                                                child:
                                                                    AnimatedContainer(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          200),
                                                                  curve: Curves
                                                                      .easeOutQuint,
                                                                  width: (MediaQuery.of(context).size.width -
                                                                              60) /
                                                                          3 -
                                                                      15,
                                                                  height: 70,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: isVoice.value &&
                                                                            Voice.value !=
                                                                                'beep'
                                                                        ? textColor.withOpacity(
                                                                            0.5)
                                                                        : Colors
                                                                            .transparent,
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.8)),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Voice',
                                                                      style:
                                                                          TextStyle(
                                                                        color: isVoice.value &&
                                                                                Voice.value != 'beep'
                                                                            ? backgroundColor
                                                                            : textColor,
                                                                        letterSpacing:
                                                                            2.0,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    (() async {
                                                                  await audioPlayer
                                                                      .load(
                                                                          'beep/1-beep.mp3');
                                                                  await savedData
                                                                      .saveBool(
                                                                          'isVoice',
                                                                          true);
                                                                  await savedData
                                                                      .saveString(
                                                                          'Voice',
                                                                          'beep');
                                                                  Voice.value =
                                                                      'beep';
                                                                  isVoice.value =
                                                                      true;
                                                                  selection
                                                                          .value =
                                                                      'beeps';
                                                                  await audioPlayer
                                                                      .play(
                                                                          'beep/1-beep.mp3');
                                                                }),
                                                                child:
                                                                    AnimatedContainer(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          200),
                                                                  curve: Curves
                                                                      .easeOutQuint,
                                                                  width: (MediaQuery.of(context).size.width -
                                                                              60) /
                                                                          3 -
                                                                      15,
                                                                  height: 70,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: isVoice.value &&
                                                                            Voice.value ==
                                                                                'beep'
                                                                        ? textColor.withOpacity(
                                                                            0.5)
                                                                        : Colors
                                                                            .transparent,
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.8)),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Beeps',
                                                                      style:
                                                                          TextStyle(
                                                                        color: isVoice.value &&
                                                                                Voice.value == 'beep'
                                                                            ? backgroundColor
                                                                            : textColor,
                                                                        letterSpacing:
                                                                            2.0,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    (() async {
                                                                  await savedData
                                                                      .saveBool(
                                                                          'isVoice',
                                                                          false);
                                                                  isVoice.value =
                                                                      false;
                                                                  selection
                                                                          .value =
                                                                      'off';
                                                                }),
                                                                child:
                                                                    AnimatedContainer(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          200),
                                                                  curve: Curves
                                                                      .easeOutQuint,
                                                                  width: (MediaQuery.of(context).size.width -
                                                                              60) /
                                                                          3 -
                                                                      15,
                                                                  height: 70,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: isVoice.value
                                                                        ? Colors
                                                                            .transparent
                                                                        : textColor
                                                                            .withOpacity(0.5),
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.8)),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Off',
                                                                      style:
                                                                          TextStyle(
                                                                        color: isVoice.value
                                                                            ? textColor
                                                                            : backgroundColor,
                                                                        letterSpacing:
                                                                            2.0,
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                                    });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(flex: 2, child: SizedBox()),
                            Expanded(
                              flex: 8,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 60,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.white.withOpacity(0.4),
                                              Colors.white.withOpacity(0.01),
                                            ]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.8),
                                        )),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30, top: 30),
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
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                        'isDark', false);
                                                    setState(() {
                                                      isDark.value = false;
                                                      backgroundColor =
                                                          backgroundC[
                                                              isDark.value
                                                                  ? 1
                                                                  : 0];
                                                      shadowColor = shadowC[
                                                          isDark.value ? 1 : 0];
                                                      lightShadowColor =
                                                          lightShadowC[
                                                              isDark.value
                                                                  ? 1
                                                                  : 0];
                                                      textColor = textC[
                                                          isDark.value ? 1 : 0];
                                                    });
                                                  }),
                                                  child: AnimatedContainer(
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    curve: Curves.easeOutQuint,
                                                    width:
                                                        (MediaQuery.of(context)
                                                                        .size
                                                                        .width -
                                                                    60) /
                                                                3 -
                                                            15,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                      color: !isDark.value
                                                          ? textColor
                                                              .withOpacity(0.5)
                                                          : Colors.transparent,
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.8)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Light',
                                                        style: TextStyle(
                                                          color: !isDark.value
                                                              ? backgroundColor
                                                              : textColor,
                                                          letterSpacing: 2.0,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                        'isDark', true);
                                                    setState(() {
                                                      isDark.value = true;
                                                      backgroundColor =
                                                          backgroundC[
                                                              isDark.value
                                                                  ? 1
                                                                  : 0];
                                                      shadowColor = shadowC[
                                                          isDark.value ? 1 : 0];
                                                      lightShadowColor =
                                                          lightShadowC[
                                                              isDark.value
                                                                  ? 1
                                                                  : 0];
                                                      textColor = textC[
                                                          isDark.value ? 1 : 0];
                                                    });
                                                  }),
                                                  child: AnimatedContainer(
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    curve: Curves.easeOutQuint,
                                                    width:
                                                        (MediaQuery.of(context)
                                                                        .size
                                                                        .width -
                                                                    60) /
                                                                3 -
                                                            15,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                      color: isDark.value
                                                          ? textColor
                                                              .withOpacity(0.5)
                                                          : Colors.transparent,
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.8)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Dark',
                                                        style: TextStyle(
                                                          color: isDark.value
                                                              ? backgroundColor
                                                              : textColor,
                                                          letterSpacing: 2.0,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(flex: 10, child: SizedBox()),
                          ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}