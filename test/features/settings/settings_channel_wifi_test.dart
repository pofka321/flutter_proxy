import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_proxy/features/settings/settings_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel =
      MethodChannel('com.pofka321.flutter_proxy/system_settings');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('SettingsChannel.getWifiSsid', () {
    test('returns SSID string when platform returns a value', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        expect(call.method, 'getWifiSsid');
        return 'HomeNetwork';
      });

      final result = await SettingsChannel.getWifiSsid();
      expect(result, 'HomeNetwork');
    });

    test('returns null when platform returns null', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        return null;
      });

      final result = await SettingsChannel.getWifiSsid();
      expect(result, isNull);
    });

    test('propagates PlatformException', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        throw PlatformException(code: 'UNAVAILABLE');
      });

      await expectLater(
        SettingsChannel.getWifiSsid(),
        throwsA(
          isA<PlatformException>()
              .having((e) => e.code, 'code', 'UNAVAILABLE'),
        ),
      );
    });
  });
}
