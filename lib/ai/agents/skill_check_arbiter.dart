import 'dart:math';
import 'base_agent.dart';
import '../../models/story_state.dart';

class SkillCheckArbiter extends AIAgent {
  SkillCheckArbiter(super.provider);

  Future<SkillCheckResult> resolveCheck(String skill, int dc, StoryState state) async {
    // Simulate d20 roll
    final roll = Random().nextInt(20) + 1;
    final modifier = _getModifier(skill, state);
    final total = roll + modifier;
    final success = total >= dc;

    final flavor = await _generateFlavor(roll, modifier, dc, success, state);

    return SkillCheckResult(
      roll: roll,
      modifier: modifier,
      total: total,
      success: success,
      flavor: flavor,
    );
  }

  int _getModifier(String skill, StoryState state) {
    if (state.rpgState == null) return 0;
    final rpg = state.rpgState!;
    switch (skill.toLowerCase()) {
      case 'strength': return (rpg.strength - 10) ~/ 2;
      case 'agility': return (rpg.agility - 10) ~/ 2;
      case 'intelligence': return (rpg.intelligence - 10) ~/ 2;
      case 'charisma': return (rpg.charisma - 10) ~/ 2;
      case 'perception': return (rpg.perception - 10) ~/ 2;
      case 'willpower': return (rpg.willpower - 10) ~/ 2;
      default: return 0;
    }
  }

  Future<String> _generateFlavor(int roll, int modifier, int dc, bool success, StoryState state) async {
    final prompt = '''
Generate flavor text for a ${success ? 'successful' : 'failed'} skill check.

Roll: $roll + $modifier = ${roll + modifier} vs DC $dc
Skill: [skill name]
Genre: ${state.genre}

Write 1-2 sentences of narrative flavor.
''';
    return await generate(prompt);
  }
}

class SkillCheckResult {
  final int roll;
  final int modifier;
  final int total;
  final bool success;
  final String flavor;

  SkillCheckResult({
    required this.roll,
    required this.modifier,
    required this.total,
    required this.success,
    required this.flavor,
  });
}