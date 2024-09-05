import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize(
    debug: true, // optional: set false to disable printing logs to console
  );
  runApp(
    GetMaterialApp(
      title: "Madhuri - DUK AI Radio",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
