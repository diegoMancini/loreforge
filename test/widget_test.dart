import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loreforge/main.dart';

void main() {
  testWidgets('Main menu screen renders Loreforge title', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // The main menu should show the app title.
    expect(find.text('Loreforge'), findsOneWidget);

    // The new adventure button should be present.
    expect(find.text('New Adventure'), findsOneWidget);
  });
}
