import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_proxy/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const channel =
      MethodChannel('com.pofka321.flutter_proxy/system_settings');

  testWidgets('Settings icon renders in app bar', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('Settings icon is tappable without crashing', (tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      if (call.method == 'openWifiSettings') {
        return null;
      }
      return null;
    });

    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byIcon(Icons.settings), findsOneWidget);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });
}
