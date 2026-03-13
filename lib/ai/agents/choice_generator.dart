import 'base_agent.dart';
import '../../models/story_state.dart';
import '../../models/genre_rules.dart';

class ChoiceGenerator extends AIAgent {
  ChoiceGenerator(super.provider);

  Future<List<String>> generateChoices(StoryState state, String narrative) async {
    final prompt = _buildPrompt(state, narrative);
    final response = await generate(prompt);
    // Parse choices
    return ['Choice 1', 'Choice 2', 'Choice 3']; // Mock
  }

  String _buildPrompt(StoryState state, String narrative) {
    final rules = GenreRules.getRules(state.genre);
    return '''
Based on this narrative: $narrative

Generate 2-4 contextual player choices for a ${state.genre} story.

Genre Rules:
- Tone: ${rules['tone']}
- Craft Focus: ${rules['craft_focus']}

Choices should be meaningful and advance the plot, following genre conventions.
''';
  }
}