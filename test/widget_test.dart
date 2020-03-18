import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yapa/main.dart';

void main() {
  testWidgets('Yapa smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(YapaApp());

    // Verify that our app shows Catalog.
    expect(find.text('Catalog'), findsOneWidget);
    expect(find.text('Not existing text'), findsNothing);

    // Wait for items loaded.
    await tester.pump(new Duration(milliseconds: 3000));

    // Tap the checkbox icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.check_box).first);
    await tester.pump();

    // Verify that nothing changed.
    expect(find.text('Catalog'), findsOneWidget);
    expect(find.text('Not existing text'), findsNothing);
  });
}
