import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class myTextField extends StatelessWidget {
  int temp;
  String controllerName;
  Function func;
  myTextField({this.controllerName, this.func});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller[controllerName],
      style: kTextStyle.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: textColor,
        decorationColor: textColor,
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      textAlign: TextAlign.center,
      cursorColor: Colors.grey,
      onChanged: ((val) {
        print('$val i s val');
        temp = int.parse(val);//check value bounds
        if(controllerName != 'sets' && (temp<0 || temp>60)){
          val = retain[controllerName];
        }
        func(val);
      }),
      keyboardType: TextInputType.number,
      decoration: kInputDecor,
    );
  }
}
