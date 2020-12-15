import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/services/NeuButton.dart';

import '../constants.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  double screenWidth;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  AnimationController playGradientControl;
  Animation<Color> colAnim1, colAnim2;
  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'soham.rakhunde.com',
      queryParameters: {'subject': 'Bug_Report'});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      xOffset = 250;
      yOffset = 140;
      scaleFactor = 0.7;
      isDrawerOpen = true;
      isAboutOpen = false;
    });
    playGradientControl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
      reverseDuration: Duration(milliseconds: 1500),
    );
    colAnim1 = ColorTween(
      begin: sunset[0],
      end: sunset[1],
    ).animate(playGradientControl);
    colAnim2 = ColorTween(
      begin: mango[0],
      end: mango[1],
    ).animate(playGradientControl);
  }

  double adjusted(double val) => val * screenWidth * perPixel;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    print('In the page');
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        onEnd: (() {
          if (isAboutOpen && indexOfMenu.value == 3) {
            print('5animabout');
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
          child: WillPopScope(
            onWillPop: () async => false,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(isStatsOpen ? 0 : 28),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 13,
                    child: Container(
                      padding: EdgeInsets.only(top: 50, bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 27),
                            child: Text(
                              'About',
                              style: TextStyle(
                                color: Color(0xFF707070),
                                letterSpacing: 2.0,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
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
                                      systemNavigationBarIconBrightness: isAboutOpen
                                          ? Brightness.dark
                                          : Brightness.light,
                                      systemNavigationBarDividerColor: isAboutOpen
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
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(100),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 5),
                    child: Text(
                      'Developed by',
                      style: kTextStyle.copyWith(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      'Soham Rakhunde',
                      style: kTextStyle.copyWith(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 50),
                    child: Text(
                      'Version 1.0',
                      style: kTextStyle.copyWith(),
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
                            MediaQuery
                                .of(context)
                                .size
                                .width / 3 - 40,
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
                            MediaQuery
                                .of(context)
                                .size
                                .width / 3 - 40,
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
                            if (await canLaunch(_emailLaunchUri.toString())) {
                              await launch(_emailLaunchUri.toString());
                            } else {
                              throw 'Could not launch $_emailLaunchUri.toString())';
                            }
                          }),
                          child: Container(
                            width:
                            MediaQuery
                                .of(context)
                                .size
                                .width / 3 - 40,
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
                                FontAwesomeIcons.bug,
                                size: 25,
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
                    child: Container(
                        width:
                        MediaQuery
                            .of(context)
                            .size
                            .width - 40,
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
                        child: GestureDetector(
                          onTap: (() {
                            showLicensePage(
                              context: context,
                              applicationName: 'Workout Timer',
                              applicationVersion: '1.0.0',
                            );
                          }),
                          child: Center(
                            child: Text(
                                'Open Licenses',
                                style: TextStyle(
                                  letterSpacing: 2,
                                  fontFamily: 'MontserratBold',
                                  fontSize: 20,
                                  color: textColor,
                                )
                            ),
                          ),
                        )
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
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
    await Share.share(
        'Workout Timer : https://play.google.com/store/apps/details?id=com.rakhunde.workout_timer',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
