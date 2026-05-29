import 'package:flutter/services.dart';

class SettingsChannel {
  static const MethodChannel _channel = MethodChannel(
    'com.pofka321.flutter_proxy/system_settings',
  );

  static Future<void> openWifiSettings() async {
    try {
      await _channel.invokeMethod<void>('openWifiSettings');
    } on PlatformException {
      rethrow;
    }
  }

  static Future<String?> getWifiSsid() async {
    try {
      return await _channel.invokeMethod<String>('getWifiSsid');
    } on PlatformException {
      rethrow;
    }
  }

  static Future<bool> requestWifiSsidPermissions() async {
    try {
      final granted = await _channel.invokeMethod<bool>(
        'requestWifiSsidPermissions',
      );
      return granted ?? false;
    } on PlatformException {
      rethrow;
    }
  }
}
