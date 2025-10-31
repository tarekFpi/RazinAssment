import 'dart:async';
import 'package:assignment_asl/core/features/nav/nav_screen.dart';
import 'package:assignment_asl/core/features/utils/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {

    checkStatus();

    super.initState();
  }

  void checkStatus() async {

    Timer(const Duration(seconds: 3), () {

      Get.offAll(() => const NavScreen());
    });

  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor:colorScheme.surfaceVariant,
        body:Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: double.infinity,
                  height:300,
                  child: Lottie.asset("assets/animation/login.json")
              ),
              Text("Assignment ",style: TextStyle(fontSize: 18,color: HexColor('#855EA9'),fontWeight: FontWeight.bold,),
                textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }
}
