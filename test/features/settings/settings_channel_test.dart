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

  group('SettingsChannel.openWifiSettings', () {
    test('completes without throwing when channel returns null', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        expect(call.method, 'openWifiSettings');
        return null;
      });

      await expectLater(SettingsChannel.openWifiSettings(), completes);
    });

    test('propagates PlatformException with correct code when channel throws',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        throw PlatformException(code: 'UNAVAILABLE');
      });

      await expectLater(
        SettingsChannel.openWifiSettings(),
        throwsA(
          isA<PlatformException>()
              .having((e) => e.code, 'code', 'UNAVAILABLE'),
        ),
      );
    });
  });
}
