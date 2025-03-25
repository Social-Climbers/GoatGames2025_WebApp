import 'dart:io';
import 'package:goatgames25webapp/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> printAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version; // e.g. "1.0.0"
  String buildNumber = packageInfo.buildNumber; // e.g. "1"
  appVersion = version;
  print('App Name: $appName');
  print('Package Name: $packageName');
  print('Version: $version');
  print('Build Number: $buildNumber');
}
