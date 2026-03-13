import 'base_agent.dart';
import '../../models/story_state.dart';
import '../../models/genre_rules.dart';

class SceneWriter extends AIAgent {
  SceneWriter(super.provider);

  Future<String> writeScene(StoryState state) async {
    final prompt = _buildPrompt(state);
    return await generate(prompt);
  }

  Future<Stream<String>> writeSceneStream(StoryState state) async {
    final prompt = _buildPrompt(state);
    return await generateStream(prompt);
  }

  String _buildPrompt(StoryState state) {
    final rules = GenreRules.getRules(state.genre);
    return '''
Write a narrative scene for a ${state.genre} story.

Genre Rules:
- Tone: ${rules['tone']}
- Elements: ${rules['elements'].join(', ')}
- Craft Focus: ${rules['craft_focus']}

Previous scenes: ${state.scenes.join('\n')}
Last choice: ${state.choices.isNotEmpty ? state.choices.last : 'Start'}

Write immersive, engaging prose that follows the genre conventions.
''';
  }
}