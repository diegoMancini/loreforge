import 'base_agent.dart';
import '../utils/json_parser.dart';

/// Analyses a player's list of favourite stories to infer their narrative
/// taste profile.
///
/// The taste profile drives session-zero personalisation: preferred themes,
/// tone preferences, character archetypes, and plot elements are used by
/// StoryArchitect when constructing the initial story blueprint.
///
/// Previously returned hard-coded mock data. Now parses a real AI response
/// for keys: preferred_themes, tone_preferences, character_types, plot_elements.
class ReferenceAgent extends AIAgent {
  ReferenceAgent(super.provider);

  // ---------------------------------------------------------------------------
  // Public surface
  // ---------------------------------------------------------------------------

  /// Renamed entry point (matches spec: [analyzeTasteProfile]).
  Future<Map<String, dynamic>> analyzeTasteProfile(
      List<String> favoriteStories) async {
    if (favoriteStories.isEmpty) return {};

    final prompt = _buildAnalysisPrompt(favoriteStories);
    final response = await generate(prompt, maxTokens: 512);
    return _parseResponse(response);
  }

  /// Legacy alias kept for backwards compatibility with existing callers.
  Future<Map<String, dynamic>> analyzeFavoriteStories(
      List<String> stories) async {
    return analyzeTasteProfile(stories);
  }

  // ---------------------------------------------------------------------------
  // Prompt builder
  // ---------------------------------------------------------------------------

  String _buildAnalysisPrompt(List<String> stories) {
    final buffer = StringBuffer();

    buffer.writeln(
        'You are a literary analyst. Analyse the following list of favourite '
        'stories to extract the reader\'s narrative taste profile.');
    buffer.writeln();

    buffer.writeln('FAVOURITE STORIES');
    for (final story in stories) {
      buffer.writeln('- "$story"');
    }
    buffer.writeln();

    buffer.writeln(
        'Identify patterns across these titles to infer the reader\'s '
        'preferences. Consider: genre, tone, character archetypes, plot '
        'structures, thematic concerns, writing style.');
    buffer.writeln();

    buffer.writeln('OUTPUT FORMAT');
    buffer.writeln('Return a JSON object with exactly these keys:');
    buffer.writeln(
        '- preferred_themes: array of strings (e.g. ["redemption", '
        '"found family", "power and corruption"])');
    buffer.writeln(
        '- tone_preferences: array of strings (e.g. ["dark and gritty", '
        '"hopeful despite adversity"])');
    buffer.writeln(
        '- character_types: array of strings (e.g. ["reluctant heroes", '
        '"morally grey antagonists", "loyal sidekicks"])');
    buffer.writeln(
        '- plot_elements: array of strings (e.g. ["heist structures", '
        '"prophecy subversion", "political intrigue"])');

    return buffer.toString();
  }

  // ---------------------------------------------------------------------------
  // Response parsing
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _parseResponse(String response) {
    final parsed = AIJsonParser.parseMap(response);
    if (parsed.isEmpty) return {};

    // Validate and normalise expected keys. Return only what is well-formed.
    final result = <String, dynamic>{};
    for (final key in [
      'preferred_themes',
      'tone_preferences',
      'character_types',
      'plot_elements',
    ]) {
      final value = parsed[key];
      if (value is List && value.isNotEmpty) {
        result[key] = value.whereType<String>().toList();
      }
    }

    return result;
  }
}
