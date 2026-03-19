import 'base_agent.dart';
import '../../models/story_state.dart';

class VisualDirector extends AIAgent {
  VisualDirector(super.provider);

  Future<VisualAssets> selectAssets(StoryState state, String narrative) async {
    final prompt = _buildPrompt(state, narrative);
    await generate(prompt);
    // TODO: Parse AI response for background and sprites
    return VisualAssets(
      background: _getBackgroundForGenre(state.genre),
      sprites: _getSpritesForScene(narrative),
    );
  }

  String _buildPrompt(StoryState state, String narrative) {
    return '''
Based on this ${state.genre} scene: "$narrative"

Select appropriate visual assets:
- Background: Choose from forest, castle, city, space, etc.
- Sprites: Choose characters/objects that fit the scene

Output JSON: {"background": "name", "sprites": ["sprite1", "sprite2"]}
''';
  }

  String _getBackgroundForGenre(String genre) {
    switch (genre.toLowerCase()) {
      case 'fantasy': return 'fantasy_forest';
      case 'horror': return 'dark_forest';
      case 'mystery': return 'noir_city';
      case 'sci-fi': return 'space_station';
      default: return 'default';
    }
  }

  List<String> _getSpritesForScene(String narrative) {
    // Simple keyword matching for now
    final sprites = <String>[];
    if (narrative.contains('knight') || narrative.contains('warrior')) {
      sprites.add('knight');
    }
    if (narrative.contains('wizard') || narrative.contains('mage')) {
      sprites.add('wizard');
    }
    if (narrative.contains('monster') || narrative.contains('creature')) {
      sprites.add('monster');
    }
    return sprites;
  }
}

class VisualAssets {
  final String background;
  final List<String> sprites;

  VisualAssets({required this.background, required this.sprites});
}