import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_timer/providers.dart';

import '../constants.dart';

class myTextField extends ConsumerWidget {
  late int temp;
  String? controllerName = ' ';
  TextEditingController? control;
  Function? func;
  bool? isStringName = true;
  TextInputType keyboardType;

  myTextField(
      {this.controllerName,
      this.func,
      this.isStringName,
      this.control,
      required this.keyboardType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: isStringName! ? controller[controllerName] : control,
      style: kTextStyle.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: ref.read(textProvider),
        decorationColor: ref.read(textProvider),
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      textAlign: TextAlign.center,
      cursorColor: Colors.grey,
      onChanged: ((val) {
        temp = int.parse(val); //check value bounds
        if (controllerName != 'sets' && (temp < 0 || temp > 60)) {
          val = retain[controllerName];
        }
        func!(val);
      }),
      keyboardType: keyboardType,
      decoration: kInputDecor,
    );
  }
}
