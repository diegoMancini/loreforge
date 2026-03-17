import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loreforge/models/story_state.dart';
import 'package:loreforge/models/rpg_state.dart';
import 'package:loreforge/providers/story_provider.dart';
import 'package:loreforge/screens/inventory_overlay.dart';

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
        home: Scaffold(body: InventoryOverlay()),
      ),
    );
  }

  testWidgets('renders empty state message when inventory is empty',
      (tester) async {
    final state = StoryState.initial().copyWith(
      rpgState: RPGState.initial(),
    );

    await tester.pumpWidget(buildSubject(storyState: state));

    expect(find.text('Your pack lies empty, waiting to be filled...'), findsOneWidget);
  });

  testWidgets('renders item names when inventory has items', (tester) async {
    final state = StoryState.initial().copyWith(
      rpgState: const RPGState(
        strength: 10,
        agility: 10,
        intelligence: 10,
        charisma: 10,
        perception: 10,
        willpower: 10,
        inventory: ['Magic Sword', 'Health Potion'],
        score: 0,
      ),
    );

    await tester.pumpWidget(buildSubject(storyState: state));

    expect(find.text('Magic Sword'), findsOneWidget);
    expect(find.text('Health Potion'), findsOneWidget);
  });

  testWidgets('does not show empty message when items are present',
      (tester) async {
    final state = StoryState.initial().copyWith(
      rpgState: const RPGState(
        strength: 10,
        agility: 10,
        intelligence: 10,
        charisma: 10,
        perception: 10,
        willpower: 10,
        inventory: ['Magic Sword', 'Health Potion'],
        score: 0,
      ),
    );

    await tester.pumpWidget(buildSubject(storyState: state));

    expect(find.text('Your pack lies empty, waiting to be filled...'), findsNothing);
    expect(find.text('Magic Sword'), findsOneWidget);
    expect(find.text('Health Potion'), findsOneWidget);
  });
}
