import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iic_radio/utils/app_colors.dart';
import 'package:iic_radio/utils/app_fonts.dart';
import 'package:lottie/lottie.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(),
            Column(
              children: [
                Lottie.network(
                  'https://lottie.host/9fcd46df-bc79-4596-92ad-bad3d2492273/d4NkS6rACI.json',
                  height: 100,
                ),
                AnimatedTextKit(
                  totalRepeatCount: 10,
                  // isRepeatingAnimation: false,

                  displayFullTextOnTap: true,
                  animatedTexts: [
                    FadeAnimatedText(
                      "മാധുരി",
                      textStyle: GoogleFonts.manjari(
                          color: const Color(0xff7000FF), fontSize: 40),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Generative AI Radio of',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.bold,
                      fontSize: 12,
                    ),
                  ),
                  Image.asset(
                    'assets/duk.png',
                    height: 80,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
