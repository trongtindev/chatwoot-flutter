import 'package:device_info_plus/device_info_plus.dart';

import '/imports.dart';

class DeviceService extends GetxService {
  final _logger = Logger();

  late AndroidDeviceInfo _androidDeviceInfo;
  late IosDeviceInfo _iosDeviceInfo;

  String get name {
    if (GetPlatform.isIOS) {
      return _iosDeviceInfo.model;
    } else if (GetPlatform.isAndroid) {
      return _androidDeviceInfo.model;
    }
    throw UnsupportedError(
      'getDeviceName are not supported for this platform.',
    );
  }

  String get platform {
    if (GetPlatform.isIOS) {
      return 'iOS';
    } else if (GetPlatform.isAndroid) {
      return 'Android';
    }
    throw UnsupportedError(
      'getdevicePlatform are not supported for this platform.',
    );
  }

  String get apiLevel {
    if (GetPlatform.isIOS) {
      return _iosDeviceInfo.systemVersion;
    } else if (GetPlatform.isAndroid) {
      return _androidDeviceInfo.version.sdkInt.toString();
    }
    throw UnsupportedError(
      'getDeviceName are not supported for this platform.',
    );
  }

  String get brandName {
    if (GetPlatform.isIOS) {
      return 'Apple';
    } else if (GetPlatform.isAndroid) {
      return _androidDeviceInfo.brand;
    }
    throw UnsupportedError(
      'brandName are not supported for this platform.',
    );
  }

  String get deviceId {
    if (GetPlatform.isIOS) {
      return _iosDeviceInfo.identifierForVendor ?? '';
    } else if (GetPlatform.isAndroid) {
      return _androidDeviceInfo.id;
    }
    throw UnsupportedError(
      'brandName are not supported for this platform.',
    );
  }

  Future<DeviceService> init() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (GetPlatform.isAndroid) {
      _logger.d('androidInfo');
      _androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    } else if (GetPlatform.isIOS) {
      _logger.d('iosInfo');
      _iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    }

    return this;
  }
}
