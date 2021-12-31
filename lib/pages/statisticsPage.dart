import 'dart:ui';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/services/BarChart.dart';
import 'package:workout_timer/services/DatabaseService.dart';
import 'package:workout_timer/services/timeValueHandler.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  late double screenWidth;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isBackPressed = false;
  double positionOffset = 70;

  int? totalWorkouts, totalDays;
  String? releaseDate;
  Jiffy? releaseJiffy;
  Jiffy? totalHoursJiffy, lastWorkoutJiffy, curWeek, curMonth, curYear;
  List<List>? weekList, monthList, yearList;
  ValueNotifier<bool> refreshBarGraph = ValueNotifier<bool>(true);
  bool shallGetData = true;
  bool isFirstTime = true;
  List<bool> toggleList = List.generate(3, (index) => index == 0);

  Widget toggleButtonsCreator(String str, int i) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          str,
          style: TextStyle(
            color: toggleList[i] ? Colors.amber : textC[1],
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<bool> _getData() async {
    shallGetData = isFirstTime ? true : shallGetData;
    if (shallGetData) {
      shallGetData = false;
      isFirstTime = false;
      SharedPref sp = SharedPref();

      totalWorkouts = await sp.readInt('TotalWorkoutSessions');
      if (totalWorkouts == null) totalWorkouts = 0;

      totalDays = await sp.readInt('TotalDays');
      if (totalDays == null) totalDays = 0;
      releaseDate = await sp.readString('ReleaseDateOfDatabase');
      if (releaseDate != null) releaseJiffy = Jiffy(releaseDate);

      String? totalHours = await sp.readString('TotalWorkoutHours');
      if (totalHours != null) {
        totalHoursJiffy = Jiffy(totalHours);
      } else
        totalHoursJiffy = Jiffy({
          "year": 1,
          "month": 1,
          "day": 1,
          "hour": 0,
          "minute": 0,
          "second": 0,
          "millisecond": 0,
        });
      String? lastWorkoutJiffyString = await sp.readString('LastWorkout');
      if (lastWorkoutJiffyString != null) {
        lastWorkoutJiffy = Jiffy(lastWorkoutJiffyString);
      } else {
        lastWorkoutJiffy = Jiffy();
      }

      curWeek = Jiffy()..startOf(Units.WEEK);
      curMonth = Jiffy()..startOf(Units.MONTH);
      curYear = Jiffy()..startOf(Units.YEAR);

      //db
      weekList =
          await DbHelper.instance.queryWeek(curWeek!.week, curWeek!.year);

      monthList =
          await DbHelper.instance.queryMonth(curMonth!.month, curMonth!.year);

      yearList = await DbHelper.instance.queryYear(curYear!.year);

      refreshBarGraph.value = !refreshBarGraph.value;
    }
    return true;
  }

  void prev() async {
    Jiffy? release;
    if (toggleList[0]) {
      release = releaseJiffy!..startOf(Units.WEEK);
      if (curWeek!.isAfter(release)) {
        curWeek!.subtract(weeks: 1);
        weekList =
            await DbHelper.instance.queryWeek(curWeek!.week, curWeek!.year);
        refreshBarGraph.value = !refreshBarGraph.value;
      }
    } else if (toggleList[1]) {
      release = releaseJiffy!..startOf(Units.MONTH);
      if (curMonth!.isAfter(release)) {
        curMonth!.subtract(months: 1);
        monthList =
            await DbHelper.instance.queryMonth(curMonth!.month, curMonth!.year);
        refreshBarGraph.value = !refreshBarGraph.value;
      }
    } else {
      release = releaseJiffy!..startOf(Units.YEAR);
      if (curYear!.isAfter(release)) {
        curYear!.subtract(years: 1);
        yearList = await DbHelper.instance.queryYear(curYear!.year);
        refreshBarGraph.value = !refreshBarGraph.value;
      }
    }
  }

  void nex() async {
    Jiffy realNow;
    if (toggleList[0]) {
      realNow = Jiffy()..startOf(Units.WEEK);
      if (curWeek!.isBefore(realNow)) {
        curWeek!.add(weeks: 1);
        weekList =
            await DbHelper.instance.queryWeek(curWeek!.week, curWeek!.year);
        refreshBarGraph.value = !refreshBarGraph.value;
      }
    } else if (toggleList[1]) {
      realNow = Jiffy()..startOf(Units.MONTH);
      if (curMonth!.isBefore(realNow)) {
        curMonth!.add(months: 1);
        monthList =
            await DbHelper.instance.queryMonth(curMonth!.month, curMonth!.year);
        refreshBarGraph.value = !refreshBarGraph.value;
      }
    } else {
      realNow = Jiffy()..startOf(Units.YEAR);
      if (curYear!.isBefore(realNow)) {
        curYear!.add(years: 1);
        yearList = await DbHelper.instance.queryYear(curYear!.year);
        refreshBarGraph.value = !refreshBarGraph.value;
      }
    }
  }

  int getDay() {
    Jiffy zeroDate = Jiffy({
      "year": 1,
      "month": 1,
      "day": 1,
      "hour": totalHoursJiffy!.hour,
      "minute": totalHoursJiffy!.minute,
      "second": totalHoursJiffy!.second,
      "millisecond": totalHoursJiffy!.millisecond,
    });
    return totalHoursJiffy!.diff(zeroDate, Units.DAY) as int;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shallGetData = true;
    BackButtonInterceptor.add(myInterceptor);
    setState(() {
      xOffset = 250;
      yOffset = 140;
      isBackPressed = false;
      scaleFactor = 0.7;
      isDrawerOpen = true;
      isStatsOpen = false;
      shallGetData = false;
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (isStatsOpen) {
      setState(() {
        isBackPressed = true;
        xOffset = adjusted(250);
        yOffset = adjusted(140);
        scaleFactor = 0.7;
        positionOffset = 70;
        isDrawerOpen = true;
        isStatsOpen = false;
        shallGetData = false;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isStatsOpen ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: isStatsOpen ? backgroundC[1] : drawerColor,
          systemNavigationBarIconBrightness:
              isStatsOpen ? Brightness.dark : Brightness.light,
          systemNavigationBarDividerColor:
              isStatsOpen ? backgroundC[0] : drawerColor,
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
      builder: (context, dynamic val, child) {
        if (!isStatsOpen && indexOfMenu.value == 1 && !isBackPressed) {
          Future.delayed(Duration(microseconds: 1)).then((value) {
            setState(() {
              xOffset = 0;
              positionOffset = 0;
              yOffset = 0;
              scaleFactor = 1;
              isDrawerOpen = false;
              isStatsOpen = true;
              shallGetData = true;
              openedAfterDbUpdate = true;
            });
          });
        } else if (indexOfMenu.value != 1) isBackPressed = false;
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
          if (isStatsOpen && indexOfMenu.value == 1) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  isStatsOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarColor:
                  isStatsOpen ? backgroundC[0] : drawerColor,
              systemNavigationBarIconBrightness:
                  isStatsOpen ? Brightness.dark : Brightness.light,
              systemNavigationBarDividerColor:
                  isStatsOpen ? backgroundC[0] : drawerColor,
            ));
          }
        }),
        decoration: BoxDecoration(
          color: backgroundC[0],
          borderRadius: BorderRadius.circular(isStatsOpen ? 0 : 28),
        ),
        child: GestureDetector(
          onTap: (() {
            if (!isStatsOpen && indexOfMenu.value == 1) {
              setState(() {
                isBackPressed = false;
                xOffset = 0;
                positionOffset = 0;

                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isStatsOpen = true;
                shallGetData = true;
              });
            }
          }),
          onHorizontalDragEnd: ((_) {
            if (!isStatsOpen && indexOfMenu.value == 1) {
              setState(() {
                isBackPressed = false;
                xOffset = 0;
                positionOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
                isStatsOpen = true;
                shallGetData = true;
              });
            }
          }),
          child: AbsorbPointer(
            absorbing: !isStatsOpen,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(isStatsOpen ? 0 : 28),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 450),
                    child: Container(
                      child: Image.asset(
                        'assets/images/wall4.jfif',
                        fit: BoxFit.fill,
                      ),
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(isStatsOpen ? 0 : 28),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isStatsOpen ? 0 : 28),
                  ),
                  child: FutureBuilder(
                      future: _getData(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.data == null) {
                          return Center(child: Text('Loading'));
                        } else
                          return ListView(
                              physics: BouncingScrollPhysics(),
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 30, 30, 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Statistics',
                                          style: TextStyle(
                                            color: textC[1],
                                            letterSpacing: 2.0,
                                            fontSize: 30,
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
                                            scaleFactor = 0.7;
                                            isDrawerOpen = true;
                                            isStatsOpen = false;
                                            SystemChrome
                                                .setSystemUIOverlayStyle(
                                                    SystemUiOverlayStyle(
                                              statusBarColor:
                                                  Colors.transparent,
                                              statusBarIconBrightness:
                                                  isStatsOpen
                                                      ? Brightness.dark
                                                      : Brightness.light,
                                              systemNavigationBarColor:
                                                  isStatsOpen
                                                      ? backgroundC[0]
                                                      : drawerColor,
                                              systemNavigationBarIconBrightness:
                                                  isStatsOpen
                                                      ? Brightness.dark
                                                      : Brightness.light,
                                              systemNavigationBarDividerColor:
                                                  isStatsOpen
                                                      ? backgroundC[0]
                                                      : drawerColor,
                                            ));
                                          });
                                        }),
                                        iconSize: 35,
                                        icon: Icon(
                                          Icons.menu_rounded,
                                          size: 35,
                                          color: textC[1].withOpacity(0.7),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Container(
                                    width: screenWidth * 0.9,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      color: backgroundC[1].withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Text(
                                                'Last Used',
                                                style: TextStyle(
                                                  color: textC[1],
                                                  letterSpacing: 2.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 15,
                                                sigmaY: 15,
                                              ),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30)),
                                                ),
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            25.0),
                                                    child: Text(
                                                      lastWorkoutJiffy == null
                                                          ? ''
                                                          : '${lastWorkoutJiffy!.date} ${lastWorkoutJiffy!.format('MMMM')} ${lastWorkoutJiffy!.year}',
                                                      style: TextStyle(
                                                        color: textC[1],
                                                        letterSpacing: 2.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (releaseDate != null)
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                    child: Container(
                                      width: screenWidth * 0.9,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: backgroundC[1].withOpacity(0.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 15,
                                            sigmaY: 15,
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: ToggleButtons(
                                                  isSelected: toggleList,
                                                  children: [
                                                    toggleButtonsCreator(
                                                        'Week', 0),
                                                    toggleButtonsCreator(
                                                        'Month', 1),
                                                    toggleButtonsCreator(
                                                        'Year', 2),
                                                  ],
                                                  onPressed: ((index) {
                                                    setState(() {
                                                      toggleList =
                                                          List.generate(
                                                              3,
                                                              (i) =>
                                                                  index == i);
                                                    });
                                                  }),
                                                  borderColor:
                                                      Colors.transparent,
                                                  selectedBorderColor:
                                                      Colors.transparent,
                                                  selectedColor:
                                                      Colors.transparent,
                                                  fillColor: Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (releaseDate != null)
                                  GestureDetector(
                                    onHorizontalDragEnd: (details) {
                                      if (details.primaryVelocity! > 0) {
                                        prev();
                                      } else if (details.primaryVelocity! < 0) {
                                        nex();
                                      }
                                    },
                                    child: ValueListenableBuilder(
                                      valueListenable: refreshBarGraph,
                                      builder: (context, dynamic val, child) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          child: Container(
                                            width: screenWidth * 0.9,
                                            height: 375,
                                            decoration: BoxDecoration(
                                              color: backgroundC[1]
                                                  .withOpacity(0.1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 15,
                                                  sigmaY: 15,
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                  ),
                                                  child: toggleList[0]
                                                      ? BarChartSample1(
                                                          barCount: 7,
                                                          title:
                                                              'Week ${curWeek!.week}',
                                                          subtitle:
                                                              'Total Time ${weekList!.last.first}',
                                                          barList: weekList!
                                                              .sublist(0, 7),
                                                        )
                                                      : toggleList[1]
                                                          ? BarChartSample1(
                                                              barCount: monthList!
                                                                      .length -
                                                                  1,
                                                              title:
                                                                  '${curMonth!.format('MMMM')}',
                                                              subtitle:
                                                                  'Total Time ${monthList!.last.first}',
                                                              barList: monthList!
                                                                  .sublist(
                                                                      0,
                                                                      monthList!
                                                                              .length -
                                                                          1),
                                                            )
                                                          : BarChartSample1(
                                                              barCount: 12,
                                                              title:
                                                                  'Year ${curYear!.year}',
                                                              subtitle:
                                                                  'Total Time ${yearList!.last.first}',
                                                              barList: yearList!
                                                                  .sublist(
                                                                      0, 12),
                                                            ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                if (releaseDate != null)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Container(
                                      width: screenWidth * 0.9,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: backgroundC[1].withOpacity(0.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  'Total\nTime',
                                                  style: TextStyle(
                                                    color: textC[1],
                                                    letterSpacing: 2.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 15,
                                                  sigmaY: 15,
                                                ),
                                                child: Container(
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                  ),
                                                  child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Text(
                                                        '${getDay()} Days\n${totalHoursJiffy!.hour} Hours\n${totalHoursJiffy!.minute} Minute',
                                                        style: TextStyle(
                                                          color: textC[1],
                                                          letterSpacing: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (releaseDate != null)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Container(
                                      width: screenWidth * 0.9,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: backgroundC[1].withOpacity(0.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  'Total\nDays',
                                                  style: TextStyle(
                                                    color: textC[1],
                                                    letterSpacing: 2.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 15,
                                                  sigmaY: 15,
                                                ),
                                                child: Container(
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                  ),
                                                  child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Text(
                                                        '$totalDays Days',
                                                        style: TextStyle(
                                                          color: textC[1],
                                                          letterSpacing: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (releaseDate != null)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Container(
                                      width: screenWidth * 0.9,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: backgroundC[1].withOpacity(0.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  'Total Workouts',
                                                  style: TextStyle(
                                                    color: textC[1],
                                                    letterSpacing: 2.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 15,
                                                  sigmaY: 15,
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                  ),
                                                  child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              30.0),
                                                      child: Text(
                                                        '$totalWorkouts Sessions',
                                                        style: TextStyle(
                                                          color: textC[1],
                                                          letterSpacing: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ]);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
