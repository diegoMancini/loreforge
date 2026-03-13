import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story_state.dart';
import '../models/session_zero.dart';

class SaveManager {
  static const String _storyKey = 'current_story';
  static const String _sessionZeroKey = 'session_zero';

  static Future<void> saveStory(StoryState story) async {
    final prefs = await SharedPreferences.getInstance();
    final storyJson = jsonEncode(story.toJson());
    await prefs.setString(_storyKey, storyJson);
  }

  static Future<StoryState?> loadStory() async {
    final prefs = await SharedPreferences.getInstance();
    final storyJson = prefs.getString(_storyKey);
    if (storyJson != null) {
      final storyMap = jsonDecode(storyJson) as Map<String, dynamic>;
      return StoryState.fromJson(storyMap);
    }
    return null;
  }

  static Future<void> saveSessionZero(SessionZero sessionZero) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = jsonEncode(sessionZero.toJson());
    await prefs.setString(_sessionZeroKey, sessionJson);
  }

  static Future<SessionZero?> loadSessionZero() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString(_sessionZeroKey);
    if (sessionJson != null) {
      final sessionMap = jsonDecode(sessionJson) as Map<String, dynamic>;
      return SessionZero.fromJson(sessionMap);
    }
    return null;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storyKey);
    await prefs.remove(_sessionZeroKey);
  }

  static Future<List<String>> getSavedGames() async {
    // For now, just return whether there's a saved game
    final story = await loadStory();
    return story != null ? ['Current Adventure'] : [];
  }
}