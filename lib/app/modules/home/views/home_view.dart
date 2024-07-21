import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iic_radio/utils/app_colors.dart';
import 'package:iic_radio/utils/app_fonts.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';

import '../controllers/home_controller.dart';
import 'frp_player.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              nowPlaying(),
              player(),
              FRPlayer(
                flutterRadioPlayer: controller.flutterRadioPlayer,
                frpSource: controller.frpSource,
                useIcyData: true,
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 10),
              //   child: streamingNext(),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // nextStreamingTile(),
              // nextStreamingTile(),
              // nextStreamingTile(),
              // nextStreamingTile(),
            ],
          ),
        ),
      ),
    );
  }
}

class nextStreamingTile extends StatelessWidget {
  const nextStreamingTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
              'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Crunchy punchy",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: AppFonts.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                "Lunch time funny talk",
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontFamily: AppFonts.regular,
                  fontSize: 8,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            "02:49 PM",
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontFamily: AppFonts.regular,
              fontSize: 8,
            ),
          ),
        ],
      ),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[500]!,
            Colors.grey[800]!,
          ],
        ),
      ),
    );
  }
}

class streamingNext extends StatelessWidget {
  const streamingNext({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Streaming",
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontFamily: AppFonts.regular,
            fontSize: 18,
          ),
        ),
        Text(
          "Next",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontFamily: AppFonts.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class player extends StatelessWidget {
  const player({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/Rectangle.png',
          height: 360,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Good afternoon!\nIt's currently 02:49 PM. Welcome to another exciting episode of Techno Tunes on DUK college FM!",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: AppFonts.bold,
                  fontSize: 24,
                ),
              ),
              Image.asset(
                'assets/play.png',
                height: 80,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class nowPlaying extends StatelessWidget {
  const nowPlaying({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "now playing",
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontFamily: AppFonts.regular,
                fontSize: 18,
              ),
            ),
            Text(
              "Techno Tunes",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: AppFonts.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        Image.asset(
          'assets/voice.png',
          height: 80,
        ),
      ],
    );
  }
}
