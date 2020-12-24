import 'dart:math';
import 'dart:ui';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/services/colorEllipse.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class DonatePage extends StatefulWidget {
  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> with TickerProviderStateMixin {
  double screenWidth;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double xCard = 0, yCard = 0, zCard = 0;
  AnimationController xcontroller;
  Animation<double> xanimation;
  double positionOffset = 70;
  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'soham.s.rakhunde.com',
      queryParameters: {'subject': 'Bug_Report'});
  AnimationController ycontroller;
  Animation<double> yanimation;

  // static const String iapId = 'android.test.purchased';
  // List<IAPItem> _items = [];
  // FlutterInappPurchase InappPurchase;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initPlatformState(InappPurchase);
    BackButtonInterceptor.add(myInterceptor);
    xcontroller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    ycontroller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    setState(() {
      xOffset = 250;
      yOffset = 140;
      scaleFactor = 0.7;
      isDrawerOpen = true;
      isDonateOpen = false;
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (isDonateOpen) {
      setState(() {
        xOffset = adjusted(250);
        positionOffset = 70;
        yOffset = adjusted(140);
        scaleFactor = 0.7;
        isDrawerOpen = true;
        isDonateOpen = false;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDonateOpen ? Brightness.dark : Brightness.light,
          systemNavigationBarColor:
              isDonateOpen ? backgroundColor : drawerColor,
          systemNavigationBarIconBrightness:
              isDonateOpen ? Brightness.dark : Brightness.light,
          systemNavigationBarDividerColor:
              isDonateOpen ? backgroundColor : drawerColor,
        ));
      });
      return true;
    } else
      return false;
  }

  double adjusted(double val) => val * screenWidth * perPixel;

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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        onEnd: (() {
          if (isDonateOpen && indexOfMenu.value == 2) {
            print('5animabout');
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
              isDonateOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarColor:
              isDonateOpen ? backgroundColor : drawerColor,
              systemNavigationBarIconBrightness:
              isDonateOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarDividerColor:
              isDonateOpen ? backgroundColor : drawerColor,
            ));
          }
        }),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(isDrawerOpen ? 28 : 0),
        ),
        child: GestureDetector(
          onTap: (() {
            if (!isDonateOpen && indexOfMenu.value == 2) {
              setState(() {
                xOffset = 0;
                positionOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isDonateOpen = true;
              });
            }
          }),
          onHorizontalDragEnd: ((_) {
            if (!isDonateOpen && indexOfMenu.value == 2) {
              setState(() {
                xOffset = 0;
                positionOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isDonateOpen = true;
              });
            }
          }),
          child: AbsorbPointer(
            absorbing: !isDonateOpen,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(isDonateOpen ? 0 : 28),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                    Radius.circular(isDonateOpen ? 0 : 28)),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeInOutBack,
                        left: 10 - positionOffset,
                        bottom: -70 - positionOffset,
                        child: ColoredEllipse(
                            250, [Colors.purpleAccent[200], Colors.purple[700]])
                    ),
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
                            150, [Colors.pinkAccent[100], Colors.pink[800]])
                    ),
                    AnimatedPositioned(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeInOutBack,
                        right: -70 - positionOffset,
                        bottom: screenWidth / 2 - 100 - positionOffset,
                        child: ColoredEllipse(150, [mango[1], mango[0]])
                    ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 70),
                          child: Text(
                            'Support',
                            style: TextStyle(
                              color: Color(0xFF707070),
                              letterSpacing: 2.0,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: AspectRatio(
                            aspectRatio: 3 / 2,
                            child: GestureDetector(
                              onTap: (() =>
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Colors.transparent,
                                    content: Text(
                                      'In-App Purchases are disabled until next update',
                                      style: kTextStyle,
                                    ),
                                  ))),
                              onPanStart: (details) {
                                print('hori start');
                                xcontroller.reset();
                                ycontroller.reset();
                                setState(() {
                                  xCard = 0;
                                  yCard = 0;
                                });
                              },
                              onPanUpdate: (details) {
                                print('hori  ${details.delta}');
                                setState(() {
                                  xCard += details.delta.dx;
                                  xCard %= 360;
                                  yCard += details.delta.dy;
                                  yCard %= 360;
                                });
                              },

                              onPanEnd: (details) {
                                final double xend = 360 - xCard >= 180
                                    ? 0
                                    : 360;
                                xanimation =
                                Tween<double>(begin: xCard, end: xend).animate(
                                    xcontroller)
                                  ..addListener(() {
                                    setState(() {
                                      xCard = xanimation.value;
                                    });
                                  });
                                xcontroller.forward();
                                final double yend = 360 - yCard >= 180
                                    ? 0
                                    : 360;
                                yanimation =
                                Tween<double>(begin: yCard, end: yend).animate(
                                    ycontroller)
                                  ..addListener(() {
                                    setState(() {
                                      yCard = yanimation.value;
                                    });
                                  });
                                ycontroller.forward();
                              },

                              child: Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateX(yCard / 180 * pi)
                                  ..rotateY(-xCard / 180 * pi),
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30)),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 12,
                                      sigmaY: 12,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white.withOpacity(0.4),
                                                Colors.white.withOpacity(0.01),
                                              ]
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                                0.8),)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 6,
                                                  child: Image.asset(
                                                    'assets/logo/cc-visa.png',
                                                    color: textColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: SizedBox(),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    '4856 1289 6547 2323',
                                                    style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      letterSpacing: 1.8,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: SizedBox(),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    'Rakhunde Soham',
                                                    style: TextStyle(
                                                      color: textColor,
                                                      fontFamily: 'Cursive',
                                                      fontSize: 22,
                                                      letterSpacing: 1.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .end,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Image.asset(
                                                    'assets/logo/cc-chip.png',
                                                    color: textColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 8,
                                                  child: SizedBox(),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '07/24',
                                                    style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      letterSpacing: 1.8,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 12,
                              sigmaY: 12,
                            ),
                            child: Container(
                              width: screenWidth - 40,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(0.4),
                                        Colors.white.withOpacity(0.01),
                                      ]
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30)),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.8),)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Contact / Report Bug',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: GestureDetector(
                                            onTap: (() async {
                                              if (await canLaunch(
                                                  _emailLaunchUri.toString())) {
                                                await launch(
                                                    _emailLaunchUri.toString());
                                              } else {
                                                throw 'Could not launch $_emailLaunchUri.toString())';
                                              }
                                            }),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Colors.white.withOpacity(
                                                          0.4),
                                                      Colors.white.withOpacity(
                                                          0.0),
                                                    ]
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25)),
                                              ),
                                              padding: EdgeInsets.all(15),
                                              margin: EdgeInsets.all(5),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.envelope,
                                                  size: 30,
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: GestureDetector(
                                            onTap: (() async {
                                              if (await canLaunch(
                                                  'https://t.me/sohamr1')) {
                                                await launch(
                                                    'https://t.me/sohamr1');
                                              } else {
                                                throw 'Could not launch https://t.me/@sohamr1}';
                                              }
                                            }),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Colors.white.withOpacity(
                                                          0.4),
                                                      Colors.white.withOpacity(
                                                          0.01),
                                                    ]
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25)),
                                              ),
                                              padding: EdgeInsets.all(15),
                                              margin: EdgeInsets.all(5),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons
                                                      .telegramPlane,
                                                  size: 30,
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: GestureDetector(
                                            onTap: (() async {
                                              if (await canLaunch(
                                                  'https://www.instagram.com/soham_rakhunde/')) {
                                                await launch(
                                                    'https://www.instagram.com/soham_rakhunde/');
                                              } else {
                                                throw 'Could not launch https://www.instagram.com/soham_rakhunde/F}';
                                              }
                                            }),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Colors.white.withOpacity(
                                                          0.4),
                                                      Colors.white.withOpacity(
                                                          0.01),
                                                    ]
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25)),
                                              ),
                                              padding: EdgeInsets.all(15),
                                              margin: EdgeInsets.all(5),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.instagram,
                                                  size: 30,
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 12,
                                sigmaY: 12,
                              ),
                              child: GestureDetector(
                                onTap: () =>
                                    Scaffold.of(context).showSnackBar(
                                        SnackBar(duration: Duration(seconds: 1),
                                          backgroundColor: Colors.transparent,
                                          content: Text(
                                            'In-App Purchases are disabled until next update',
                                            style: kTextStyle,
                                          ),
                                        )),
                                child: Container(
                                  height: 70,
                                  width: screenWidth - 40,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withOpacity(0.4),
                                            Colors.white.withOpacity(0.01),
                                          ]
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.8),)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Support',
                                        style: TextStyle(
                                          color: backgroundColor,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(.0, .0),
                                              blurRadius: 3.0,
                                              color: textColor.withOpacity(0.5),
                                            ),
                                          ],
                                          fontSize: 28,
                                        ),
                                      ),
                                      Text(
                                        ' Us',
                                        style: TextStyle(
                                          color: backgroundColor,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(.0, .0),
                                              blurRadius: 3.0,
                                              color: textColor.withOpacity(0.5),
                                            ),
                                          ],
                                          fontSize: 28,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// Future<void> initPlatformState(FlutterInappPurchase InappPurchase) async {
