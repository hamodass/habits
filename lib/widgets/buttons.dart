// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';

class ButtonWidget extends StatelessWidget {
  final Function() onPressed;
  bool? isText = true;
  final String? text;
  final IconData? icon;
  double width = 144.0;
  ButtonWidget(
      {Key? key,
      this.text,
      this.icon,
      this.isText,
      required this.width,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 144,
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isText! ? Text(text!) : Icon(icon),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.all(24),
          side: const BorderSide(color: kFullGreenColor),
        ),
      ),
    );
  }
}
