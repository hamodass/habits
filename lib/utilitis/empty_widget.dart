import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  final String? url;
  final String? text;
  const EmptyWidget({this.url, this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            url!,
            height: 200,
            width: 200,
          ),
          Text(
            text!,
            style: TextStyle(color: kBlack54, fontSize: 14),
          )
        ],
      ),
    );
  }
}
