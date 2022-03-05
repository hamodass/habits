import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/model/splash_model.dart';

import 'package:habit_tracker_application_main/screens/wrapper/wrapper_screen.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:lottie/lottie.dart';

class SpalshScreenPage extends StatefulWidget {
  SpalshScreenPage({Key? key}) : super(key: key);

  @override
  _SpalshScreenPageState createState() => _SpalshScreenPageState();
}

class _SpalshScreenPageState extends State<SpalshScreenPage> {
  final List<SplashModel> _splashList = [
    SplashModel(
        title: 'Welcome to My Habit Tracker',
        desc: 'My Habit Tracker is your personal assistant to daily self-care',
        image: 'assets/lottie/habit11.json'),
    SplashModel(
        title: 'Form and quit habits',
        desc: 'Track your mood with an intelligent habit tracker',
        image: 'assets/lottie/habit1.json'),
    SplashModel(
        title: 'Reflect on your days',
        desc: 'see what makes you happy or sad',
        image: 'assets/lottie/habit2.json'),
    SplashModel(
      title: 'Check your progress',
      desc:
          'Get an overview of how you are performing to motivate yourself and achieve more',
      image: 'assets/lottie/habit4.json',
    )
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: _splashList.length,
                    itemBuilder: (context, index) {
                      return SplashContent(
                        text: _splashList[index].title!,
                        description: _splashList[index].desc!,
                        image: _splashList[index].image!,
                      );
                    })),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(_splashList.length,
                          (index) => buildDotContainer(index))
                    ],
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  GestureDetector(
                    onTap: () {
                      // saveUserToken();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WrapperScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 10),
                      decoration: BoxDecoration(
                          color: kFullGreenColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  const Spacer()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDotContainer(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 6,
      margin: const EdgeInsets.only(right: 5),
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color:
              currentPage == index ? kFullGreenColor : const Color(0xFFD8D8D8)),
    );
  }
}

class SplashContent extends StatelessWidget {
  final String? text, description, image;
  const SplashContent({this.text, this.description, this.image, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        const Text(
          'Habit Tracker',
          style: TextStyle(
            fontSize: 25,
            color: kFullGreenColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            description!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: kBlack54,
            ),
          ),
        ),
        const Spacer(flex: 2),
        LottieBuilder.asset(
          image!,
          height: 200,
          width: double.infinity,
        ),
      ],
    );
  }
}
