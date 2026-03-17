import 'base_agent.dart';
import '../../models/story_state.dart';
import '../../models/genre_rules.dart';
import '../narrative_reference.dart';
import '../utils/json_parser.dart';

/// Analyses story state and provides high-level narrative direction.
///
/// The director tracks pacing, active threads, and character arcs. It outputs
/// a JSON direction object consumed by other agents (scene writer, twist
/// evaluator) to maintain structural coherence across a session.
///
/// The prompt includes:
/// - Genre pacing structure from [GenreRules]
/// - Active characters and unresolved threads from [StoryState]
/// - Rolling [StoryState.storySummary] for longitudinal context
/// - Universal narrative principles from [NarrativeReference]
class StoryDirector extends AIAgent {
  StoryDirector(super.provider);

  // ---------------------------------------------------------------------------
  // Public surface
  // ---------------------------------------------------------------------------

  /// Returns a direction map with keys: plotArc, tension, activeThreads,
  /// suggestedMood, pacingNote, nextSceneFocus.
  ///
  /// Returns an empty map on parse failure so callers can apply defaults.
  Future<Map<String, dynamic>> planScene(StoryState state) async {
    final prompt = _buildPrompt(state);
    final response = await generate(prompt, maxTokens: 512);
    return AIJsonParser.parseMap(response);
  }

  // ---------------------------------------------------------------------------
  // Prompt builder
  // ---------------------------------------------------------------------------

  String _buildPrompt(StoryState state) {
    final rules = GenreRules.getRules(state.genre);
    final sceneCount = state.scenes.length;
    final actLabel = _estimateAct(sceneCount);

    final buffer = StringBuffer();

    buffer.writeln(
        'You are the Story Director for a ${state.genre} narrative. '
        'Analyse the current story state and provide pacing and direction '
        'guidance for the next scene.');
    buffer.writeln();

    // --- Pacing structure ---
    buffer.writeln('GENRE PACING STRUCTURE');
    buffer.writeln(rules['pacingStructure']);
    buffer.writeln();

    // --- Universal principles ---
    buffer.writeln(NarrativeReference.getUniversalPrinciples());

    // --- Current story state ---
    buffer.writeln('CURRENT STORY STATE');
    buffer.writeln('Genre: ${state.genre}');
    buffer.writeln('Mode: ${state.mode}');
    buffer.writeln('Scene count: $sceneCount (estimated position: $actLabel)');

    if (state.storySummary.isNotEmpty) {
      buffer.writeln('Story so far: ${state.storySummary}');
    }

    if (state.activeCharacters.isNotEmpty) {
      buffer.writeln(
          'Active characters: ${state.activeCharacters.join(', ')}');
    }

    if (state.activeThreads.isNotEmpty) {
      buffer.writeln(
          'Unresolved threads: ${state.activeThreads.join(' | ')}');
    }

    if (state.choices.isNotEmpty) {
      buffer.writeln('Last player choice: ${state.choices.last}');
    }
    buffer.writeln();

    // --- Task ---
    buffer.writeln(
        'Based on the above, provide direction for the next scene. '
        'Consider whether tension should escalate, plateau, or release. '
        'Identify which unresolved thread should be activated. '
        'Ensure the pacing matches the act position.');
    buffer.writeln();

    // --- Output format ---
    buffer.writeln('OUTPUT FORMAT');
    buffer.writeln('Return a JSON object with exactly these keys:');
    buffer.writeln(
        '- plotArc: one of "rising_action", "complication", "climax", '
        '"falling_action", "resolution"');
    buffer.writeln(
        '- tension: one of "low", "medium", "high", "critical"');
    buffer.writeln(
        '- activeThreads: array of strings naming the threads to activate '
        'this scene (subset of unresolved threads above)');
    buffer.writeln(
        '- suggestedMood: one-word emotional register for the scene '
        '(e.g. "foreboding", "triumphant", "melancholic")');
    buffer.writeln(
        '- pacingNote: one sentence explaining the pacing decision');
    buffer.writeln(
        '- nextSceneFocus: one sentence describing what the next scene '
        'should prioritise narratively');

    return buffer.toString();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Estimates the three-act position based on scene count.
  /// Uses rough proportions: Act 1 ≈ first 25%, Act 2 ≈ 50%, Act 3 ≈ last 25%.
  String _estimateAct(int sceneCount) {
    if (sceneCount <= 2) return 'Act 1 — setup';
    if (sceneCount <= 6) return 'Act 2 — complication';
    if (sceneCount <= 9) return 'Act 2 — crisis';
    return 'Act 3 — resolution';
  }
}
