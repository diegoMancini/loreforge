import 'base_agent.dart';
import '../../models/story_state.dart';
import '../../models/story_blueprint.dart';
import '../../models/genre_rules.dart';
import '../narrative_reference.dart';

/// Writes narrative scene prose for both Pure Story and RPG Adventure modes.
///
/// Prompt construction is deliberately mode-aware:
/// - Pure Story: literary prose, emotional depth, no mechanical language.
/// - RPG Adventure: environmental interactables, stat-relevant challenges,
///   inventory mentions, and mechanically grounded descriptions.
///
/// Both modes embed NarrativeReference craft guidance and use the rolling
/// [StoryState.storySummary] (or the last 2 scenes) as context instead of
/// dumping the full scene list, which would blow token budgets.
class SceneWriter extends AIAgent {
  SceneWriter(super.provider);

  // ---------------------------------------------------------------------------
  // Public surface
  // ---------------------------------------------------------------------------

  Future<String> writeScene(StoryState state,
      {BlueprintNode? blueprintNode}) async {
    final prompt = blueprintNode != null
        ? _buildBlueprintPrompt(state, blueprintNode)
        : _buildPrompt(state);
    return generate(prompt);
  }

  Future<Stream<String>> writeSceneStream(
    StoryState state, {
    BlueprintNode? blueprintNode,
  }) async {
    final prompt = blueprintNode != null
        ? _buildBlueprintPrompt(state, blueprintNode)
        : _buildPrompt(state);
    return generateStream(prompt);
  }

  /// Writes a scene that expands a specific blueprint node into full prose.
  Future<String> writeSceneFromBlueprint(
    StoryState state,
    BlueprintNode node,
  ) async {
    final prompt = _buildBlueprintPrompt(state, node);
    return generate(prompt);
  }

  // ---------------------------------------------------------------------------
  // Prompt builders
  // ---------------------------------------------------------------------------

  String _buildPrompt(StoryState state) {
    final rules = GenreRules.getRules(state.genre);
    final tone = state.worldState['_tone'] as String? ?? 'epic';
    final language = state.worldState['_language'] as String? ?? '';

    final buffer = StringBuffer();

    // --- System framing ---
    buffer.writeln(
        'You are a master fiction writer. Write a vivid narrative scene for a '
        '${state.genre} story.');
    buffer.writeln();

    // --- Craft guidance ---
    buffer.writeln(NarrativeReference.getCraftGuidance(state.genre));
    buffer.writeln(NarrativeReference.getUniversalPrinciples());

    // --- Genre rules ---
    buffer.writeln('GENRE RULES');
    buffer.writeln('Tone: ${rules['tone']}');
    buffer.writeln('Session tone: $tone');
    buffer.writeln('Elements: ${(rules['elements'] as List).join(', ')}');
    buffer.writeln('Craft focus: ${rules['craft_focus']}');
    buffer.writeln();

    // --- Story context (token-safe) ---
    buffer.writeln('STORY CONTEXT');
    if (state.storySummary.isNotEmpty) {
      buffer.writeln('Story so far: ${state.storySummary}');
    } else if (state.scenes.isNotEmpty) {
      // Fall back to last 2 scenes maximum to stay within token budget.
      final recentScenes = state.scenes.length > 2
          ? state.scenes.sublist(state.scenes.length - 2)
          : state.scenes;
      buffer.writeln('Recent scenes:');
      for (final scene in recentScenes) {
        buffer.writeln(scene);
      }
    } else {
      buffer.writeln('This is the opening scene.');
    }

    if (state.choices.isNotEmpty) {
      buffer.writeln('Last player choice: ${state.choices.last}');
    }
    buffer.writeln();

    // --- Mode-specific instructions ---
    if (state.mode == 'rpg') {
      _appendRpgInstructions(buffer, state);
    } else {
      _appendPureStoryInstructions(buffer);
    }

    // --- Language override ---
    if (language == 'es') {
      buffer.writeln();
      buffer.writeln('LANGUAGE: Write entirely in Spanish.');
    } else if (language.isNotEmpty && language != 'en') {
      buffer.writeln();
      buffer.writeln('LANGUAGE: Write entirely in $language.');
    }

    // --- Output instruction ---
    buffer.writeln();
    buffer.writeln(
        'Write immersive prose of 150–300 words. Do not include choices — '
        'the scene should end at a moment of tension or decision.');

    return buffer.toString();
  }

