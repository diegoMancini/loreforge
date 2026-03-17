import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loreforge/screens/main_menu_screen.dart';

void main() {
  testWidgets('MainMenuScreen renders title and core buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MainMenuScreen(),
        ),
      ),
    );

    // Title is present.
    expect(find.text('LOREFORGE'), findsOneWidget);

    // Primary CTA is present.
    expect(find.text('New Adventure'), findsOneWidget);

    // Continue button is present.
    expect(find.text('Continue Adventure'), findsOneWidget);

    // Settings link is present.
    expect(find.text('Settings'), findsOneWidget);
  });
}
