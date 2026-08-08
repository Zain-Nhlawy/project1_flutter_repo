import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

abstract class DeviceInfoDataSource {
  Future<String> getDeviceModel();
}

class DeviceInfoDataSourceImpl implements DeviceInfoDataSource {
  final DeviceInfoPlugin deviceInfoPlugin;

  DeviceInfoDataSourceImpl({DeviceInfoPlugin? deviceInfoPlugin})
      : deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin();

  @override
  Future<String> getDeviceModel() async {
    try {
      if (kIsWeb) {
        final webInfo = await deviceInfoPlugin.webBrowserInfo;
        return webInfo.browserName.name;
      }
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        final model = androidInfo.model;
        if (model.isNotEmpty) {
          return model;
        }
        final manufacturer = androidInfo.manufacturer;
        return '$manufacturer Device';
      }
      if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        return iosInfo.utsname.machine.isNotEmpty
            ? iosInfo.utsname.machine
            : iosInfo.model;
      }
      if (Platform.isMacOS) {
        final macInfo = await deviceInfoPlugin.macOsInfo;
        return macInfo.model;
      }
      if (Platform.isWindows) {
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        return windowsInfo.computerName;
      }
      if (Platform.isLinux) {
        final linuxInfo = await deviceInfoPlugin.linuxInfo;
        return linuxInfo.name;
      }
      return 'Unknown Device';
    } catch (_) {
      return 'Unknown Device';
    }
  }
}