  String _buildBlueprintPrompt(StoryState state, BlueprintNode node) {
    final rules = GenreRules.getRules(state.genre);
    final tone = state.worldState['_tone'] as String? ?? 'epic';
    final language = state.worldState['_language'] as String? ?? '';

    final buffer = StringBuffer();

    buffer.writeln(
        'You are a master fiction writer. Expand a story blueprint node into '
        'a full narrative scene for a ${state.genre} story.');
    buffer.writeln();

    buffer.writeln(NarrativeReference.getCraftGuidance(state.genre));
    buffer.writeln(NarrativeReference.getUniversalPrinciples());

    buffer.writeln('GENRE RULES');
    buffer.writeln('Tone: ${rules['tone']}');
    buffer.writeln('Session tone: $tone');
    buffer.writeln('Craft focus: ${rules['craft_focus']}');
    buffer.writeln();

    // --- Blueprint node context ---
    buffer.writeln('BLUEPRINT NODE');
    buffer.writeln('Summary: ${node.summary}');
    buffer.writeln('Type: ${node.type}');
    buffer.writeln();

    // --- Story context (token-safe) ---
    buffer.writeln('STORY CONTEXT');
    if (state.storySummary.isNotEmpty) {
      buffer.writeln('Story so far: ${state.storySummary}');
    } else if (state.scenes.isNotEmpty) {
      final recentScenes = state.scenes.length > 2
          ? state.scenes.sublist(state.scenes.length - 2)
          : state.scenes;
      buffer.writeln('Recent scenes:');
      for (final scene in recentScenes) {
        buffer.writeln(scene);
      }
    }

    if (state.choices.isNotEmpty) {
      buffer.writeln('Last player choice: ${state.choices.last}');
    }
    buffer.writeln();

    // --- Mode-specific instructions ---
    if (state.mode == 'rpg') {
      _appendRpgInstructions(buffer, state);
    } else {
      _appendPureStoryInstructions(buffer);
    }

    // --- Blueprint expansion directive ---
    buffer.writeln();
    buffer.writeln(
        'IMPORTANT: Write vivid prose that brings the blueprint summary to '
        'life. Do NOT summarise — expand into full narrative. Every detail in '
        'the summary should become a concrete sensory moment in the prose.');

    // --- Language override ---
    if (language == 'es') {
      buffer.writeln();
      buffer.writeln('LANGUAGE: Write entirely in Spanish.');
    } else if (language.isNotEmpty && language != 'en') {
      buffer.writeln();
      buffer.writeln('LANGUAGE: Write entirely in $language.');
    }

    buffer.writeln();
    buffer.writeln(
        'Write immersive prose of 150–300 words. End at a moment of tension '
        'that demands a decision.');

    return buffer.toString();
  }

  // ---------------------------------------------------------------------------
  // Mode-specific instruction blocks
  // ---------------------------------------------------------------------------

  void _appendRpgInstructions(StringBuffer buffer, StoryState state) {
    buffer.writeln('RPG ADVENTURE MODE INSTRUCTIONS');
    buffer.writeln(
        '- Include environmental details the player can interact with '
        '(levers, locked doors, hidden objects, climbable surfaces).');
    buffer.writeln(
        '- Reference the player\'s abilities where relevant — describe '
        'challenges that test specific stats without naming the stat explicitly.');
    buffer.writeln(
        '- Mention items and equipment naturally in the narrative '
        '(worn, carried, or spotted in the environment).');
    buffer.writeln(
        '- Describe mechanical elements (locks to pick, enemies to fight, '
        'cliffs to climb) with enough specificity that stat checks feel grounded.');

    if (state.rpgState != null) {
      final rpg = state.rpgState!;
      buffer.writeln();
      buffer.writeln('CURRENT CHARACTER STATE');
      buffer.writeln(
          'Stats — STR: ${rpg.strength}, AGI: ${rpg.agility}, '
          'INT: ${rpg.intelligence}, CHA: ${rpg.charisma}, '
          'PER: ${rpg.perception}, WIL: ${rpg.willpower}');
      if (rpg.inventory.isNotEmpty) {
        buffer.writeln('Inventory: ${rpg.inventory.join(', ')}');
      }
    }
  }

  void _appendPureStoryInstructions(StringBuffer buffer) {
    buffer.writeln('PURE STORY MODE INSTRUCTIONS');
    buffer.writeln('- Focus on emotional depth and character development.');
    buffer.writeln(
        '- Use literary prose techniques: metaphor, sensory detail, '
        'internal monologue, and subtext.');
    buffer.writeln(
        '- No game-mechanical language — no references to stats, checks, '
        'or scores under any circumstances.');
    buffer.writeln(
        '- Let the character\'s values and relationships drive tension. '
        'External events are a mirror for internal conflict.');
  }
}
