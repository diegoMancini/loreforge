import 'package:flutter_test/flutter_test.dart';
import 'package:loreforge/game/rpg_engine.dart';
import 'package:loreforge/models/rpg_state.dart';

void main() {
  group('RPGEngine.getStatValue', () {
    final state = const RPGState(
      strength: 14,
      agility: 8,
      intelligence: 16,
      charisma: 12,
      perception: 10,
      willpower: 18,
      inventory: [],
      score: 0,
    );

    test('returns correct value for each stat', () {
      expect(RPGEngine.getStatValue(state, 'strength'), 14);
      expect(RPGEngine.getStatValue(state, 'agility'), 8);
      expect(RPGEngine.getStatValue(state, 'intelligence'), 16);
      expect(RPGEngine.getStatValue(state, 'charisma'), 12);
      expect(RPGEngine.getStatValue(state, 'perception'), 10);
      expect(RPGEngine.getStatValue(state, 'willpower'), 18);
    });

    test('returns 10 for unknown stat name', () {
      expect(RPGEngine.getStatValue(state, 'luck'), 10);
      expect(RPGEngine.getStatValue(state, ''), 10);
    });

    test('is case-insensitive', () {
      expect(RPGEngine.getStatValue(state, 'STRENGTH'), 14);
      expect(RPGEngine.getStatValue(state, 'Agility'), 8);
    });
  });

  group('RPGEngine.applyOutcome', () {
    final baseState = RPGState.initial();

    test('adds 10 score on success', () {
      final result = SkillCheckResult(
        roll: 15, modifier: 0, total: 15, dc: 10,
        success: true, stat: 'strength', statDelta: 0,
        narrative: 'Success.',
      );
      final updated = RPGEngine.applyOutcome(
        current: baseState, result: result, itemsGained: [],
      );
      expect(updated.score, 10);
    });

    test('subtracts 5 score on failure (min 0)', () {
      final result = SkillCheckResult(
        roll: 3, modifier: 0, total: 3, dc: 15,
        success: false, stat: 'strength', statDelta: 0,
        narrative: 'Failure.',
      );
      final updated = RPGEngine.applyOutcome(
        current: baseState, result: result, itemsGained: [],
      );
      expect(updated.score, 0); // clamped at 0
    });

    test('adds items to inventory on success', () {
      final result = SkillCheckResult(
        roll: 15, modifier: 0, total: 15, dc: 10,
        success: true, stat: 'strength', statDelta: 0,
        narrative: 'Success.',
      );
      final updated = RPGEngine.applyOutcome(
        current: baseState, result: result, itemsGained: ['Magic Sword'],
      );
      expect(updated.inventory, contains('Magic Sword'));
    });

    test('does not add items on failure', () {
      final result = SkillCheckResult(
        roll: 3, modifier: 0, total: 3, dc: 15,
        success: false, stat: 'strength', statDelta: 0,
        narrative: 'Failure.',
      );
      final updated = RPGEngine.applyOutcome(
        current: baseState, result: result, itemsGained: ['Magic Sword'],
      );
      expect(updated.inventory, isEmpty);
    });

    test('applies +1 stat delta on natural 20', () {
      final result = SkillCheckResult(
        roll: 20, modifier: 0, total: 20, dc: 10,
        success: true, stat: 'strength', statDelta: 1,
        narrative: 'Critical success!',
      );
      final updated = RPGEngine.applyOutcome(
        current: baseState, result: result, itemsGained: [],
      );
      expect(updated.strength, baseState.strength + 1);
    });

    test('applies -1 stat delta on natural 1', () {
      final result = SkillCheckResult(
        roll: 1, modifier: 0, total: 1, dc: 10,
        success: false, stat: 'agility', statDelta: -1,
        narrative: 'Critical failure!',
      );
      final updated = RPGEngine.applyOutcome(
        current: baseState, result: result, itemsGained: [],
      );
      expect(updated.agility, baseState.agility - 1);
    });
  });
}
