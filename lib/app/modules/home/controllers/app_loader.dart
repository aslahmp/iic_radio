import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLoader {
  static AppLoader? _instance;

  AppLoader._();

  static AppLoader get instance {
    _instance ??= AppLoader._();

    return _instance!;
  }

  bool get isLoading => _isLoading;
  var _isLoading = false;
  void showLoader() {
    _isLoading = true;

    showDialog(
      context: Get.context!,
      builder: _builder,
      barrierDismissible: false,
    );
  }

  void dismissDialog() {
    if (_isLoading) {
      _isLoading = false;

      Get.back();
    }
  }

  Widget _builder(BuildContext context) {
    return const Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 5,
          color: Colors.white70,
        ),
      ),
    );
  }
}
