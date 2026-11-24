import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoService {
  // App Info
  static String appName = '';
  static String packageName = '';
  static String appVersion = '';
  static String buildNumber = '';
  static String buildSignature = '';
  static String? installerStore;

  // Device Info
  static String deviceId = '';
  static String deviceModel = '';
  static String deviceBrand = '';
  static String deviceManufacturer = '';
  static String osVersion = '';
  static String platformName = '';
  static int? sdkInt;
  static bool isPhysicalDevice = true;

  // Raw Info Objects
  static PackageInfo? packageInfo;
  static BaseDeviceInfo? rawDeviceInfo;

  static Future<void> init() async {
    try {
      // 1. App Info (PackageInfo)
      packageInfo = await PackageInfo.fromPlatform();
      appName = packageInfo!.appName;
      packageName = packageInfo!.packageName;
      appVersion = packageInfo!.version;
      buildNumber = packageInfo!.buildNumber;
      buildSignature = packageInfo!.buildSignature;
      installerStore = packageInfo!.installerStore;

      // 2. Device Info (DeviceInfoPlugin)
      final deviceInfoPlugin = DeviceInfoPlugin();

      if (kIsWeb) {
        platformName = 'Web';
        final webInfo = await deviceInfoPlugin.webBrowserInfo;
        rawDeviceInfo = webInfo;
        deviceId = webInfo.userAgent ?? 'unknown_web_device';
        deviceModel = webInfo.browserName.name;
        deviceBrand = webInfo.vendor ?? 'Web';
        deviceManufacturer = webInfo.vendor ?? 'Web';
        osVersion = webInfo.platform ?? '';
        isPhysicalDevice = false;
      } else if (Platform.isAndroid) {
        platformName = 'Android';
        final androidInfo = await deviceInfoPlugin.androidInfo;
        rawDeviceInfo = androidInfo;
        deviceId = androidInfo.id;
        deviceModel = androidInfo.model;
        deviceBrand = androidInfo.brand;
        deviceManufacturer = androidInfo.manufacturer;
        osVersion = 'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
        sdkInt = androidInfo.version.sdkInt;
        isPhysicalDevice = androidInfo.isPhysicalDevice;
      } else if (Platform.isIOS) {
        platformName = 'iOS';
        final iosInfo = await deviceInfoPlugin.iosInfo;
        rawDeviceInfo = iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown_ios_device';
        deviceModel = iosInfo.utsname.machine;
        deviceBrand = 'Apple';
        deviceManufacturer = 'Apple';
        osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
        isPhysicalDevice = iosInfo.isPhysicalDevice;
      } else if (Platform.isMacOS) {
        platformName = 'macOS';
        final macInfo = await deviceInfoPlugin.macOsInfo;
        rawDeviceInfo = macInfo;
        deviceId = macInfo.systemGUID ?? 'unknown_mac';
        deviceModel = macInfo.model;
        deviceBrand = 'Apple';
        deviceManufacturer = 'Apple';
        osVersion = macInfo.osRelease;
      } else if (Platform.isWindows) {
        platformName = 'Windows';
        final winInfo = await deviceInfoPlugin.windowsInfo;
        rawDeviceInfo = winInfo;
        deviceId = winInfo.deviceId;
        deviceModel = winInfo.computerName;
        deviceBrand = 'Microsoft';
        deviceManufacturer = 'Microsoft';
        osVersion = winInfo.displayVersion;
      } else if (Platform.isLinux) {
        platformName = 'Linux';
        final linuxInfo = await deviceInfoPlugin.linuxInfo;
        rawDeviceInfo = linuxInfo;
        deviceId = linuxInfo.machineId ?? 'unknown_linux';
        deviceModel = linuxInfo.name;
        deviceBrand = linuxInfo.id;
        deviceManufacturer = linuxInfo.id;
        osVersion = linuxInfo.versionId ?? '';
      }

      debugPrint(
        '[DeviceInfoService] App: $appName v$appVersion ($buildNumber) | Device: $deviceBrand $deviceModel ($platformName $osVersion)',
      );
    } catch (e, stack) {
      debugPrint('[DeviceInfoService] Failed to initialize: $e\n$stack');
    }
  }

  /// App Info map representation
  static Map<String, dynamic> get appInfo => {
        'appName': appName,
        'packageName': packageName,
        'version': appVersion,
        'buildNumber': buildNumber,
        'buildSignature': buildSignature,
        'installerStore': installerStore,
      };

  /// Device Info map representation
  static Map<String, dynamic> get deviceInfo => {
        'deviceId': deviceId,
        'model': deviceModel,
        'brand': deviceBrand,
        'manufacturer': deviceManufacturer,
        'osVersion': osVersion,
        'platform': platformName,
        'sdkInt': sdkInt,
        'isPhysicalDevice': isPhysicalDevice,
      };

  /// Combined summary map
  static Map<String, dynamic> get summary => {
        ...appInfo,
        ...deviceInfo,
      };
}
