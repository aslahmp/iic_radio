//check for "should be edited for final output"

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:iic_radio/app/modules/home/controllers/app_loader.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'repo.dart';


class HomeController extends GetxController {
final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  String _scheduledTime = '';
  final String _baseUrl = 'http://172.206.71.184';
  late String _scheduledDate; // Update this date as needed
  late Timer _timer;
  bool isOnline = true;
  bool isPlaying = false;
  ProcessingState processingState = ProcessingState.idle;

  @override
  void onInit() {
    super.onInit();
    _fetchAudioUrl();
    _initAudioPlayer(); 

  }

  Future<void> _initAudioPlayer() async {
    // Set up any additional configurations or listeners if needed
    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero; // Update duration
      update(); // Update the UI
    });

    // Listen to the current position to see how much has been played
    _audioPlayer.positionStream.listen((position) {
      // print("Current play position: $position");
      update(); // Update the UI
    });

    // Listen to the buffered position to see how much has been downloaded/buffered
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      print("Buffered position (downloaded): $bufferedPosition");
    });
  }


  Future<void> _fetchAudioUrl() async {
    _scheduledDate = DateTime.now().toString().substring(0, 10);
    print("Scheduled date: $_scheduledDate");
    final String url = '$_baseUrl/stream/?scheduled_date=$_scheduledDate';
    final response = await http.get(Uri.parse(url));

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if the 'audios' list is present and not empty
      if (data['audios'] != null && data['audios'].isNotEmpty) {
        List<dynamic> audios = data['audios'];

        // Sort the audios based on the scheduled time
        audios.sort((a, b) => a['scheduled_time'].compareTo(b['scheduled_time']));
        print("Sorted audios: $audios");

        DateTime now = DateTime.now();
        String? selectedAudioUrl;
        String? selectedScheduledTime;

        for (var audio in audios) {
          DateTime scheduledTime = DateTime.parse('${_scheduledDate}T${audio['scheduled_time']}');
          if (now.isAfter(scheduledTime)) {
            selectedAudioUrl = audio['audio_url'];
            selectedScheduledTime = audio['scheduled_time'];
          } else {
            break;
          }
        }

        if (selectedAudioUrl != null) {
          print("Audio Url: $_baseUrl$selectedAudioUrl");
          _scheduledTime = selectedScheduledTime!;
          // Now play the audio
          await _audioPlayer.setUrl('$_baseUrl$selectedAudioUrl'); // Adjust the URL as needed
          print("Scheduled time: $_scheduledTime");
        } else {
          print("No appropriate audio found for the current time.");
        }
      } else {
        print("No audio data found.");
      }
    } else {
      // Handle the error accordingly
      print("Failed to fetch audio URL: ${response.statusCode}");
    }
  }


  void checkWorking() async {
    print('checking');
    var value = await Repo().isWorking(_baseUrl);
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
    _audioPlayer.playbackEventStream.listen((event) {
      processingState = _audioPlayer.processingState;
      if (_audioPlayer.playing) {
        isPlaying = true;
      } else {
        isPlaying = false;
      }
      update(); // Update UI based on playback state
    });


  }

  void updateStatus() async {
    isPlaying = !isPlaying;

    // Calculate the desired playback start time
    DateTime now = DateTime.now();
    DateTime? scheduledTime;

    try {
      scheduledTime = DateTime.parse('${_scheduledDate}T$_scheduledTime');
    } catch (e) {
      print('Invalid scheduled time format: $e');
      //should be edited for final output
      Get.snackbar(
      'Playback Error',
      'Nothing has been scheduled for today',
      snackPosition: SnackPosition.BOTTOM,
      );
      isPlaying = false;
      update(); // Ensure UI update reflects playback state
      return;
    }

    // Calculate the elapsed time since the scheduled start time
    Duration elapsedSinceScheduled = now.difference(scheduledTime);

    // Ensure the elapsed time is positive
    if (elapsedSinceScheduled.isNegative) {
      print('The current time is before the scheduled time. Playback will not start.');
      Get.snackbar(
        'Playback Error',
        'Try again later',
        snackPosition: SnackPosition.BOTTOM,
      );
      isPlaying = false;
      update(); // Ensure UI update reflects playback state
      return;
    }

    // Convert elapsed time to audio position (assuming the audio is in seconds)
    int playbackStartPosition = elapsedSinceScheduled.inSeconds;

    try {
      if (isPlaying) {
        print('Starting playback from $playbackStartPosition seconds...');

        // Check if the playback start position is within the audio duration
        if (playbackStartPosition < _duration.inSeconds) {
          await _audioPlayer.seek(Duration(seconds: playbackStartPosition));
          await _audioPlayer.play();

          // Ensure UI updates to reflect the animation start
          isPlaying = true;
          update();
        } else {
          print('The seeked position is beyond the audio duration.');

          //should be edited for final output
            Get.snackbar(
            'Playback Error',
            'Try again later',
            snackPosition: SnackPosition.BOTTOM,
            );
          isPlaying = false;
          update(); // Ensure UI update reflects playback state
        }
      } else {
        await _audioPlayer.stop();

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
    _audioPlayer.dispose();
  }
}
