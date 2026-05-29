import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_proxy/features/proxy_profiles/domain/proxy_profile.dart';
import 'package:flutter_proxy/features/proxy_profiles/domain/proxy_type.dart';
import 'package:flutter_proxy/features/proxy_profiles/ui/proxy_profile_form.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.pofka321.flutter_proxy/system_settings');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  String _nameFieldValue(WidgetTester tester) {
    return tester
        .widget<EditableText>(
          find
              .descendant(
                of: find.byType(TextFormField).first,
                matching: find.byType(EditableText),
              )
              .first,
        )
        .controller
        .text;
  }

  group('ProxyProfileForm SSID pre-population', () {
    testWidgets(
      'name field is pre-populated with WiFi SSID when opening new profile form',
      (tester) async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall call) async {
              if (call.method == 'requestWifiSsidPermissions') return true;
              if (call.method == 'getWifiSsid') return 'MyWifi';
              return null;
            });

        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ProxyProfileForm())),
        );
        await tester.pumpAndSettle();

        expect(_nameFieldValue(tester), 'MyWifi');
      },
    );

    testWidgets('name field is empty when WiFi SSID is null for new profile', (
      tester,
    ) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            if (call.method == 'requestWifiSsidPermissions') return true;
            if (call.method == 'getWifiSsid') return null;
            return null;
          });

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ProxyProfileForm())),
      );
      await tester.pumpAndSettle();

      expect(_nameFieldValue(tester), '');
    });

    testWidgets(
      'name field shows existing profile name when editing (not WiFi SSID)',
      (tester) async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall call) async {
              if (call.method == 'requestWifiSsidPermissions') return true;
              if (call.method == 'getWifiSsid') return 'MyWifi';
              return null;
            });

        const profile = ProxyProfile(
          id: '1',
          name: 'WorkProxy',
          host: 'proxy.example.com',
          port: 8080,
          type: ProxyType.http,
          isActive: false,
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: ProxyProfileForm(initial: profile)),
          ),
        );
        await tester.pumpAndSettle();

        expect(_nameFieldValue(tester), 'WorkProxy');
      },
    );
  });
}
