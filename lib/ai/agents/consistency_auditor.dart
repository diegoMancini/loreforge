import 'base_agent.dart';
import '../../models/story_state.dart';

class ConsistencyAuditor extends AIAgent {
  ConsistencyAuditor(super.provider);

  Future<bool> validateScene(StoryState state, String narrative, List<String> choices) async {
    final prompt = _buildPrompt(state, narrative, choices);
    final response = await generate(prompt);
    // Parse validation result
    return true; // Mock - would check for consistency
  }

  String _buildPrompt(StoryState state, String narrative, List<String> choices) {
    return '''
Validate this scene for consistency with the story world:

Genre: ${state.genre}
Previous scenes: ${state.scenes.take(3).join('\n')}
World state: ${state.worldState}
Narrative: $narrative
Choices: ${choices.join(', ')}

Check for:
- Character consistency
- World rules adherence
- Logical plot progression
- Genre conventions

Output: "VALID" or "INVALID: [reason]"
''';
  }
}