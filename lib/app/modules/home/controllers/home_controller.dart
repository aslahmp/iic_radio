import 'dart:async';

import 'package:get/get.dart';
import 'package:iic_radio/app/modules/home/controllers/app_loader.dart';

import 'repo.dart';
import 'package:radio_player/radio_player.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var url = 'http://103.156.188.31:8000/stream';
  // var url = 'https://demo.azuracast.com/public/azuratest_radio';
  bool isOnline = true;
  RadioPlayer radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;
  late Timer _timer;
  late Duration _duration;
  @override
  void onInit() {
    super.onInit();
    checkWorking();
    _startCountdown();
  }

  void checkWorking() async {
    print('cheking');
    // AppLoader.instance.showLoader();
    var value = await Repo().isWorking(url);
    // AppLoader.instance.dismissDialog();
    print(value);
    if (value) {
      isOnline = true;
      initRadioPlayer();
    } else {
      isOnline = false;
      _startCountdown();
      update();
    }
    // });
  }

  void initRadioPlayer() async {
    radioPlayer.setChannel(
      title: 'Radio Player',
      url: url,

      // imagePath: 'assets/cover.jpg',
    );
    radioPlayer.stop();

    // await radioPlayer.play();
    radioPlayer.pause();
  }

  void _startCountdown() {
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, 20, 0, 0);

    // If it's already past 9 PM, set the target to 9 PM tomorrow
    if (now.isAfter(target)) {
      target = target.add(Duration(days: 1));
    }

    _duration = target.difference(now);
    var t = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      t++;
      // if (t == 5) {
      //   checkWorking();
      //   t = 0;
      // }
      _duration = _duration - Duration(seconds: 1);
      if (_duration.isNegative) {
        _timer.cancel();
      }
      update();
    });
  }

  String formatDuration() {
    final hours = _duration.inHours.toString().padLeft(2, '0');
    final minutes = (_duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_duration.inSeconds % 60).toString().padLeft(2, '0');
    return '${hours}h ${minutes}m ${seconds}s';
  }

  @override
  void onReady() {
    checkWorking();
    super.onReady();
  }

  void updateStatus() async {
    isPlaying = !isPlaying;
    if (isPlaying) {
      // AppLoader.instance.showLoader();
      await radioPlayer.play();
      // AppLoader.instance.dismissDialog();
      // radioPlayer.ignoreIcyMetadata();
    } else {
      radioPlayer.stop();
    }
    update();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
    radioPlayer.stop();
  }
}
