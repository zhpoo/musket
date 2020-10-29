import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

mixin BaseConfig {
  static const bool debug = !kReleaseMode;

  static String get platform => Platform.isAndroid ? 'android' : Platform.isIOS ? 'ios' : 'web';

  Future<String> get appVersion async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> get appBundleId async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  Future<String> get osVersion async {
    if (Platform.isAndroid) {
      var deviceInfo = await androidDeviceInfo;
      return deviceInfo?.version?.release;
    } else {
      var deviceInfo = await iosDeviceInfo;
      return deviceInfo?.systemVersion;
    }
  }

  Future<String> get deviceId async {
    if (Platform.isAndroid) {
      var deviceInfo = await androidDeviceInfo;
      return deviceInfo?.androidId;
    } else {
      var deviceInfo = await iosDeviceInfo;
      return deviceInfo?.identifierForVendor;
    }
  }

  Future<String> get deviceModel async {
    if (Platform.isAndroid) {
      var deviceInfo = await androidDeviceInfo;
      return deviceInfo?.model;
    } else {
      var deviceInfo = await iosDeviceInfo;
      return deviceInfo?.model;
    }
  }

  Future<String> get manufacturer async {
    if (Platform.isAndroid) {
      var deviceInfo = await androidDeviceInfo;
      return deviceInfo?.manufacturer;
    } else {
      var deviceInfo = await iosDeviceInfo;
      return deviceInfo?.utsname?.machine;
    }
  }

  Future<String> get brand async {
    if (Platform.isAndroid) {
      var deviceInfo = await androidDeviceInfo;
      return deviceInfo?.brand;
    }
    return '';
  }

  Future<String> get deviceInfo async {
    if (Platform.isIOS) {
      return '$platform|${await manufacturer}|${await deviceModel}|${await osVersion}|${await deviceId}|';
    }
    if (Platform.isAndroid) {
      var android = await androidDeviceInfo;
      if (android == null) {
        return '${DateTime.now().millisecondsSinceEpoch}:unknown device info';
      }
      return '$platform|${android.manufacturer}|${android.board}|${android.device}|${android.hardware}|${android.product}|${android.model}|${android.version?.release}|${android.androidId}';
    }
    return '${Platform.operatingSystem} not support yet.';
  }

  Future<AndroidDeviceInfo> get androidDeviceInfo async {
    if (!Platform.isAndroid) return null;
    try {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      return androidDeviceInfo;
    } catch (PlatformException) {
      return null;
    }
  }

  Future<IosDeviceInfo> get iosDeviceInfo async {
    if (!Platform.isIOS) return null;
    try {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return iosDeviceInfo;
    } catch (PlatformException) {
      return null;
    }
  }
}
