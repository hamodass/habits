import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: LottieBuilder.asset('assets/lottie/loading.json'),
      ),
    );
  }
}
