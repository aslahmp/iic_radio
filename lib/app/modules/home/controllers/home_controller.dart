import 'dart:async';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'repo.dart';

class HomeController extends GetxController {
  var url =
      'https://5423-14-139-189-168.ngrok-free.app/stream/'; // Replace with your MP3 URL
  bool isOnline = true;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  late Timer _timer;
  late Duration _duration;

  @override
  void onInit() {
    super.onInit();
    initAudioPlayer();
    // checkWorking();
  }

  Future<void> initAudioPlayer() async {
    try {
      print('Initializing audio player with the streaming URL...');
      await audioPlayer.setUrl(url); // Stream directly from the URL
      print('Audio player initialized for streaming');
    } catch (e) {
      print('Error initializing audio player for streaming: $e');
    }
  }

  void checkWorking() async {
    print('checking');
    var value = await Repo().isWorking(url);
    print(value);
    if (value) {
      isOnline = true;
    } else {
      isOnline = false;
      _startCountdown();
      update();
    }
  }

  void _startCountdown() {
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, 20, 0, 0);

    if (now.isAfter(target)) {
      target = target.add(const Duration(days: 1));
    }

    _duration = target.difference(now);
    var t = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      t++;
      _duration = _duration - const Duration(seconds: 1);
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
    super.onReady();

    // Set up listeners for playback events
    audioPlayer.playbackEventStream.listen((event) {
      if (audioPlayer.playing) {
        isPlaying = true;
      } else {
        isPlaying = false;
      }
      update(); // Update UI based on playback state
    });

    // checkWorking();
  }

  void updateStatus() async {
    isPlaying = !isPlaying;

    try {
      if (isPlaying) {
        print('Starting playback...');
        await audioPlayer.play();

        // Ensure UI updates to reflect the animation start
        isPlaying = true;
        update();
      } else {
        await audioPlayer.stop();

        // Ensure UI updates to reflect the animation stop
        isPlaying = false;
        update();
      }
    } catch (e) {
      print('Error updating playback status: $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
    audioPlayer.dispose();
  }
}
