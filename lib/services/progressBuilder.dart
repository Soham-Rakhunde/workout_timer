import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../constants.dart';
import '../main.dart';
import 'innerShadow.dart';

class buildStack extends StatefulWidget {
  ValueNotifier<int> i;
  ValueNotifier<double> tickTime ;
  ValueNotifier<int> timeInSec;
  buildStack({this.tickTime,this.i,this.timeInSec});

  @override
  _buildStackState createState() => _buildStackState();
}

class _buildStackState extends State<buildStack> {
  double diameter;
  double pieWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.i.dispose();
    widget.tickTime.dispose();
    widget.timeInSec.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    diameter = 20 * (MediaQuery.of(context).size.height) / 46 - 30;
    pieWidth = MediaQuery.of(context).size.width / 6.67;
    Widget customWidgetReturn(double val) => Text('');
    return ValueListenableBuilder(
        valueListenable: widget.tickTime,
        builder: (context, value, child) {
          return TweenAnimationBuilder(
              tween: Tween<double>(begin: 1, end: 0),
              duration: Duration(seconds: 5),
              builder: (BuildContext context, double value, Widget _) {
                return Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      width: lerpDouble(0, diameter, 1),
                      height: lerpDouble(0, diameter, 1),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(
                          lerpDouble(0, diameter, 0.5),
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
                            lerpDouble(0, diameter, 0.25),
                          ),
                        ),
                        colors: [shadowColor, lightShadowColor],
                        depression: 20 * (1 - value),
                      ),
                    ),
                    widget.tickTime.value <= 0 ? Container() : SleekCircularSlider(
                      innerWidget: (customWidgetReturn),
                      min: 0,
                      max: 25,
                      initialValue: widget.tickTime.value<0 ?
                      0 : (widget.tickTime.value>22 ? 25 : widget.tickTime.value),
                      appearance: CircularSliderAppearance(
                        size: lerpDouble(0, diameter, 0.865),
                              angleRange: 90,
                              startAngle: 0,
                              animationEnabled: false,
                              animDurationMultiplier: 0.1,
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
                    widget.tickTime.value <=25 ? Container() :
                    SleekCircularSlider(
                      innerWidget: (customWidgetReturn),
                      min: 25,
                      max: 50,
                      initialValue: widget.tickTime.value<25 ?
                      25 : (widget.tickTime.value>47 ? 50 : widget.tickTime.value),
                      appearance: CircularSliderAppearance(
                        size: lerpDouble(0, diameter, 0.865),
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
                        animationEnabled: false,
                        animDurationMultiplier: 0.1,
                      ),
                    ),
                    widget.tickTime.value <=50 ? Container() :
                    SleekCircularSlider(
                      innerWidget: (customWidgetReturn),
                      min: 50,
                      max: 75,
                      initialValue: widget.tickTime.value<50 ?
                      50 : (widget.tickTime.value>72 ? 75 : widget.tickTime.value),
                      appearance: CircularSliderAppearance(
                        animationEnabled: false,
                              animDurationMultiplier: 0.1,
                              size: lerpDouble(0, diameter, 0.865),
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
                    widget.tickTime.value <=75 ? Container() :
                    SleekCircularSlider(
                      innerWidget: (customWidgetReturn),
                      min: 75,
                      max: 100,
                      initialValue:widget.tickTime.value<75 ?
                      75 : (widget.tickTime.value>97 ? 100 : widget.tickTime.value),
                      appearance: CircularSliderAppearance(
                        animationEnabled: false,
                              animDurationMultiplier: 0.1,
                              size: lerpDouble(0, diameter, 0.865),
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
                      valueListenable: widget.timeInSec,
                      builder: (context, value, child) {
                        return Text(
                          '${widget.timeInSec.value}',
                          style: kTextStyle.copyWith(
                            color: isDark.value ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
          );
        }
    );
  }
}