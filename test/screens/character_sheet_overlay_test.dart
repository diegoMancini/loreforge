import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loreforge/models/story_state.dart';
import 'package:loreforge/models/rpg_state.dart';
import 'package:loreforge/providers/story_provider.dart';
import 'package:loreforge/screens/character_sheet_overlay.dart';

void main() {
  Widget buildSubject({StoryState? storyState}) {
    final container = ProviderContainer(overrides: [
      storyProvider.overrideWith((ref) {
        final notifier = StoryNotifier(ref);
        if (storyState != null) {
          notifier.loadStory(storyState);
        }
        return notifier;
      }),
    ]);

    return UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(body: CharacterSheetOverlay()),
      ),
    );
  }

  testWidgets('renders SizedBox.shrink when rpgState is null', (tester) async {
    await tester.pumpWidget(buildSubject());

    // With null rpgState the widget returns SizedBox.shrink, so no Dialog
    expect(find.byType(Dialog), findsNothing);
    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('renders stat names when rpgState is present', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = StoryState.initial().copyWith(
      rpgState: RPGState.initial(),
    );

    await tester.pumpWidget(buildSubject(storyState: state));

    for (final stat in [
      'Strength',
      'Agility',
      'Intelligence',
      'Charisma',
      'Perception',
      'Willpower',
    ]) {
      expect(find.text(stat), findsOneWidget);
    }
  });

  testWidgets('renders score value from rpgState', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = StoryState.initial().copyWith(
      rpgState: const RPGState(
        strength: 12,
        agility: 14,
        intelligence: 8,
        charisma: 10,
        perception: 11,
        willpower: 9,
        inventory: [],
        score: 42,
      ),
    );

    await tester.pumpWidget(buildSubject(storyState: state));

    expect(find.text('Adventure Score'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
  });
}
