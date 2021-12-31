import 'dart:ui';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/providers.dart';
import 'package:workout_timer/services/NeuButton.dart';

import '../constants.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late double screenWidth;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double logoAnim = 0;
  bool isBackPressed = false;

  // late AudioPlayer player;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    setState(() {
      xOffset = 250;
      yOffset = 140;
      isBackPressed = false;
      scaleFactor = 0.7;
      isDrawerOpen = true;
      isAboutOpen = false;
    });
  }

  @override
  void dispose() {
    // player.dispose();
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (isAboutOpen) {
      setState(() {
        isBackPressed = true;
        xOffset = adjusted(250);
        yOffset = adjusted(140);
        scaleFactor = 0.7;
        isDrawerOpen = true;
        isAboutOpen = false;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isAboutOpen ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: isAboutOpen ? backgroundC[0] : drawerColor,
          systemNavigationBarIconBrightness:
              isAboutOpen ? Brightness.dark : Brightness.light,
          systemNavigationBarDividerColor:
              isAboutOpen ? backgroundC[0] : drawerColor,
        ));
      });
      return true;
    }
    else
      return false;
  }


  double adjusted(double val) => val * screenWidth * perPixel;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Consumer(
      builder: (context, ref, child) {
        Color backgroundColor = ref.watch(backgroundProvider);
        Color shadowColor = ref.watch(shadowProvider);
        Color lightShadowColor = ref.watch(lightShadowProvider);
        Color textColor = ref.watch(textProvider);
        bool isDark = ref.read(isDarkProvider);
        return ValueListenableBuilder(
          valueListenable: indexOfMenu,
          builder: (context, dynamic val, child) {
            if (!isAboutOpen && indexOfMenu.value == 3 && !isBackPressed) {
              Future.delayed(Duration(microseconds: 1)).then((value) {
                setState(() {
                  xOffset = 0;
                  yOffset = 0;
                  scaleFactor = 1;
                  isDrawerOpen = false;
                  isAboutOpen = true;
                });
              });
            } else if (indexOfMenu.value != 3) isBackPressed = false;
            return child!;
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: drawerAnimDur),
            curve: Curves.easeInOutQuart,
            transform: Matrix4.translationValues(xOffset, yOffset, 100)
              ..scale(scaleFactor),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            onEnd: (() {
              if (isAboutOpen && indexOfMenu.value == 3) {
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness:
                      isAboutOpen ? Brightness.dark : Brightness.light,
                  systemNavigationBarColor:
                      isAboutOpen ? backgroundColor : drawerColor,
                  systemNavigationBarIconBrightness:
                      isAboutOpen ? Brightness.dark : Brightness.light,
                  systemNavigationBarDividerColor:
                      isAboutOpen ? backgroundColor : drawerColor,
                ));
              }
            }),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(isDrawerOpen ? 28 : 0),
            ),
            child: GestureDetector(
              onTap: (() {
                if (!isAboutOpen && indexOfMenu.value == 3) {
                  setState(() {
                    xOffset = 0;
                    yOffset = 0;
                    scaleFactor = 1;
                    isDrawerOpen = false;
                    isAboutOpen = true;
                  });
                }
              }),
              onHorizontalDragEnd: ((_) {
                if (!isAboutOpen && indexOfMenu.value == 3) {
                  setState(() {
                    xOffset = 0;
                    yOffset = 0;
                    scaleFactor = 1;
                    isDrawerOpen = false;
                    isAboutOpen = true;
                  });
                }
              }),
              child: AbsorbPointer(
                absorbing: !isAboutOpen,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(isAboutOpen ? 0 : 28),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 13,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 27),
                                child: Text(
                                  'About',
                                  style: TextStyle(
                                    color: textColor,
                                    letterSpacing: 2.0,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              NeuButton(
                                ico: Icon(
                                  Icons.menu_rounded,
                                  size: 30,
                                  color: textColor,
                                ),
                                onPress: (() {
                                  setState(() {
                                    isBackPressed = true;
                                    xOffset = adjusted(250);
                                    yOffset = adjusted(140);
                                    scaleFactor = 0.7;
                                    isDrawerOpen = true;
                                    isAboutOpen = false;
                                    SystemChrome.setSystemUIOverlayStyle(
                                        SystemUiOverlayStyle(
                                      statusBarColor: Colors.transparent,
                                      statusBarIconBrightness: isAboutOpen
                                          ? Brightness.dark
                                          : Brightness.light,
                                      systemNavigationBarColor: isAboutOpen
                                          ? backgroundColor
                                          : drawerColor,
                                      systemNavigationBarIconBrightness:
                                          isAboutOpen
                                              ? Brightness.dark
                                              : Brightness.light,
                                      systemNavigationBarDividerColor:
                                          isAboutOpen
                                              ? backgroundColor
                                              : drawerColor,
                                    ));
                                  });
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            logoAnim = 30;
                          });
                        },
                        child: AnimatedContainer(
                          curve: Curves.elasticIn,
                          onEnd: () {
                            setState(() {
                              logoAnim = 0;
                            });
                          },
                          width: 250 + logoAnim,
                          height: 250 + logoAnim,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius:
                                BorderRadius.circular(150 + logoAnim / 2),
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
                          duration: Duration(milliseconds: 600),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/logoblender.png',
                              color: isDark
                                  ? backgroundC[0].withAlpha(243)
                                  : Colors.transparent,
                              colorBlendMode: BlendMode.difference,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 5),
                        child: Text(
                          'Developed by',
                          style: kTextStyle.copyWith(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          'Soham Rakhunde',
                          style: kTextStyle.copyWith(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 50),
                        child: Text(
                          'Version 3.3.0',
                          style: kTextStyle.copyWith(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _onShare(context),
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width / 3 - 40,
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
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.shareAlt,
                                    size: 25,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (() async {
                                if (await canLaunch(
                                    'https://www.linkedin.com/in/soham-rakhunde/')) {
                                  await launch(
                                      'https://www.linkedin.com/in/soham-rakhunde/');
                                } else {
                                  throw 'Could not launch https://www.linkedin.com/in/soham-rakhunde/}';
                                }
                              }),
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width / 3 - 40,
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
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.linkedinIn,
                                    size: 30,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (() async {
                                if (await canLaunch(
                                    'https://github.com/Soham-Rakhunde/workout_timer')) {
                                  await launch(
                                      'https://github.com/Soham-Rakhunde/workout_timer');
                                } else {
                                  throw 'Could not launch https://github.com/Soham-Rakhunde/workout_timer}';
                                }
                              }),
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width / 3 - 40,
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
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.github,
                                    size: 30,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 6,
                        child: GestureDetector(
                          onTap: (() {
                            showLicensePage(
                              context: context,
                              applicationName: 'Workout Timer',
                              applicationVersion: '3.3.0',
                            );
                          }),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 40,
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
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('Open Licenses',
                                    style: TextStyle(
                                      letterSpacing: 2,
                                      fontFamily: 'MontserratBold',
                                      fontSize: 20,
                                      color: textColor,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share(
        'Hey wanna try out High Intensity Interval Training (HIIT) for the Workout. Checkout Workout Timer : https://play.google.com/store/apps/details?id=com.rakhunde.workout_timer',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
