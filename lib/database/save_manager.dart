import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/save_slot_meta.dart';
import '../models/story_state.dart';
import '../models/session_zero.dart';

/// Multi-slot save system.
///
/// Slot 0 = auto-save (written every 3 scenes).
/// Slots 1-4 = manual save slots.
class SaveManager {
  static const int maxSlots = 5;

  // ── Key helpers ──────────────────────────────────────────────────────

  static String _storyKey(int slot) => 'lf_save_${slot}_story';
  static String _configKey(int slot) => 'lf_save_${slot}_config';
  static String _metaKey(int slot) => 'lf_save_${slot}_meta';

  // ── Save ─────────────────────────────────────────────────────────────

  /// Save story and config to [slot].
  static Future<void> saveToSlot(
      int slot, StoryState state, SessionZero config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storyKey(slot), jsonEncode(state.toJson()));
    await prefs.setString(_configKey(slot), jsonEncode(config.toJson()));

    final meta = SaveSlotMeta(
      slot: slot,
      genre: state.genre,
      mode: state.mode,
      savedAt: DateTime.now(),
      sceneCount: state.scenes.length,
      summaryPreview: state.scenes.isNotEmpty
          ? (state.scenes.last.length > 80
              ? '${state.scenes.last.substring(0, 80)}...'
              : state.scenes.last)
          : '',
    );
    await prefs.setString(_metaKey(slot), jsonEncode(meta.toJson()));
  }

  /// Auto-save to slot 0.
  static Future<void> autoSave(StoryState state, SessionZero config) =>
      saveToSlot(0, state, config);

  // ── Load ─────────────────────────────────────────────────────────────

  /// Load story + config from [slot]. Returns null if empty.
  static Future<({StoryState story, SessionZero config})?> loadSlot(
      int slot) async {
    final prefs = await SharedPreferences.getInstance();
    final storyJson = prefs.getString(_storyKey(slot));
    final configJson = prefs.getString(_configKey(slot));
    if (storyJson == null) return null;

    final story =
        StoryState.fromJson(jsonDecode(storyJson) as Map<String, dynamic>);
    final config = configJson != null
        ? SessionZero.fromJson(
            jsonDecode(configJson) as Map<String, dynamic>)
        : SessionZero.initial();

    return (story: story, config: config);
  }

  // ── Delete ───────────────────────────────────────────────────────────

  /// Clear a single slot.
  static Future<void> deleteSlot(int slot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storyKey(slot));
    await prefs.remove(_configKey(slot));
    await prefs.remove(_metaKey(slot));
  }

  /// Clear all slots.
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < maxSlots; i++) {
      await prefs.remove(_storyKey(i));
      await prefs.remove(_configKey(i));
      await prefs.remove(_metaKey(i));
    }
  }

  // ── Metadata ─────────────────────────────────────────────────────────

  /// Get metadata for all slots. Null = empty slot.
  static Future<List<SaveSlotMeta?>> getSlotMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    final results = <SaveSlotMeta?>[];
    for (int i = 0; i < maxSlots; i++) {
      final metaJson = prefs.getString(_metaKey(i));
      if (metaJson != null) {
        results.add(SaveSlotMeta.fromJson(
            jsonDecode(metaJson) as Map<String, dynamic>));
      } else {
        results.add(null);
      }
    }
    return results;
  }

  /// Check if any save exists (for "Continue Adventure").
  static Future<bool> hasAnySave() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < maxSlots; i++) {
      if (prefs.getString(_storyKey(i)) != null) return true;
    }
    return false;
  }

  // ── Legacy compat ────────────────────────────────────────────────────

  /// Legacy: save to slot 0.
  static Future<void> saveStory(StoryState story) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storyKey(0), jsonEncode(story.toJson()));
  }

  /// Legacy: load from slot 0.
  static Future<StoryState?> loadStory() async {
    final result = await loadSlot(0);
    return result?.story;
  }

  /// Legacy: list of saved game labels.
  static Future<List<String>> getSavedGames() async {
    final metadata = await getSlotMetadata();
    return metadata
        .where((m) => m != null)
        .map((m) => 'Slot ${m!.slot}: ${m.genre} (${m.sceneCount} scenes)')
        .toList();
  }
}
