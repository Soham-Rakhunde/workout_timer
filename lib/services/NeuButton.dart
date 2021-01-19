import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workout_timer/constants.dart';

class NeuButton extends StatefulWidget {
  final ico ;
  AnimatedIcon animatedIco;
  bool flag= false;
  bool animated =false;
  double length,breadth, radii;
  Function onPress;
  NeuButton({this.ico,this.flag= false, this.radii=32, this.onPress, this.length=60,  this.breadth =60, this.animated = false,this.animatedIco});

  @override
  _NeuButtonState createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> with SingleTickerProviderStateMixin {
  AnimationController playPauseController;
  double offsetFactor=1;
  double screenWidth;

  @override
  void initState() {
    super.initState();
    if(widget.animated)
    {
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
    if (widget.length == 60) {
      widget.breadth = widget.length;
    }
    return RawMaterialButton(
      onPressed: (() {
        if (widget.animated) {
          widget.flag
              ? playPauseController.forward()
              : playPauseController.reverse();
        }
        setState(() {
          offsetFactor = 0;
          Timer(Duration(milliseconds: 150), () {
            setState(() {
              offsetFactor = 1;
            });

          });

        });
        widget.onPress();
      }),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 1,end: 0),
        duration: Duration( milliseconds: 200),
        builder: (BuildContext context, double value, Widget _) {
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
                        color: shadowColor, offset: Offset((8 - value*8)*offsetFactor, (6 - value*6)*offsetFactor), blurRadius: 12),
                    BoxShadow(
                        color: lightShadowColor,
                        offset: Offset((-8 + value*8)*offsetFactor, (-6 + value*6)*offsetFactor),
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
        },
      ),
      padding: EdgeInsets.all(1.0),
      shape: CircleBorder(),
    );
  }
}
