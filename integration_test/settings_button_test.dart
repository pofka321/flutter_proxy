import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_proxy/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const channel =
      MethodChannel('com.pofka321.flutter_proxy/system_settings');

  testWidgets('Button renders with correct label', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Open WiFi Settings'), findsOneWidget);
  });

  testWidgets('Button is tappable without crashing', (tester) async {
    // Mock the platform channel so no MissingPluginException is thrown.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      if (call.method == 'openWifiSettings') {
        return null;
      }
      return null;
    });

    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open WiFi Settings'));
    // Pump several frames to let any async work settle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Assert the app is still alive and the button is still present.
    expect(find.text('Open WiFi Settings'), findsOneWidget);

    // Clean up the mock.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });
}
