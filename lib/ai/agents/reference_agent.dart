import 'base_agent.dart';

class ReferenceAgent extends AIAgent {
  ReferenceAgent(super.provider);

  Future<Map<String, dynamic>> analyzeFavoriteStories(List<String> stories) async {
    if (stories.isEmpty) return {};

    final prompt = _buildPrompt(stories);
    final response = await generate(prompt);
    // Parse taste profile
    return {
      'preferred_genres': ['fantasy', 'mystery'],
      'tone_preferences': ['epic', 'suspenseful'],
      'character_types': ['heroic', 'complex'],
      'plot_elements': ['quests', 'twists'],
    }; // Mock
  }

  String _buildPrompt(List<String> stories) {
    return '''
Analyze these favorite stories to create a taste profile:

${stories.map((s) => '"$s"').join('\n')}

Extract preferences for:
- Genres
- Tones/Moods
- Character archetypes
- Plot elements
- Writing styles

Output JSON with taste profile.
''';
  }
}