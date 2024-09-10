import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:iic_radio/app/modules/home/controllers/app_loader.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import 'repo.dart';

class HomeController extends GetxController {
  var url =
      'https://audio.jukehost.co.uk/lNUdkiEwxoD2YifsKjuQ8NlWT6UCFVgo'; // Replace with your MP3 URL
  bool isOnline = true;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  ProcessingState processingState = ProcessingState.idle;
  late String cachedFilePath;
  late Timer _timer;
  late Duration _duration;

  @override
  void onInit() {
    super.onInit();
    // downloadAndCacheAudio();
    // checkWorking();
    initAudioPlayer();
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

  Future<void> downloadAndCacheAudio() async {
    try {
      AppLoader.instance.showLoader();
      Directory tempDir = await getTemporaryDirectory();

      // Generate cached file path based on the last part of the URL (the file name)
      String fileNameFromUrl = Uri.parse(url).pathSegments.last;
      cachedFilePath = '${tempDir.path}/$fileNameFromUrl';
      Dio dio = Dio();

      print('Checking if the cached file exists: $cachedFilePath');

      // Check if cached file exists
      File cachedFile = File(cachedFilePath);
      bool shouldDownload = true;

      if (cachedFile.existsSync()) {
        print('Cached file exists: $cachedFilePath');
        // If cached file exists and has the same file name, skip the download
        shouldDownload = false;
        print('Cached file name matches the URL. No need to download.');
      } else {
        print('No matching cached file found.');
      }

      // Download the file if necessary
      if (shouldDownload) {
        print('Downloading new audio file from $url...');
        await dio.download(url, cachedFilePath);
        print('Download complete: $cachedFilePath');
      }

      print('Initializing audio player with the cached file...');
      await initAudioPlayer();
      print('Audio player initialized successfully.');
    } catch (e) {
      print('Error downloading or caching audio: $e');
    }
    AppLoader.instance.dismissDialog();
  }

  Future<void> initAudioPlayer() async {
    try {
      await audioPlayer.setUrl(url);
      print('Audio player initialized');
    } catch (e) {
      print('Error initializing audio player: $e');
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
      processingState = audioPlayer.processingState;
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

    // Calculate the desired playback start time
    DateTime now = DateTime.now();
    DateTime startOfPlayback =
        DateTime(now.year, now.month, now.day);

    // Calculate the elapsed time since the desired start time
    Duration elapsedSinceStart = now.difference(startOfPlayback);

    // Ensure the elapsed time is positive
    // if (elapsedSinceStart.isNegative) {
    //   print(
    //       'The current time is before the start time. Playback will not start.');
    //   isPlaying = false;
    //   update(); // Ensure UI update reflects playback state
    //   return;
    // }

    // Convert elapsed time to audio position (assuming the audio is in seconds)
    int playbackStartPosition = elapsedSinceStart.inSeconds;

    try {
      if (isPlaying) {
        print('Starting playback from $playbackStartPosition seconds...');
        // await audioPlayer.seek(Duration(seconds: playbackStartPosition));
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
