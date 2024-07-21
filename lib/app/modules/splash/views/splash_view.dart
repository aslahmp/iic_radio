import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iic_radio/utils/app_colors.dart';
import 'package:iic_radio/utils/app_fonts.dart';

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
            SizedBox(),
            Column(
              children: [
                Image.asset('assets/logo.png'),
                Text(
                  "മാധുരി",
                  style: GoogleFonts.manjari(color: Colors.white, fontSize: 40),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/duk.png',
                    height: 80,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "powered by",
                        style: TextStyle(
                            fontFamily: AppFonts.regular,
                            color: AppColors.secondaryColor,
                            fontSize: 10),
                      ),
                      Text(
                        "IIC Digital University\nKerala",
                        style: TextStyle(
                          fontFamily: AppFonts.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