//   // prepare
//   var result = await InappPurchase.initConnection;
//   print('result: $result');
//
//   // If the widget was removed from the tree while the asynchronous platform
//   // message was in flight, we want to discard the reply rather than calling
//   // setState to update our non-existent appearance.
//   if (!mounted) return;
//
//   // refresh items for android
//   String msg = await InappPurchase.consumeAllItems;
//   print('consumeAllItems: $msg');
//   await _getProduct(InappPurchase);
// }
//
// Future<Null> _getProduct(FlutterInappPurchase InappPurchase) async {
//   List<IAPItem> items = await InappPurchase.getProducts([iapId]);
//   for (var item in items) {
//     print('${item.toString()}');
//     this._items.add(item);
//   }
//
//   setState(() {
//     this._items = items;
//   });
// }
//
// Future<Null> _buyProduct(IAPItem item,FlutterInappPurchase InappPurchase) async {
//   try {
//     PurchasedItem purchased = await InappPurchase.requestPurchase(item.productId);
//     print(purchased);
//     String msg = await InappPurchase.consumeAllItems;
//     print('consumeAllItems: $msg');
//   } catch (error) {
//     print('$error');
//   }
// }
//
// List<Widget> _renderButton() {
//   List<Widget> widgets = this._items.map((item) =>
//       Container(
//         height: 250.0,
//         width: double.infinity,
//         child: Card(
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: 28.0),
//               Align(
//                 alignment: Alignment.center,
//                 child: Text('Banana', style: Theme
//                     .of(context)
//                     .textTheme
//                     .display1,),
//               ),
//               SizedBox(height: 24.0),
//               Align(
//                 alignment: Alignment.center,
//                 child: Text('This is a consumable item', style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),),
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: Text('Which you can buy multiple times', style: TextStyle(fontSize: 16.0, color: Colors.grey[700])),
//               ),
//               SizedBox(height: 24.0),
//               SizedBox(
//                 width: 340.0,
//                 height: 50.0,
//                 child: RaisedButton(
//                   color: Colors.blue,
//                   onPressed: () => _renderButton(),
//                   shape: new RoundedRectangleBorder(
//                       borderRadius: new BorderRadius.circular(30.0)),
//                   child: Text('Buy ${item.price} ${item.currency}', style: Theme
//                       .of(context)
//                       .primaryTextTheme
//                       .button,),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//   ).toList();
//   return widgets;
// }

}
