import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_timer/providers.dart';

class NeuButton extends StatefulWidget {
  final ico;

  AnimatedIcon? animatedIco;
  bool flag = false;
  bool animated = false;
  double length, breadth, radii;
  Function? onPress;

  NeuButton(
      {this.ico,
      this.flag = false,
      this.radii = 32,
      this.onPress,
      this.length = 60,
      this.breadth = 60,
      this.animated = false,
      this.animatedIco});

  @override
  _NeuButtonState createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> with SingleTickerProviderStateMixin {
  late AnimationController playPauseController;
  double offsetFactor = 1;
  late double screenWidth;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      playPauseController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 500),
      );
    }
  }
  @override
  void dispose() {
    super.dispose();
    if(widget.animated)
    {
      playPauseController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width; //390
    widget.length = widget.length == 60 ? screenWidth / 6.5 : widget.length;
    widget.breadth = widget.length;
    return RawMaterialButton(
      onPressed: (() {
        HapticFeedback.lightImpact();
        if (widget.animated) {
          widget.flag
              ? playPauseController.forward()
              : playPauseController.reverse();
        }
        setState(() {
          offsetFactor = 0;
          Timer(Duration(milliseconds: 200), () {
            setState(() {
              offsetFactor = 1;
            });
          });
        });
        widget.onPress!();
      }),
      child: Consumer(builder: (context, ref, child) {
        Color backgroundColor = ref.watch(backgroundProvider);
        Color shadowColor = ref.watch(shadowProvider);
        Color lightShadowColor = ref.watch(lightShadowProvider);
        Color textColor = ref.watch(textProvider);
        return Stack(
          children: <Widget>[
            Container(
              width: widget.breadth,
              height: widget.length,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(widget.radii),
                boxShadow: [
                  BoxShadow(
                      color: shadowColor,
                      offset: Offset((8) * offsetFactor, (6) * offsetFactor),
                      blurRadius: 12),
                  BoxShadow(
                      color: lightShadowColor,
                      offset: Offset((-8) * offsetFactor, (-6) * offsetFactor),
                      blurRadius: 12),
                ],
              ),
            ),
            Positioned.fill(
                child: widget.animated
                    ? Center(
                        child: AnimatedIcon(
                          icon: widget.ico,
                          size: 30,
                          color: textColor,
                          progress: playPauseController,
                        ),
                      )
                    : Center(child: widget.ico)),
          ],
        );
      }),
      padding: EdgeInsets.all(1.0),
      shape: CircleBorder(),
    );
  }
}
