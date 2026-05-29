import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proxy/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ProxyProfilesScreen integration', () {
    testWidgets('shows empty state on first launch', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.text('No profiles yet. Tap + to add one.'), findsOneWidget);
    });

    testWidgets('FAB opens bottom sheet form', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Host'), findsOneWidget);
      expect(find.text('Port'), findsOneWidget);
    });

    testWidgets('form validation rejects empty submission', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Required'), findsWidgets);
    });

    testWidgets('can create a profile and see it in the list', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Office');
      await tester.enterText(find.widgetWithText(TextFormField, 'Host'), '192.168.1.1');
      await tester.enterText(find.widgetWithText(TextFormField, 'Port'), '8080');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Office'), findsOneWidget);
      expect(find.text('HTTP 192.168.1.1:8080'), findsOneWidget);
    });
  });
}
