import 'base_agent.dart';
import '../../models/story_state.dart';
import '../../models/genre_rules.dart';
import '../narrative_reference.dart';
import '../utils/json_parser.dart';

/// Generates contextual player choices after each narrative scene.
///
/// Choice generation is mode-aware:
/// - RPG mode: at least one physical challenge and one mental/social challenge
///   so that different stats remain relevant across a session.
/// - Pure Story mode: choices test values and relationships, not abilities.
///   Moral complexity over tactical calculation.
///
/// Both modes use [NarrativeReference.getChoiceArchitecture] for genre-
/// appropriate choice philosophy, and require specific names and objects
/// in each option to feel grounded rather than generic.
class ChoiceGenerator extends AIAgent {
  ChoiceGenerator(super.provider);

  // ---------------------------------------------------------------------------
  // Public surface
  // ---------------------------------------------------------------------------

  /// Generates 2–4 choices for the player given the current [state] and the
  /// just-rendered [narrative] prose.
  ///
  /// Returns a list of choice strings. Falls back to two generic fallback
  /// choices if the AI response cannot be parsed.
  Future<List<String>> generateChoices(
      StoryState state, String narrative) async {
    final prompt = _buildPrompt(state, narrative);
    final response = await generate(prompt, maxTokens: 512);
    return _parseChoices(response);
  }

  // ---------------------------------------------------------------------------
  // Prompt builder
  // ---------------------------------------------------------------------------

  String _buildPrompt(StoryState state, String narrative) {
    final rules = GenreRules.getRules(state.genre);
    final tone = state.worldState['_tone'] as String? ?? 'epic';

    final buffer = StringBuffer();

    buffer.writeln(
        'You are a game master. Given the narrative below, generate 2–4 '
        'contextual player choices for a ${state.genre} story.');
    buffer.writeln();

    // --- Narrative context ---
    buffer.writeln('NARRATIVE SCENE');
    buffer.writeln(narrative);
    buffer.writeln();

    // --- Genre and tone ---
    buffer.writeln('GENRE: ${state.genre}');
    buffer.writeln('Tone: ${rules['tone']} (session tone: $tone)');
    buffer.writeln('Craft focus: ${rules['craft_focus']}');
    buffer.writeln();

    // --- Choice architecture from NarrativeReference ---
    buffer.writeln(NarrativeReference.getChoiceArchitecture(state.genre));

    // --- Universal requirement ---
    buffer.writeln('UNIVERSAL REQUIREMENTS FOR ALL CHOICES');
    buffer.writeln(
        '- Each choice must be a SPECIFIC ACTION — reference characters, '
        'objects, or locations by name. Never write "investigate the area" '
        'when you could write "examine the bloodstained map pinned above the '
        'fireplace."');
    buffer.writeln(
        '- Each choice must have a distinct risk and a distinct potential '
        'reward that the player can anticipate.');
    buffer.writeln('- 2–4 choices total. No more, no less.');
    buffer.writeln();

    // --- Mode-specific instructions ---
    if (state.mode == 'rpg') {
      _appendRpgChoiceInstructions(buffer, state);
    } else {
      _appendPureStoryChoiceInstructions(buffer);
    }

    // --- Output format ---
    buffer.writeln();
    buffer.writeln('OUTPUT FORMAT');
    buffer.writeln(
        'Return a JSON array of strings. Each string is one complete choice '
        'phrased in second person (e.g., "Draw your sword and challenge Lord '
        'Varen to a duel in the great hall.").');
    buffer.writeln('Example: ["Choice one.", "Choice two.", "Choice three."]');

    return buffer.toString();
  }

  // ---------------------------------------------------------------------------
  // Mode-specific choice instructions
  // ---------------------------------------------------------------------------

  void _appendRpgChoiceInstructions(StringBuffer buffer, StoryState state) {
    buffer.writeln('RPG ADVENTURE MODE — CHOICE REQUIREMENTS');
    buffer.writeln(
        '- At least one choice should involve a physical challenge '
        '(feats of strength, fast reflexes, endurance, combat).');
    buffer.writeln(
        '- At least one choice should involve a mental or social challenge '
        '(deduction, persuasion, perception, force of will, deception).');
    buffer.writeln(
        '- Choices should naturally suggest which type of ability they test '
        'without ever naming a stat or number explicitly. The narrative '
        'context should make the skill implication obvious.');

    if (state.rpgState != null) {
      final rpg = state.rpgState!;
      // Identify the character's strongest stats so choices feel tailored.
      final stats = {
        'strength': rpg.strength,
        'agility': rpg.agility,
        'intelligence': rpg.intelligence,
        'charisma': rpg.charisma,
        'perception': rpg.perception,
        'willpower': rpg.willpower,
      };
      final sorted = stats.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final topTwo = sorted.take(2).map((e) => e.key).join(' and ');
      buffer.writeln(
          '- The character\'s notable strengths are $topTwo — at least one '
          'choice should play to these strengths.');

      if (rpg.inventory.isNotEmpty) {
        buffer.writeln(
            '- Consider offering a choice that uses an item from the '
            'character\'s inventory: ${rpg.inventory.join(', ')}.');
      }
    }
  }

  void _appendPureStoryChoiceInstructions(StringBuffer buffer) {
    buffer.writeln('PURE STORY MODE — CHOICE REQUIREMENTS');
    buffer.writeln(
        '- Choices should test the character\'s VALUES, not their abilities. '
        'What kind of person are they going to be?');
    buffer.writeln(
        '- Include at least one choice that is emotionally risky — something '
        'that could permanently change a relationship, reveal a vulnerability, '
        'or force the character to act against their self-interest.');
    buffer.writeln(
        '- Avoid choices that are simply "fight" vs. "flee" — offer moral '
        'complexity: conflicting loyalties, competing goods, or situations '
        'where every option causes harm to someone.');
    buffer.writeln(
        '- No game-mechanical language. No references to stats, rolls, or '
        'skill checks under any circumstances.');
  }

  // ---------------------------------------------------------------------------
  // Response parsing
  // ---------------------------------------------------------------------------

  List<String> _parseChoices(String response) {
    // Attempt JSON array parse first.
    final parsed = AIJsonParser.parseList(response);
    if (parsed.isNotEmpty) {
      final choices =
          parsed.whereType<String>().where((s) => s.trim().isNotEmpty).toList();
      if (choices.isNotEmpty) return choices;
    }

    // Fallback: parse numbered or bulleted lines.
    final lines = response
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final extracted = <String>[];
    for (final line in lines) {
      // Match lines like "1. ...", "- ...", "* ...", or quoted "..."
      final cleaned = line
          .replaceFirst(RegExp(r'^[\d]+\.\s*'), '')
          .replaceFirst(RegExp(r'^[-*•]\s*'), '')
          .replaceAll(RegExp(r'^[""]|[""]$'), '')
          .trim();
      if (cleaned.length > 10) {
        extracted.add(cleaned);
      }
      if (extracted.length == 4) break;
    }

    if (extracted.isNotEmpty) return extracted;

    // Hard fallback.
    return [
      'Press forward and confront what lies ahead.',
      'Retreat and reconsider your approach.',
    ];
  }
}
