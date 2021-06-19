import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class BarChartSample1 extends StatefulWidget {
  BarChartSample1({this.barCount, this.barList, this.title, this.subtitle});

  int? barCount;
  List<List>? barList = [];
  String? title;
  String? subtitle;
  final List<Color> availableColors = sunset +
      sea +
      mango +
      sky +
      fire +
      turqoiseGradient +
      greenGradient +
      orangeGradient +
      redGradient +
      [
        Colors.purpleAccent,
        Colors.yellow,
        Colors.lightBlue,
      ];

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color? barBackgroundColor = textC[1].withOpacity(0.3);

  // const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int? touchedIndex;
  double? maxVal;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    maxVal = 0.0;
    for (List i in widget.barList!) {
      maxVal = maxVal! > i[1] ? maxVal : i[1];
    }

    return AspectRatio(
      aspectRatio: 0.85,
      child: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                      child: Text(
                        widget.title!,
                        style: TextStyle(
                          color: textC[1],
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 60),
                      child: Text(
                        widget.subtitle!,
                        style: TextStyle(
                          color: textC[1].withOpacity(0.6),
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: BarChart(
                        isPlaying ? randomData() : mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(27.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 35,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                      if (isPlaying) {
                        refreshState();
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double? y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    width = MediaQuery.of(context).size.width / (widget.barCount! * 2);
    // barColor = redGradient[1];
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y! + 1 : y!,
          colors: isTouched ? [Colors.amber] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: maxVal,
            colors: [barBackgroundColor!],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate(widget.barCount!, (i) {
        return makeGroupData(i, widget.barList![i][1],
            isTouched: i == touchedIndex);
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.white.withOpacity(0.8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                  widget.barList![group.x.toInt()][0] +
                      '\n' +
                      widget.barList![group.x.toInt()][2],
                  // (rod.y - 1).toString()
                  TextStyle(color: redGradient[1]));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerDownEvent) {
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            margin: 16,
            getTitles: (double value) => widget.barCount! >= 7
                ? widget.barList![value.toInt()][0][0]
                : widget.barList![value.toInt()][0]
                    .substring(widget.barList![value.toInt()][0].length - 2)),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            margin: 16,
            getTitles: (double value) => widget.barList![value.toInt()][0][0]),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(widget.barCount!, (i) {
        return makeGroupData(i, Random().nextInt(15).toDouble() + 6,
            barColor: widget.availableColors[
                Random().nextInt(widget.availableColors.length)]);
      }),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}
