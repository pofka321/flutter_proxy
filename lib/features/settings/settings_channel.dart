import 'package:flutter/services.dart';

class SettingsChannel {
  static const MethodChannel _channel =
      MethodChannel('com.pofka321.flutter_proxy/system_settings');

  static Future<void> openWifiSettings() async {
    try {
      await _channel.invokeMethod<void>('openWifiSettings');
    } on PlatformException {
      rethrow;
    }
  }
}
