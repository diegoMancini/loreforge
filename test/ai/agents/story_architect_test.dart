import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:loreforge/ai/agents/story_architect.dart';
import '../../fixtures/test_fixtures.dart';

void main() {
  late FakeAIProvider fakeProvider;
  late StoryArchitect architect;

  setUp(() {
    fakeProvider = FakeAIProvider();
    architect = StoryArchitect(fakeProvider);
  });

  group('StoryArchitect.generateBlueprint', () {
    test('parses valid JSON into StoryBlueprint', () async {
      fakeProvider.nextResponse = jsonEncode({
        'premise': 'A wizard discovers a hidden portal.',
        'nodes': [
          {'type': 'act', 'order': 0, 'summary': 'Discovery', 'hints': {}},
          {'type': 'beat', 'order': 1, 'summary': 'Journey', 'hints': {}},
          {'type': 'twist', 'order': 2, 'summary': 'Betrayal', 'hints': {}},
          {'type': 'climax', 'order': 3, 'summary': 'Final battle', 'hints': {}},
          {'type': 'resolution', 'order': 4, 'summary': 'Victory', 'hints': {}},
        ],
      });

      final state = TestFixtures.storyState();
      final blueprint = await architect.generateBlueprint(state);

      expect(blueprint.premise, 'A wizard discovers a hidden portal.');
      expect(blueprint.nodes, hasLength(5));
      expect(blueprint.nodes.first.type, 'act');
      expect(blueprint.nodes.last.type, 'resolution');
    });

    test('returns fallback blueprint for malformed JSON', () async {
      fakeProvider.nextResponse = 'This is not JSON at all';

      final state = TestFixtures.storyState();
      final blueprint = await architect.generateBlueprint(state);

      expect(blueprint.premise, contains('adventure begins'));
      expect(blueprint.nodes, hasLength(2));
      expect(blueprint.nodes.first.type, 'act');
      expect(blueprint.nodes.last.type, 'resolution');
    });

    test('returns fallback blueprint for empty response', () async {
      fakeProvider.nextResponse = '';

      final state = TestFixtures.storyState();
      final blueprint = await architect.generateBlueprint(state);

      expect(blueprint.nodes, hasLength(2));
    });

    test('prompt includes genre', () async {
      fakeProvider.nextResponse = '{}';

      final state = TestFixtures.storyState();
      await architect.generateBlueprint(state);

      expect(fakeProvider.capturedPrompt, contains(state.genre));
    });

    test('prompt includes tone from worldState', () async {
      fakeProvider.nextResponse = '{}';

      final state = TestFixtures.storyState().copyWith(
        worldState: {'_tone': 'dark', '_language': 'en'},
      );
      await architect.generateBlueprint(state);

      expect(fakeProvider.capturedPrompt, contains('dark'));
    });

    test('sorts nodes by order', () async {
      fakeProvider.nextResponse = jsonEncode({
        'premise': 'Out of order.',
        'nodes': [
          {'type': 'resolution', 'order': 2, 'summary': 'End', 'hints': {}},
          {'type': 'act', 'order': 0, 'summary': 'Start', 'hints': {}},
          {'type': 'beat', 'order': 1, 'summary': 'Middle', 'hints': {}},
        ],
      });

      final blueprint = await architect.generateBlueprint(TestFixtures.storyState());

      expect(blueprint.nodes[0].order, 0);
      expect(blueprint.nodes[1].order, 1);
      expect(blueprint.nodes[2].order, 2);
    });
  });
}
