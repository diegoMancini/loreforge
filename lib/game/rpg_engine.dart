import 'dart:math';
import '../models/rpg_state.dart';

/// Lightweight RPG rules engine.
///
/// Handles d20-style skill checks, stat lookups, and outcome application.
/// All methods are static so callers do not need to hold an instance.
class RPGEngine {
  RPGEngine._();

  static final _rng = Random();

  // ---------------------------------------------------------------------------
  // Stat helpers
  // ---------------------------------------------------------------------------

  /// Returns the raw integer value of [stat] from [rpgState].
  ///
  /// Returns 10 (the neutral baseline) for unknown stat names.
  static int getStatValue(RPGState rpgState, String stat) {
    switch (stat.toLowerCase()) {
      case 'strength':
        return rpgState.strength;
      case 'agility':
        return rpgState.agility;
      case 'intelligence':
        return rpgState.intelligence;
      case 'charisma':
        return rpgState.charisma;
      case 'perception':
        return rpgState.perception;
      case 'willpower':
        return rpgState.willpower;
      default:
        return 10;
    }
  }

  // ---------------------------------------------------------------------------
  // Skill check
  // ---------------------------------------------------------------------------

  /// Performs a d20 skill check.
  ///
  /// The modifier is derived from [statValue] using the standard D&D formula:
  /// `(statValue - 10) ~/ 2`. The roll + modifier is compared against [dc].
  ///
  /// Returns a [SkillCheckResult] with narrative flavour text and an optional
  /// stat delta (+1 on natural 20, -1 on natural 1).
  static SkillCheckResult performCheck({
    required String stat,
    required int statValue,
    required int dc,
  }) {
    final roll = _rng.nextInt(20) + 1; // 1–20 inclusive
    final modifier = (statValue - 10) ~/ 2;
    final total = roll + modifier;
    final success = total >= dc;

    // Determine stat delta for critical hits/misses.
    int statDelta = 0;
    if (roll == 20) {
      statDelta = 1; // natural 20 — slight permanent improvement
    } else if (roll == 1) {
      statDelta = -1; // natural 1 — brief setback
    }

    final narrative = _buildNarrative(
      stat: stat,
      roll: roll,
      modifier: modifier,
      dc: dc,
      success: success,
    );

    return SkillCheckResult(
      roll: roll,
      modifier: modifier,
      total: total,
      dc: dc,
      success: success,
      stat: stat,
      statDelta: statDelta,
      narrative: narrative,
    );
  }

  // ---------------------------------------------------------------------------
  // Outcome application
  // ---------------------------------------------------------------------------

  /// Applies a [SkillCheckResult] to [current] RPG state.
  ///
  /// - [itemsGained]: items to add to inventory on success.
  /// - Stat deltas (nat 20 / nat 1) are applied with a floor of 1.
  /// - Score increases by 10 on success, decreases by 5 on failure (min 0).
  static RPGState applyOutcome({
    required RPGState current,
    required SkillCheckResult result,
    required List<String> itemsGained,
  }) {
    // Update inventory.
    final newInventory = result.success && itemsGained.isNotEmpty
        ? [...current.inventory, ...itemsGained]
        : List<String>.from(current.inventory);

    // Update score.
    final scoreDelta = result.success ? 10 : -5;
    final newScore = (current.score + scoreDelta).clamp(0, 9999);

    // Apply stat delta.
    RPGState updated = current.copyWith(
      inventory: newInventory,
      score: newScore,
    );

    if (result.statDelta != 0) {
      updated = _applyStatDelta(updated, result.stat, result.statDelta);
    }

    return updated;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static RPGState _applyStatDelta(RPGState state, String stat, int delta) {
    int clamp(int v) => (v + delta).clamp(1, 30);
    switch (stat.toLowerCase()) {
      case 'strength':
        return state.copyWith(strength: clamp(state.strength));
      case 'agility':
        return state.copyWith(agility: clamp(state.agility));
      case 'intelligence':
        return state.copyWith(intelligence: clamp(state.intelligence));
      case 'charisma':
        return state.copyWith(charisma: clamp(state.charisma));
      case 'perception':
        return state.copyWith(perception: clamp(state.perception));
      case 'willpower':
        return state.copyWith(willpower: clamp(state.willpower));
      default:
        return state;
    }
  }

  static String _buildNarrative({
    required String stat,
    required int roll,
    required int modifier,
    required int dc,
    required bool success,
  }) {
    final statName = stat[0].toUpperCase() + stat.substring(1);
    final modStr = modifier >= 0 ? '+$modifier' : '$modifier';

    if (roll == 20) {
      return '$statName check: $roll$modStr = ${roll + modifier} vs DC $dc — Critical success!';
    } else if (roll == 1) {
      return '$statName check: $roll$modStr = ${roll + modifier} vs DC $dc — Critical failure!';
    } else if (success) {
      return '$statName check: $roll$modStr = ${roll + modifier} vs DC $dc — Success.';
    } else {
      return '$statName check: $roll$modStr = ${roll + modifier} vs DC $dc — Failure.';
    }
  }
}

// ---------------------------------------------------------------------------
// Result model
// ---------------------------------------------------------------------------

/// Immutable result of an [RPGEngine.performCheck] call.
class SkillCheckResult {
  const SkillCheckResult({
    required this.roll,
    required this.modifier,
    required this.total,
    required this.dc,
    required this.success,
    required this.stat,
    required this.statDelta,
    required this.narrative,
  });

  /// The raw d20 roll (1–20).
  final int roll;

  /// The stat modifier applied to the roll.
  final int modifier;

  /// The final total (roll + modifier).
  final int total;

  /// The difficulty class the check was against.
  final int dc;

  /// Whether the check succeeded (total >= dc).
  final bool success;

  /// The stat that was checked (e.g. 'strength').
  final String stat;

  /// Permanent stat change: +1 on natural 20, -1 on natural 1, 0 otherwise.
  final int statDelta;

  /// Human-readable narrative summary of the check result.
  final String narrative;
}
