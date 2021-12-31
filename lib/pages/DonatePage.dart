import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/providers.dart';
import 'package:workout_timer/services/colorEllipse.dart';

class DonatePage extends StatefulWidget {
  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> with TickerProviderStateMixin {
  static const _productIds = {'80_spoon'};
  late double screenWidth;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isBackPressed = false;
  double xCard = 0, yCard = 0, zCard = 0;
  late AnimationController xcontroller;
  late Animation<double> xanimation;
  double positionOffset = 70;

  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'soham.s.rakhunde.com',
      queryParameters: {'subject': 'Bug_Report'});
  late AnimationController ycontroller;
  late Animation<double> yanimation;

  InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];

  // static const String iapId = '80_spoon';
  // List<IAPItem> _items = [];
  // FlutterInappPurchase InappPurchase;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // InappPurchase = FlutterInappPurchase(InappPurchase);
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    }) as StreamSubscription<List<PurchaseDetails>>;
    initStoreInfo();

    // initPlatformState();
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
      isBackPressed = false;
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

  initStoreInfo() async {
    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_productIds);
    if (productDetailResponse.error == null) {
      setState(() {
        _products = productDetailResponse.productDetails;
      });
    }
  }

  _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // show progress bar or something
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // show error message or failure icon
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          // show success message and deliver the product.
        }
      }
    });
  }

  _buyProduct(int num) {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: _products[0]);
    _connection.buyConsumable(purchaseParam: purchaseParam);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (isDonateOpen) {
      setState(() {
        isBackPressed = true;
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
          systemNavigationBarColor: isDonateOpen ? backgroundC[0] : drawerColor,
          systemNavigationBarIconBrightness:
              isDonateOpen ? Brightness.dark : Brightness.light,
          systemNavigationBarDividerColor:
              isDonateOpen ? backgroundC[0] : drawerColor,
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
    return Consumer(
      builder: (context, ref, child) {
        bool isDark = ref.read(isDarkProvider);
        Color backgroundColor = ref.watch(backgroundProvider);
        Color shadowColor = ref.watch(shadowProvider);
        Color lightShadowColor = ref.watch(lightShadowProvider);
        Color textColor = ref.watch(textProvider);
        return ValueListenableBuilder(
          valueListenable: indexOfMenu,
          builder: (context, dynamic val, child) {
            if (!isDonateOpen && indexOfMenu.value == 2 && !isBackPressed) {
              Future.delayed(Duration(microseconds: 1)).then((value) {
                setState(() {
                  xOffset = 0;
                  yOffset = 0;
                  positionOffset = 0;
                  scaleFactor = 1;
                  isDrawerOpen = false;
                  isDonateOpen = true;
                });
              });
            } else if (indexOfMenu.value != 2) isBackPressed = false;
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
              if (isDonateOpen && indexOfMenu.value == 2) {
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
              color: isDark ? Colors.black : backgroundColor,
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
                    color: isDark ? Colors.black : backgroundColor,
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
                            child: ColoredEllipse(250, [
                              Colors.purpleAccent[200]!,
                              Colors.purple[700]!
                            ])),
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
                            child: ColoredEllipse(150,
                                [Colors.pinkAccent[100]!, Colors.pink[800]!])),
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
                          child:
                              ColoredEllipse(150, [sunset.last, sunset.first]),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Text(
                                      'Support',
                                      style: TextStyle(
                                        color: textColor,
                                        letterSpacing: 2.0,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    color: Colors.transparent,
                                    onPressed: (() {
                                      setState(() {
                                        isBackPressed = true;
                                        xOffset = adjusted(250);
                                        yOffset = adjusted(140);
                                        positionOffset = 70;
                                        scaleFactor = 0.7;
                                        isDrawerOpen = true;
                                        isDonateOpen = false;
                                        SystemChrome.setSystemUIOverlayStyle(
                                            SystemUiOverlayStyle(
                                          statusBarColor: Colors.transparent,
                                          statusBarIconBrightness: isDonateOpen
                                              ? Brightness.dark
                                              : Brightness.light,
                                          systemNavigationBarColor: isDonateOpen
                                              ? backgroundColor
                                              : drawerColor,
                                          systemNavigationBarIconBrightness:
                                              isDonateOpen
                                                  ? Brightness.dark
                                                  : Brightness.light,
                                          systemNavigationBarDividerColor:
                                              isDonateOpen
                                                  ? backgroundColor
                                                  : drawerColor,
                                        ));
                                      });
                                    }),
                                    padding: EdgeInsets.only(right: 30),
                                    iconSize: 40,
                                    icon: Icon(
                                      Icons.menu_rounded,
                                      size: 40,
                                      color: textColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: AspectRatio(
                                aspectRatio: 3 / 2,
                                child: GestureDetector(
                                  onPanStart: (details) {
                                    xcontroller.reset();
                                    ycontroller.reset();
                                    setState(() {
                                      xCard = 0;
                                      yCard = 0;
                                    });
                                  },
                                  onPanUpdate: (details) {
                                    setState(() {
                                      xCard += details.delta.dx;
                                      xCard %= 360;
                                      yCard += details.delta.dy;
                                      yCard %= 360;
                                    });
                                  },
                                  onPanEnd: (details) {
                                    final double xend =
                                        360 - xCard >= 180 ? 0 : 360;
                                    xanimation =
                                        Tween<double>(begin: xCard, end: xend)
                                            .animate(xcontroller)
                                          ..addListener(() {
                                            setState(() {
                                              xCard = xanimation.value;
                                            });
                                          });
                                    xcontroller.forward();
                                    final double yend =
                                        360 - yCard >= 180 ? 0 : 360;
                                    yanimation =
                                        Tween<double>(begin: yCard, end: yend)
                                            .animate(ycontroller)
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
                                    child: FocusedMenuHolder(
                                      menuBoxDecoration: BoxDecoration(
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
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          )),
                                      menuWidth:
                                          MediaQuery.of(context).size.width -
                                              20 * 2,
                                      menuItemExtent: 55,
                                      menuItems: [
                                        FocusedMenuItem(
                                          title: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Buy me some Water',
                                              style: TextStyle(
                                                color: textColor,
                                                fontFamily: 'MontserratBold',
                                              ),
                                            ),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          trailingIcon: Icon(
                                              Icons.local_bar_rounded,
                                              color: textColor),
                                          onPressed: () => null,
                                        ),
                                        FocusedMenuItem(
                                          title: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Buy me a Spoon',
                                              style: TextStyle(
                                                color: textColor,
                                                fontFamily: 'MontserratBold',
                                              ),
                                            ),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          trailingIcon: Icon(
                                              Icons.restaurant_rounded,
                                              color: textColor),
                                          onPressed: () => null,
                                          // await _buyProduct(0),
                                        ),
                                        FocusedMenuItem(
                                          title: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Buy me a Coffee',
                                              style: TextStyle(
                                                color: textColor,
                                                fontFamily: 'MontserratBold',
                                              ),
                                            ),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          trailingIcon: Icon(
                                              Icons.local_cafe_rounded,
                                              color: textColor),
                                          onPressed: () => null,
                                        ),
                                        FocusedMenuItem(
                                          title: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Buy me a Treat',
                                              style: TextStyle(
                                                color: textColor,
                                                fontFamily: 'MontserratBold',
                                              ),
                                            ),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          trailingIcon: Icon(
                                              Icons.fastfood_rounded,
                                              color: textColor),
                                          onPressed: () => null,
                                        ),
                                        FocusedMenuItem(
                                          title: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Gimme all of it',
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontFamily: 'MontserratBold'),
                                            ),
                                          ),
                                          trailingIcon: Icon(
                                              Icons.all_inclusive_rounded,
                                              color: textColor),
                                          backgroundColor: Colors.transparent,
                                          onPressed: () => null,
                                        ),
                                      ],
                                      blurBackgroundColor: backgroundColor,
                                      menuOffset: 20,
                                      openWithTap: true,
                                      onPressed: () {},
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
                                                      Colors.white
                                                          .withOpacity(0.4),
                                                      Colors.white
                                                          .withOpacity(0.01),
                                                    ]),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30)),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                )),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
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
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                            fontFamily:
                                                                'Cursive',
                                                            fontSize: 22,
                                                            letterSpacing: 1.5,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
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
                                                            fontWeight:
                                                                FontWeight.bold,
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
                            ),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
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
                                          ]),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.8),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: GestureDetector(
                                                onTap: (() async {
                                                  if (await canLaunch(
                                                      _emailLaunchUri
                                                          .toString())) {
                                                    await launch(_emailLaunchUri
                                                        .toString());
                                                  } else {
                                                    throw 'Could not launch $_emailLaunchUri.toString())';
                                                  }
                                                }),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          Colors.white
                                                              .withOpacity(0.4),
                                                          Colors.white
                                                              .withOpacity(0.0),
                                                        ]),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                25)),
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
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          Colors.white
                                                              .withOpacity(0.4),
                                                          Colors.white
                                                              .withOpacity(
                                                                  0.01),
                                                        ]),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                25)),
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
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          Colors.white
                                                              .withOpacity(0.4),
                                                          Colors.white
                                                              .withOpacity(
                                                                  0.01),
                                                        ]),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                25)),
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                  margin: EdgeInsets.all(5),
                                                  child: Center(
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .instagram,
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
                              child: FocusedMenuHolder(
                                menuBoxDecoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.4),
                                          Colors.white.withOpacity(0.01),
                                        ]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.8),
                                    )),
                                menuWidth:
                                    MediaQuery.of(context).size.width - 20 * 2,
                                menuItemExtent: 55,
                                menuItems: [
                                  FocusedMenuItem(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Buy me some Water',
                                        style: TextStyle(
                                          color: textColor,
                                          fontFamily: 'MontserratBold',
                                        ),
                                      ),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    trailingIcon: Icon(Icons.local_bar_rounded,
                                        color: textColor),
                                    onPressed: () => null,
                                  ),
                                  FocusedMenuItem(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Buy me a Spoon',
                                        style: TextStyle(
                                          color: textColor,
                                          fontFamily: 'MontserratBold',
                                        ),
                                      ),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    trailingIcon: Icon(Icons.restaurant_rounded,
                                        color: textColor),
                                    onPressed: () => null,
                                  ),
                                  FocusedMenuItem(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Buy me a Coffee',
                                        style: TextStyle(
                                          color: textColor,
                                          fontFamily: 'MontserratBold',
                                        ),
                                      ),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    trailingIcon: Icon(Icons.local_cafe_rounded,
                                        color: textColor),
                                    onPressed: () => null,
                                  ),
                                  FocusedMenuItem(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Buy me a Treat',
                                        style: TextStyle(
                                          color: textColor,
                                          fontFamily: 'MontserratBold',
                                        ),
                                      ),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    trailingIcon: Icon(Icons.fastfood_rounded,
                                        color: textColor),
                                    onPressed: () => null,
                                  ),
                                  FocusedMenuItem(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Gimme all of it',
                                        style: TextStyle(
                                            color: textColor,
                                            fontFamily: 'MontserratBold'),
                                      ),
                                    ),
                                    trailingIcon: Icon(
                                        Icons.all_inclusive_rounded,
                                        color: textColor),
                                    backgroundColor: Colors.transparent,
                                    onPressed: () => null,
                                  ),
                                ],
                                blurBackgroundColor: backgroundColor,
                                menuOffset: 20,
                                openWithTap: true,
                                onPressed: () {},
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 12,
                                      sigmaY: 12,
                                    ),
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
                                              ]),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          )),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Support',
                                            style: TextStyle(
                                              color: textColor,
                                              fontFamily: 'MontserratBold',
                                              fontSize: 28,
                                            ),
                                          ),
                                          Text(
                                            ' Us',
                                            style: TextStyle(
                                              color: textColor,
                                              fontFamily: 'MontserratBold',
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
      },
    );
  }

// Future<void> initPlatformState() async {
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
//   await _getProduct();
// }
//
// Future<Null> _getProduct() async {
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
// Future<Null> _buyProduct(IAPItem item) async {
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
