import 'dart:math';
import '../models/rpg_state.dart';

/// Lightweight RPG rules engine.
///
/// Handles d20-style skill checks, stat lookups, outcome application,
/// smart stat inference, and dynamic DC scaling.
/// All methods are static so callers do not need to hold an instance.
class RPGEngine {
  RPGEngine._();

  static final _rng = Random();

  // ---------------------------------------------------------------------------
  // Stat inference
  // ---------------------------------------------------------------------------

  /// Infers which stat a choice tests based on keyword analysis of the choice
  /// text and the surrounding narrative context.
  ///
  /// Keyword groups (case-insensitive, matched against the concatenation of
  /// [choiceText] and [narrative]):
  /// - strength    : fight, attack, climb, break, lift, slam, push, force
  /// - agility     : dodge, sneak, balance, tumble, sprint, leap, duck, hide
  /// - intelligence: puzzle, decipher, analyze, study, research, examine, read, solve
  /// - charisma    : persuade, negotiate, charm, bluff, lie, intimidate, seduce, flatter
  /// - perception  : search, listen, notice, spot, watch, sense, detect, observe
  /// - willpower   : resist, endure, confront, withstand, focus, meditate, will
  ///
  /// Falls back to a weighted random selection if no keyword matches.
  static String inferStatForChoice(String choiceText, String narrative) {
    final combined = '${choiceText.toLowerCase()} ${narrative.toLowerCase()}';

    // Each entry: stat name → list of trigger keywords.
    const keywordMap = <String, List<String>>{
      'strength':     ['fight', 'attack', 'climb', 'break', 'lift', 'slam', 'push', 'force'],
      'agility':      ['dodge', 'sneak', 'balance', 'tumble', 'sprint', 'leap', 'duck', 'hide'],
      'intelligence': ['puzzle', 'decipher', 'analyze', 'study', 'research', 'examine', 'read', 'solve'],
      'charisma':     ['persuade', 'negotiate', 'charm', 'bluff', 'lie', 'intimidate', 'seduce', 'flatter'],
      'perception':   ['search', 'listen', 'notice', 'spot', 'watch', 'sense', 'detect', 'observe'],
      'willpower':    ['resist', 'endure', 'confront', 'withstand', 'focus', 'meditate', 'will'],
    };

    // Track match counts per stat so the strongest signal wins.
    final scores = <String, int>{};
    for (final entry in keywordMap.entries) {
      int count = 0;
      for (final kw in entry.value) {
        // Use word-boundary-style matching: check for the keyword as a
        // substring to keep it simple and allocation-free.
        if (combined.contains(kw)) count++;
      }
      if (count > 0) scores[entry.key] = count;
    }

    if (scores.isNotEmpty) {
      // Return the stat with the highest keyword hit count.
      return scores.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    }

    // No keyword matched — fall back to a weighted random selection.
    // Weights reflect how commonly each stat appears in generic narrative.
    const weighted = [
      'strength',     'strength',
      'agility',      'agility',
      'intelligence', 'intelligence',
      'charisma',     'charisma',
      'perception',   'perception',
      'willpower',
    ];
    return weighted[_rng.nextInt(weighted.length)];
  }

  // ---------------------------------------------------------------------------
  // Dynamic DC scaling
  // ---------------------------------------------------------------------------

  /// Calculates a difficulty class that grows with story progression.
  ///
  /// Base DC is 10. Each 3 scenes completed adds +1. Node-type bonuses:
  /// - 'twist'      : +2
  /// - 'climax'     : +3
  /// - 'resolution' : +1
  ///
  /// Result is clamped to [8, 20].
  static int scaleDC(int sceneNumber, {String? nodeType}) {
    int dc = 10;
    dc += (sceneNumber ~/ 3); // +1 per 3 scenes completed

    switch (nodeType) {
      case 'twist':
        dc += 2;
        break;
      case 'climax':
        dc += 3;
        break;
      case 'resolution':
        dc += 1;
        break;
    }

    return dc.clamp(8, 20);
  }

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
  /// Score deltas:
  /// - Critical success (roll == 20) : +25
  /// - Normal success                : +10
  /// - Normal failure                : -5
  /// - Critical failure  (roll == 1) : -10
  ///
  /// Stat deltas (already set in [SkillCheckResult] by [performCheck]):
  /// - roll == 20 → statDelta +1 (applied regardless)
  /// - roll == 1  → statDelta -1 (applied regardless)
  ///
  /// Items in [itemsGained] are added to inventory on any success (normal or
  /// critical).
  static RPGState applyOutcome({
    required RPGState current,
    required SkillCheckResult result,
    required List<String> itemsGained,
  }) {
    // Inventory: grant items on any success.
    final newInventory = result.success && itemsGained.isNotEmpty
        ? [...current.inventory, ...itemsGained]
        : List<String>.from(current.inventory);

    // Score delta depends on whether the roll was a critical.
    final int scoreDelta;
    if (result.roll == 20) {
      scoreDelta = 25; // critical success
    } else if (result.roll == 1) {
      scoreDelta = -10; // critical failure
    } else if (result.success) {
      scoreDelta = 10; // normal success
    } else {
      scoreDelta = -5; // normal failure
    }

    final newScore = (current.score + scoreDelta).clamp(0, 9999);

    // Apply score and inventory first.
    RPGState updated = current.copyWith(
      inventory: newInventory,
      score: newScore,
    );

    // Apply permanent stat delta (nat 20 / nat 1 always carry a stat change).
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
