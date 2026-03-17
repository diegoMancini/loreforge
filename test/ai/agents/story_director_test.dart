import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:loreforge/ai/agents/story_director.dart';

import '../../fixtures/test_fixtures.dart';

void main() {
  late FakeAIProvider fake;
  late StoryDirector director;

  setUp(() {
    fake = FakeAIProvider();
    director = StoryDirector(fake);
  });

  final state = TestFixtures.storyState();

  group('StoryDirector.planScene', () {
    test('parses valid JSON into guidance map', () async {
      fake.nextResponse = TestFixtures.validDirectorJson();
      final result = await director.planScene(state);
      expect(result['plot_arc'], 'rising');
      expect(result['tension'], 'medium');
      expect(result['active_threads'], ['dragon threat']);
      expect(result['direction'], 'Introduce the mysterious stranger');
    });

    test('returns empty map when no JSON in response', () async {
      fake.nextResponse = 'Build tension by introducing a shadowy figure.';
      final result = await director.planScene(state);
      expect(result, isEmpty);
    });

    test('returns empty map for malformed JSON', () async {
      fake.nextResponse = '{"plot_arc": "rising", broken stuff here}';
      final result = await director.planScene(state);
      expect(result, isEmpty);
    });

    test('extracts JSON wrapped in markdown fences', () async {
      final json = jsonEncode({
        'plot_arc': 'climax',
        'tension': 'high',
        'active_threads': ['betrayal'],
        'direction': 'Reveal the traitor',
      });
      fake.nextResponse = '```json\n$json\n```';
      final result = await director.planScene(state);
      expect(result['plot_arc'], 'climax');
      expect(result['tension'], 'high');
      expect(result['active_threads'], ['betrayal']);
      expect(result['direction'], 'Reveal the traitor');
    });
  });
}
