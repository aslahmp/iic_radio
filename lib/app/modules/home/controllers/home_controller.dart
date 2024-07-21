import 'package:get/get.dart';
import 'package:radio_player/radio_player.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  RadioPlayer radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;
  @override
  void onInit() {
    super.onInit();
    initRadioPlayer();
  }

  void initRadioPlayer() {
    radioPlayer.setChannel(
      title: 'Radio Player',
      url: 'http://10.10.15.16:8000/stream',
      imagePath: 'assets/cover.jpg',
    );

    radioPlayer.stateStream.listen((value) {
      isPlaying = value;
      update();
    });

    radioPlayer.metadataStream.listen((value) {
      metadata = value;
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
