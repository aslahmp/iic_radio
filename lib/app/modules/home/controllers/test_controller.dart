import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  String _scheduledTime = '';
  final String _baseUrl = 'http://172.206.71.184';
  final String _scheduledDate = '2024-10-06'; // Update this date as needed

  @override
  void initState() {
    super.initState();
    _fetchAudioUrl();
    _initAudioPlayer(); // Initialize the audio player here
  }

  Future<void> _initAudioPlayer() async {
    // Set up any additional configurations or listeners if needed
    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero; // Update duration
      });
    });

    // Listen to the current position to see how much has been played
    _audioPlayer.positionStream.listen((position) {
      print("Current play position: $position");
      setState(() {}); // Update the UI
    });

    // Listen to the buffered position to see how much has been downloaded/buffered
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      print("Buffered position (downloaded): $bufferedPosition");
    });
  }

  Future<void> _fetchAudioUrl() async {
    final String url = '$_baseUrl/stream/?scheduled_date=$_scheduledDate';
    final response = await http.get(Uri.parse(url));

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if the 'audios' list is present and not empty
      if (data['audios'] != null && data['audios'].isNotEmpty) {
        final audioUrl =
            data['audios'][0]['audio_url']; // Accessing the first audio URL
        print("Audio Url: $_baseUrl$audioUrl");

        _scheduledTime =
            data['audios'][0]['scheduled_time']; // Accessing the scheduled time
        // Now play the audio
        await _audioPlayer
            .setUrl('$_baseUrl$audioUrl'); // Adjust the URL as needed
        print("Scheduled time: $_scheduledTime");
      } else {
        print("No audio data found.");
      }
    } else {
      // Handle the error accordingly
      print("Failed to fetch audio URL: ${response.statusCode}");
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _seekTo(Duration newPosition) {
    _audioPlayer.seek(newPosition);
    print("Seeking to: $newPosition");
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Seek Slider
            Slider(
              min: 0.0,
              max: _duration.inSeconds.toDouble(),
              value: _audioPlayer.position.inSeconds.toDouble(),
              onChanged: (value) {
                final newPosition = Duration(seconds: value.toInt());
                _seekTo(newPosition);
              },
            ),
            // Play/Pause Button
            ElevatedButton(
              onPressed: _togglePlayPause,
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 48,
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
