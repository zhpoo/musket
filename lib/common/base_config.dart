import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

mixin BaseConfig {
  static const bool debug = !bool.fromEnvironment('dart.vm.product');

  /// 网络连接超时时间
  static int get httpConnectTimeout => 15 * 1000;

  static String get platform => Platform.isAndroid ? 'android' : 'ios';

  static Future<String> get appVersion async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> get appBundleId async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  static Future<String> get osVersion async {
    if (Platform.isAndroid) {
      var deviceInfo = await androidDeviceInfo;
      return deviceInfo?.version?.release;
    } else {
      var deviceInfo = await iosDeviceInfo;
      return deviceInfo?.systemVersion;
    }
  }

  static Future<String> get deviceId async {
    if (Platform.isAndroid) {
      var deviceInfo = await androidDeviceInfo;
      return deviceInfo?.androidId;
    } else {
      var deviceInfo = await iosDeviceInfo;
      return deviceInfo?.identifierForVendor;
    }
  }

  static Future<String> get deviceModel async {
    if (Platform.isAndroid) {
      var deviceInfo = await androidDeviceInfo;
      return deviceInfo?.model;
    } else {
      var deviceInfo = await iosDeviceInfo;
      return deviceInfo?.model;
    }
  }

  static Future<String> get manufacturer async {
    if (Platform.isAndroid) {
      var deviceInfo = await androidDeviceInfo;
      return deviceInfo?.manufacturer;
    } else {
      var deviceInfo = await iosDeviceInfo;
      return deviceInfo?.utsname?.machine;
    }
  }

  static Future<String> get deviceInfo async {
    return '${await manufacturer} ${await deviceModel} $platform ${await osVersion}\n'
        'appVersion: ${await appVersion}\n'
        'deviceId: ${await deviceId}\n';
  }

  static Future<AndroidDeviceInfo> get androidDeviceInfo async {
    if (!Platform.isAndroid) return null;
    try {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      return androidDeviceInfo;
    } catch (PlatformException) {
      return null;
    }
  }

  static Future<IosDeviceInfo> get iosDeviceInfo async {
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
