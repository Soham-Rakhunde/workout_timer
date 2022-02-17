import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:workout_timer/providers.dart';

import '../constants.dart';
import 'innerShadow.dart';

class buildStack extends StatefulWidget {
  ValueNotifier<int>? i;
  ValueNotifier<double>? tickTime;

  ValueNotifier<int?>? timeInSec;

  buildStack({this.tickTime, this.i, this.timeInSec});

  @override
  _buildStackState createState() => _buildStackState();
}

class _buildStackState extends State<buildStack> {
  double? diameter;
  double? pieWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.i!.dispose();
    widget.tickTime!.dispose();
    widget.timeInSec!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    diameter = 20 * (MediaQuery.of(context).size.height) / 46 - 30;
    pieWidth = MediaQuery.of(context).size.width / 6.67;
    Widget customWidgetReturn(double val) => Text('');
    return ValueListenableBuilder(
        valueListenable: widget.tickTime!,
        builder: (context, dynamic value, child) {
          return TweenAnimationBuilder(
              tween: Tween<double>(begin: 1, end: 0),
              duration: Duration(seconds: 5),
              builder: (BuildContext context, double value, Widget? _) {
                return Consumer(builder: (context, ref, child) {
                  Color backgroundColor = ref.watch(backgroundProvider);
                  Color shadowColor = ref.watch(shadowProvider);
                  Color lightShadowColor = ref.watch(lightShadowProvider);
                  return Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        width: lerpDouble(0, diameter, 1),
                        height: lerpDouble(0, diameter, 1),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(
                            lerpDouble(0, diameter, 0.5)!,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: shadowColor,
                                offset: Offset(8 - value * 8, 6 - value * 6),
                                blurRadius: 12),
                            BoxShadow(
                                color: lightShadowColor,
                                offset: Offset(-8 + value * 8, -6 + value * 6),
                                blurRadius: 12),
                          ],
                        ),
                      ),
                      Container(
                        width: lerpDouble(0, diameter, 0.4),
                        height: lerpDouble(0, diameter, 0.4),
                        decoration: ConcaveDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              lerpDouble(0, diameter, 0.25)!,
                            ),
                          ),
                          colors: [shadowColor, lightShadowColor],
                          depression: 20 * (1 - value),
                        ),
                      ),
                      widget.tickTime!.value <= 0
                          ? Container()
                          : SleekCircularSlider(
                              innerWidget: (customWidgetReturn),
                              min: 0,
                              max: 25,
                              initialValue: widget.tickTime!.value < 0
                                  ? 0
                                  : (widget.tickTime!.value > 22
                                      ? 25
                                      : widget.tickTime!.value),
                              appearance: CircularSliderAppearance(
                                size: lerpDouble(0, diameter, 0.865)!,
                                angleRange: 90,
                                startAngle: 0,
                                animationEnabled: true,
                                animDurationMultiplier: 0.9,
                                customWidths: CustomSliderWidths(
                                  trackWidth: pieWidth,
                                  progressBarWidth: pieWidth,
                                  shadowWidth: 43,
                                ),
                                customColors: CustomSliderColors(
                                  trackColor: Colors.transparent,
                                  hideShadow: true,
                                  progressBarColors: turqoiseGradient,
                                  dotColor: Colors.transparent,
                                  gradientStartAngle: 0,
                                  gradientEndAngle: 90,
                                ),
                              ),
                            ),
                      widget.tickTime!.value <= 25
                          ? Container()
                          : SleekCircularSlider(
                              innerWidget: (customWidgetReturn),
                              min: 26,
                              max: 50,
                              initialValue: widget.tickTime!.value < 26
                                  ? 26
                                  : (widget.tickTime!.value > 47
                                      ? 50
                                      : widget.tickTime!.value),
                              appearance: CircularSliderAppearance(
                                size: lerpDouble(0, diameter, 0.865)!,
                                angleRange: 90,
                                startAngle: 90,
                                customWidths: CustomSliderWidths(
                                  trackWidth: pieWidth,
                                  progressBarWidth: pieWidth,
                                  shadowWidth: 43,
                                ),
                                customColors: CustomSliderColors(
                                  hideShadow: true,
                                  trackColor: Colors.transparent,
                                  trackGradientStartAngle: 90,
                                  trackGradientEndAngle: 270,
                                  progressBarColors: greenGradient,
                                  dotColor: Colors.transparent,
                                  gradientStartAngle: 90,
                                  gradientEndAngle: 180,
                                ),
                                animationEnabled: true,
                                animDurationMultiplier: 0.9,
                              ),
                            ),
                      widget.tickTime!.value <= 50
                          ? Container()
                          : SleekCircularSlider(
                              innerWidget: (customWidgetReturn),
                              min: 51,
                              max: 75,
                              initialValue: widget.tickTime!.value < 51
                                  ? 51
                                  : (widget.tickTime!.value > 72
                                      ? 75
                                      : widget.tickTime!.value),
                              appearance: CircularSliderAppearance(
                                animationEnabled: true,
                                animDurationMultiplier: 0.9,
                                size: lerpDouble(0, diameter, 0.865)!,
                                angleRange: 90,
                                startAngle: 180,
                                customWidths: CustomSliderWidths(
                                  trackWidth: pieWidth,
                                  progressBarWidth: pieWidth,
                                  shadowWidth: 43,
                                ),
                                customColors: CustomSliderColors(
                                  trackColor: Colors.transparent,
                                  hideShadow: true,
                                  progressBarColors: orangeGradient,
                                  dotColor: Colors.transparent,
                                  gradientStartAngle: 180,
                                  gradientEndAngle: 270,
                                ),
                              ),
                            ),
                      widget.tickTime!.value <= 75
                          ? Container()
                          : SleekCircularSlider(
                              innerWidget: (customWidgetReturn),
                              min: 76,
                              max: 100,
                              initialValue: widget.tickTime!.value < 76
                                  ? 76
                                  : (widget.tickTime!.value > 97
                                      ? 100
                                      : widget.tickTime!.value),
                              appearance: CircularSliderAppearance(
                                animationEnabled: true,
                                animDurationMultiplier: 0.9,
                                size: lerpDouble(0, diameter, 0.865)!,
                                angleRange: 90,
                                startAngle: 270,
                                customWidths: CustomSliderWidths(
                                  trackWidth: pieWidth,
                                  progressBarWidth: pieWidth,
                                  shadowWidth: 43,
                                ),
                                customColors: CustomSliderColors(
                                  trackColor: Colors.transparent,
                                  progressBarColors: redGradient,
                                  hideShadow: true,
                                  dotColor: Colors.transparent,
                                  gradientStartAngle: 270,
                                  gradientEndAngle: 360,
                                ),
                              ),
                            ),
                      ValueListenableBuilder(
                        valueListenable: widget.timeInSec!,
                        builder: (context, dynamic value, child) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 250),
                            reverseDuration: Duration(milliseconds: 0),
                            switchInCurve: Curves.easeOutCirc,
                            switchOutCurve: Curves.easeInBack,
                            transitionBuilder:
                                (Widget child, Animation<double> anim) {
                              final tweenAnim =
                                  Tween<double>(begin: 0.0, end: 1)
                                      .animate(anim);
                              return ScaleTransition(
                                scale: tweenAnim,
                                child: child,
                              );
                            },
                            child: Consumer(builder: (context, ref, child) {
                              bool isDark = ref.read(isDarkProvider);
                              return Text(
                                '${widget.timeInSec!.value}',
                                key: ValueKey<String>(
                                    '${widget.timeInSec!.value}'),
                                style: kTextStyle.copyWith(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  );
                });
              }
          );
        }
    );
  }
}