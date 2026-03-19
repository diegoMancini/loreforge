import 'dart:math';
import '../models/story_state.dart';
import '../models/genre_rules.dart';

/// Manages plot twist triggers based on pacing and genre rules.
///
/// All methods are static so callers do not need to hold an instance.
/// Twist metadata is stored inside [StoryState.worldState] under private
/// underscore-prefixed keys to avoid collisions with user-defined state.
class TwistEngine {
  TwistEngine._();

  static final _rng = Random();

  // WorldState keys used internally.
  static const _keyEnabled = '_twistsEnabled';
  static const _keyLastTwistScene = '_lastTwistScene';
  static const _keyTwistActive = '_twistActive';
  static const _keyTwistType = '_twistType';
  static const _keyTwistCount = '_twistCount';

  // ---------------------------------------------------------------------------
  // Trigger decision
  // ---------------------------------------------------------------------------

  /// Determines whether a twist should fire on the current scene.
  ///
  /// Rules (all must pass):
  /// 1. Twists not explicitly disabled via [_keyEnabled] = false.
  /// 2. At least 3 scenes have occurred (never twist on the opening).
  /// 3. At least 3 scenes have passed since the last twist.
  /// 4. A probabilistic gate: 15 % at 3 scenes since last, rising 8 pp per
  ///    additional scene, capped at 55 %.
  static bool shouldTriggerTwist(StoryState state) {
    final twistsEnabled = state.worldState[_keyEnabled] as bool? ?? true;
    if (!twistsEnabled) return false;

    final sceneCount = state.scenes.length;
    if (sceneCount < 3) return false; // never twist before scene 3

    final lastTwistScene = state.worldState[_keyLastTwistScene] as int? ?? 0;
    final scenesSinceLastTwist = sceneCount - lastTwistScene;

    if (scenesSinceLastTwist < 3) return false; // minimum 3 scenes between twists

    // Probability: 15 % at 3 scenes apart, +8 pp per additional scene, cap 55 %.
    final probability = (scenesSinceLastTwist * 0.08).clamp(0.15, 0.55);
    return _rng.nextDouble() < probability;
  }

  // ---------------------------------------------------------------------------
  // Twist type selection
  // ---------------------------------------------------------------------------

  /// Selects a twist type appropriate for [genre] by consulting [GenreRules].
  ///
  /// Falls back to 'unexpected revelation' if the genre has no twist_types
  /// configured.
  static String selectTwistType(String genre) {
    final rules = GenreRules.getRules(genre);
    final twistTypes = rules['twist_types'] as List<dynamic>? ?? ['unexpected revelation'];
    return twistTypes[_rng.nextInt(twistTypes.length)] as String;
  }

  // ---------------------------------------------------------------------------
  // Context builder
  // ---------------------------------------------------------------------------

  /// Builds the [StoryState.worldState] entries to inject when a twist fires.
  ///
  /// Callers are responsible for merging the returned map into the existing
  /// worldState (the map is returned rather than applied so the caller retains
  /// full control over state mutation).
  ///
  /// Keys written:
  /// - [_keyTwistActive]     : true
  /// - [_keyTwistType]       : the selected twist type string
  /// - [_keyLastTwistScene]  : current scene count (resets the cooldown timer)
  /// - [_keyTwistCount]      : previous count + 1
  static Map<String, dynamic> buildTwistContext(StoryState state) {
    final twistType = selectTwistType(state.genre);
    return {
      _keyTwistActive: true,
      _keyTwistType: twistType,
      _keyLastTwistScene: state.scenes.length,
      _keyTwistCount: ((state.worldState[_keyTwistCount] as int?) ?? 0) + 1,
    };
  }
}
