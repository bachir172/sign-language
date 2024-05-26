import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:translateappp/choose_screen.dart';
import 'camera_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 300,
      backgroundColor: Colors.black,
      splashTransition: SplashTransition.slideTransition,
      splash: Image.asset('assets/images/logo3.png', height: 100),
      nextScreen: ChooseScreen(),
      duration: 3000,
      pageTransitionType: PageTransitionType.topToBottom,
    );
  }
}
