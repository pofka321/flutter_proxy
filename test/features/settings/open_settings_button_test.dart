import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_proxy/features/settings/open_settings_button.dart';

void main() {
  const channel =
      MethodChannel('com.pofka321.flutter_proxy/system_settings');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  Widget buildUnderTest() {
    return const MaterialApp(
      home: Scaffold(
        body: OpenSettingsButton(),
      ),
    );
  }

  testWidgets('smoke test: renders button with correct label',
      (WidgetTester tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => null);

    await tester.pumpWidget(buildUnderTest());

    expect(find.text('Open WiFi Settings'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('button tap completes without showing SnackBar on success',
      (WidgetTester tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => null);

    await tester.pumpWidget(buildUnderTest());
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('button tap shows SnackBar with error message on PlatformException',
      (WidgetTester tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(
          code: 'UNAVAILABLE', message: 'Settings unavailable');
    });

    await tester.pumpWidget(buildUnderTest());
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // allow async to complete
    await tester.pump(); // allow SnackBar to render

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Settings unavailable'), findsOneWidget);
  });

  testWidgets(
      'button tap shows SnackBar with fallback message when PlatformException has no message',
      (WidgetTester tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'UNAVAILABLE');
    });

    await tester.pumpWidget(buildUnderTest());
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Unknown error'), findsOneWidget);
  });
}
