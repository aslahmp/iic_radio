import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iic_radio/utils/app_colors.dart';
import 'package:iic_radio/utils/app_fonts.dart';
import 'package:lottie/lottie.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 1,
              ),
              nowPlaying(),
              // TextField(
              //   onChanged: (value) {
              //     controller.url = value;
              //     controller.checkWorking();
              //   },
              // ),

              GetBuilder<HomeController>(builder: (controller) {
                return controller.isOnline ? player() : OffLinePlayer();
              }),

              GetBuilder<HomeController>(builder: (controller) {
                var gradient = LinearGradient(
                  colors: [
                    Color(0xffCA005E),
                    Color(0xff7000FF),
                  ],
                );
                return NextShow(gradient: gradient);
              }),

              // Padding(
              //   padding: EdgeInsets.only(left: 10),
              //   child: streamingNext(),
              // ),
              SizedBox(
                height: 1,
              ),
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

class NextShow extends GetView<HomeController> {
  const NextShow({
    super.key,
    required this.gradient,
  });

  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: dec(radius: 20),
      width: double.infinity,
      padding: EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.isOnline ? 'AI RJ SRUTHI' : 'Next Show in',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  )),
              ShaderMask(
                shaderCallback: (bounds) => gradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(
                  controller.isOnline ? 'ON AIR' : controller.formatDuration(),
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontFamily: AppFonts.regular,
                    fontSize: 28,
                  ),
                ),
              ),
            ],
          ),
          Lottie.network(
            'https://lottie.host/7127ec20-de00-4700-95d9-9e9ec52c3442/oybvFbGVa4.json',
            height: 100,
            animate: controller.isOnline,
          )
        ],
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

class OffLinePlayer extends GetView<HomeController> {
  const OffLinePlayer({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      decoration: dec(),
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Lottie.network(
            'https://lottie.host/9ceb047d-6ffc-49ec-9c1c-bd3a4fdc836f/Nh4XmRoIbm.json',
            // height: 360,
            // fit: BoxFit,
          ),
          SizedBox(
            height: 60,
          ),
          Text('Currently Offline',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: AppFonts.bold,
                fontSize: 16,
              )),
          Text('Show Time : Everyday at 8 PM ',
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontFamily: AppFonts.regular,
                fontSize: 13,
              )),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

class player extends GetView<HomeController> {
  const player({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      decoration: dec(),
      height: 360,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              controller.updateStatus();
            },
            child: Lottie.network(
              'https://lottie.host/59ba385f-88c4-4c2a-97aa-19b8e0b6ec03/Fmy5FSMLdI.json',
              animate: controller.isPlaying,
              height: 360,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            // top: 145,
            // left: 145,
            child: IconButton(
              onPressed: () {
                controller.updateStatus();
              },
              // tooltip: 'Control button',
              icon: Icon(
                size: 50,
                controller.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class nowPlaying extends StatelessWidget {
  const nowPlaying({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: dec(),
      padding: EdgeInsets.only(right: 20),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/rj.png',
            height: 90,
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Generating",
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontFamily: AppFonts.regular,
                  fontSize: 16,
                ),
              ),
              Text(
                "Best AI Content",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: AppFonts.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Spacer(),
          SizedBox(
            height: 100,
            width: 50,
            child: Lottie.network(
                'https://lottie.host/98bc09ab-c9c5-47c6-9953-2b39a950467e/UNd7FsVpzn.json'),
          ),
        ],
      ),
    );
  }
}

BoxDecoration dec({double radius = 50}) {
  return BoxDecoration(
    color: Color(0xff191919),
    borderRadius: BorderRadius.circular(radius),
  );
}
