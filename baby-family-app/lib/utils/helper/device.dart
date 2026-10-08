import 'dart:io';

import 'package:baby_family/data/model/device_info.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import 'local_store_key.dart';

class DeviceFactory {
  factory DeviceFactory() => _singleton ??= DeviceFactory._();

  DeviceFactory._();

  static DeviceFactory? _singleton;

  late DeviceInfo _deviceInfo;

  DeviceInfo get deviceInfo => _deviceInfo;

  Future init() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      _deviceInfo = DeviceInfo(
        deviceType: DeviceType.android,
        deviceId: androidInfo.id,
        osVersion: androidInfo.version.release,
        deviceModel: androidInfo.model,
        manufacturer: androidInfo.manufacturer,
        sdkInt: androidInfo.version.sdkInt,
      );
    }
    if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      const storage = FlutterSecureStorage(
        iOptions: IOSOptions(accessibility: KeychainAccessibility.unlocked),
      );
      var deviceId = await storage.read(key: LocalStoreKey.deviceId);
      if (deviceId?.isEmpty ?? true) {
        deviceId = const Uuid().v4();
        await storage.write(key: LocalStoreKey.deviceId, value: deviceId);
      }
      _deviceInfo = DeviceInfo(
        deviceType: DeviceType.ios,
        deviceId: deviceId,
        deviceModel: iosInfo.utsname.machine,
        osVersion: iosInfo.systemVersion,
        manufacturer: 'Apple',
      );
    }
    final packageInfo = await PackageInfo.fromPlatform();
    _deviceInfo = _deviceInfo.copyWith(
      appVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
    );
  }
}
