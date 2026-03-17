import 'dart:convert';

import 'base_agent.dart';
import '../../models/story_state.dart';
import '../../models/story_blueprint.dart';

/// Generates a high-level [StoryBlueprint] before gameplay begins.
///
/// The architect reads tone, language, and twists preferences from
/// [StoryState.worldState] (populated by [StoryNotifier.startNewStoryFromSessionZero])
/// and produces an ordered sequence of [BlueprintNode] entries that downstream
/// agents (SceneWriter, StoryDirector) can reference for structural guidance.
class StoryArchitect extends AIAgent {
  StoryArchitect(super.provider);

  Future<StoryBlueprint> generateBlueprint(StoryState state) async {
    final prompt = _buildPrompt(state);
    final response = await generate(prompt);
    return _parseBlueprint(response, state);
  }

  /// Extends an existing [StoryBlueprint] from [fromNodeId] with additional
  /// depth. Returns a partial blueprint containing only the new nodes.
  Future<StoryBlueprint> extendBlueprint(
    StoryBlueprint current,
    String fromNodeId,
    StoryState state,
  ) async {
    final prompt = _buildExtensionPrompt(current, fromNodeId, state);
    final response = await generate(prompt);
    return _parseBlueprint(response, state);
  }

  String _buildPrompt(StoryState state) {
    final worldState = state.worldState;

    // Keys populated by startNewStoryFromSessionZero — fall back to sensible defaults
    final storyPremise = (worldState['_storyPremise'] as String? ?? '').trim();
    final tone = worldState['_tone'] as String? ?? 'epic';
    final language = worldState['_language'] as String? ?? 'en';
    final twistsEnabled = worldState['_twistsEnabled'] as bool? ?? true;
    final favoriteStories =
        (worldState['_favoriteStories'] as List<dynamic>?)?.cast<String>() ??
            [];

    final premiseSection = storyPremise.isNotEmpty
        ? 'Story Premise: $storyPremise'
        : 'No specific premise — generate one appropriate for the genre.';

    final favSection = favoriteStories.isNotEmpty
        ? 'Draw inspiration from: ${favoriteStories.join(', ')}'
        : '';

    return '''
You are the Story Architect. Design a complete structural blueprint for a ${state.genre} story.

$premiseSection
Tone: $tone
Language: $language
Twists enabled: $twistsEnabled
$favSection

Output a JSON object with this exact shape:
{
  "premise": "<one-sentence story premise>",
  "nodes": [
    {"type": "act",        "order": 0, "summary": "<what happens>", "hints": {}},
    {"type": "beat",       "order": 1, "summary": "<what happens>", "hints": {}},
    {"type": "twist",      "order": 2, "summary": "<what happens>", "hints": {}},
    {"type": "climax",     "order": 3, "summary": "<what happens>", "hints": {}},
    {"type": "resolution", "order": 4, "summary": "<what happens>", "hints": {}}
  ]
}

Include ${twistsEnabled ? 'at least one twist node' : 'no twist nodes'}.
Respond ONLY with valid JSON — no markdown fences, no extra text.
''';
  }

  String _buildExtensionPrompt(
    StoryBlueprint current,
    String fromNodeId,
    StoryState state,
  ) {
    final tone = state.worldState['_tone'] as String? ?? 'epic';

    return '''
You are the Story Architect extending an existing blueprint.

Current premise: ${current.premise}
Tone: $tone
Extend from node: $fromNodeId

Generate 2–3 additional nodes that continue the story from the specified node.
Output a JSON object with the same shape as the original blueprint (premise + nodes array).
Only include the new continuation nodes, with order values continuing from where the existing nodes left off.
Respond ONLY with valid JSON.
''';
  }

  /// Parses the AI response into a [StoryBlueprint].
  ///
  /// If the response is not valid JSON (e.g., mock provider returns plain text)
  /// a minimal fallback blueprint is returned so gameplay can always proceed.
  StoryBlueprint _parseBlueprint(String response, StoryState state) {
    final worldState = state.worldState;
    final tone = worldState['_tone'] as String? ?? 'epic';
    final language = worldState['_language'] as String? ?? 'en';

    try {
      final json = jsonDecode(response) as Map<String, dynamic>;
      final rawNodes = json['nodes'] as List<dynamic>? ?? [];
      final nodes = rawNodes
          .map((n) => BlueprintNode.fromJson(n as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      return StoryBlueprint(
        premise: json['premise'] as String? ?? '',
        tone: tone,
        language: language,
        nodes: nodes,
      );
    } catch (_) {
      // Fallback: produce a minimal two-node blueprint so the pipeline never stalls
      return StoryBlueprint(
        premise: 'A ${state.genre} adventure begins.',
        tone: tone,
        language: language,
        nodes: const [
          BlueprintNode(type: 'act', order: 0, summary: 'The adventure begins.'),
          BlueprintNode(
              type: 'resolution', order: 1, summary: 'The story concludes.'),
        ],
      );
    }
  }
}
