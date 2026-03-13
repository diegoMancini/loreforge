import 'base_agent.dart';
import '../../models/story_state.dart';

class StoryDirector extends AIAgent {
  StoryDirector(super.provider);

  Future<Map<String, dynamic>> planScene(StoryState state) async {
    final prompt = _buildPrompt(state);
    final response = await generate(prompt);
    // Parse JSON response
    return {}; // Mock
  }

  String _buildPrompt(StoryState state) {
    return '''
As the Story Director, analyze the current story state and provide direction.

Genre: ${state.genre}
Current act: 1
Tension: medium
Unresolved conflicts: []

Output JSON with plot arc, tension, active threads.
''';
  }
}