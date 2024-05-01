import 'dart:async';
import 'package:flutter/material.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  //declare timer for splash screen to hold the screen for 2 seconds.
  Timer? _timer;

  //This will create delay for 2 seconds and to to next page
  _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

//on next page route navigates to on boarding page.
  _goNext() {
    Navigator.pushReplacementNamed(context, Routes.onBordingRoute);
  }

//this method is called first time in widget life cycle call backs.
  @override
  void initState() {
    super.initState();

    _startDelay();
  }

//this is called when widget is no longer in use and helps to free memory.
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

//This method helps to build the screen.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage(ImageAssets.splashLogo),
        ),
      ),
    );
  }
}
