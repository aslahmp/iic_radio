import 'package:get/get.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final count = 0.obs;
  @override
  void onInit() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offNamed('/home');
    super.onInit();
  }



  void increment() => count.value++;
}
