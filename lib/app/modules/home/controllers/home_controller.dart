import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:iic_radio/app/modules/home/controllers/app_loader.dart';

import 'repo.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var url = 'http://103.156.188.31:8000/stream';
  // var url = 'https://demo.azuracast.com/public/azuratest_radio';
  bool isOnline = true;
  final assetsAudioPlayer = AssetsAudioPlayer();
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
    await assetsAudioPlayer.open(
      Audio.liveStream(url),
    );
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
      await assetsAudioPlayer.play();
      // AppLoader.instance.dismissDialog();
      // assetsAudioPlayer.ignoreIcyMetadata();
    } else {
      assetsAudioPlayer.stop();
    }
    update();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
    assetsAudioPlayer.stop();
  }
}
