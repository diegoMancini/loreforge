import 'package:flutter_test/flutter_test.dart';
import 'package:loreforge/ai/agents/scene_writer.dart';

import '../../fixtures/test_fixtures.dart';

void main() {
  late FakeAIProvider fakeProvider;
  late SceneWriter writer;

  setUp(() {
    fakeProvider = FakeAIProvider();
    writer = SceneWriter(fakeProvider);
  });

  group('SceneWriter', () {
    test('writeScene returns provider response as-is', () async {
      fakeProvider.nextResponse = 'The forest was dark and foreboding.';
      final state = TestFixtures.storyState();

      final result = await writer.writeScene(state);

      expect(result, 'The forest was dark and foreboding.');
    });

    test('writeSceneStream returns stream of words', () async {
      fakeProvider.nextResponse = 'The hero walked forward';
      final state = TestFixtures.storyState();

      final stream = await writer.writeSceneStream(state);
      final words = await stream.toList();

      expect(words, ['The ', 'hero ', 'walked ', 'forward ']);
    });

    test('uses blueprint prompt path when blueprintNode provided', () async {
      fakeProvider.nextResponse = 'Scene from blueprint.';
      final state = TestFixtures.storyState();
      final node = TestFixtures.blueprintNode(
        summary: 'A dragon guards the ancient gate.',
      );

      await writer.writeScene(state, blueprintNode: node);

      expect(fakeProvider.capturedPrompt, isNotNull);
      expect(
        fakeProvider.capturedPrompt!,
        contains('A dragon guards the ancient gate.'),
      );
      // Should contain blueprint-specific markers
      expect(fakeProvider.capturedPrompt!, contains('BLUEPRINT NODE'));
    });
  });
}
