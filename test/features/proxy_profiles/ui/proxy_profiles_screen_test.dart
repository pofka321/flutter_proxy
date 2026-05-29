import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_proxy/features/proxy_profiles/ui/proxy_profiles_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('com.pofka321.flutter_proxy/system_settings'),
      (call) async => null,
    );
  });

  Widget _wrap() => const MaterialApp(home: ProxyProfilesScreen());

  group('ProxyProfilesScreen', () {
    testWidgets('shows empty state when no profiles', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('No profiles yet. Tap + to add one.'), findsOneWidget);
    });

    testWidgets('shows FAB with add icon', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows settings icon in app bar', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('tapping FAB opens bottom sheet form', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('Save'), findsOneWidget);
    });
  });
}
