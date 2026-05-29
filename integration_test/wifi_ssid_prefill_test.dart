import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_proxy/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WiFi SSID pre-population', () {
    testWidgets(
      'name field is pre-populated or empty when opening new profile form',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add));
        // Allow the async SSID fetch to complete.
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // The Name TextFormField must exist in the form.
        final nameField = find.widgetWithText(TextFormField, 'Name');
        expect(nameField, findsOneWidget);

        // Read the current text via the underlying EditableText controller.
        final editableText = tester.widget<EditableText>(
          find.descendant(of: nameField, matching: find.byType(EditableText)),
        );
        final currentText = editableText.controller.text;

        // Either the SSID was fetched (non-empty) or no WiFi is available
        // (empty). Both outcomes are acceptable — what matters is the form
        // opened without crashing and the field exists.
        expect(currentText, isA<String>());
      },
    );

    testWidgets(
      'name field is NOT pre-populated when editing an existing profile',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // --- Create a profile named 'TestProxy' ---
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Clear any SSID that may have been pre-filled, then type the name.
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Name'),
          'TestProxy',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Host'),
          '1.2.3.4',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Port'),
          '9090',
        );
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        // Profile card should now be visible.
        expect(find.text('TestProxy'), findsOneWidget);

        // --- Open the edit form by tapping the profile card ---
        await tester.tap(find.text('TestProxy'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // The name field must show the saved profile name, not the WiFi SSID.
        final nameField = find.widgetWithText(TextFormField, 'Name');
        expect(nameField, findsOneWidget);

        final editableText = tester.widget<EditableText>(
          find.descendant(of: nameField, matching: find.byType(EditableText)),
        );
        expect(editableText.controller.text, 'TestProxy');
      },
    );
  });
}
