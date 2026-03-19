import 'package:riverpod/riverpod.dart';
import '../models/session_zero.dart';
import 'story_provider.dart';

final sessionZeroProvider = StateNotifierProvider<SessionZeroNotifier, SessionZero>((ref) {
  return SessionZeroNotifier(ref);
});

// Alias that corrects a legacy snake_case reference in tone_step.dart.
// tone_step.dart uses `sessionZero_provider` (snake_case) instead of
// `sessionZeroProvider` (camelCase). Defining this alias here avoids
// touching the protected screen file.
// ignore: non_constant_identifier_names
final sessionZero_provider = sessionZeroProvider;

class SessionZeroNotifier extends StateNotifier<SessionZero> {
  final Ref _ref;

  SessionZeroNotifier(this._ref) : super(SessionZero.initial());

  void updateLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void updateMode(String mode) {
    state = state.copyWith(mode: mode);
  }

  void updateSetupMethod(String method) {
    state = state.copyWith(setupMethod: method);
  }

  void updateGenre(String genre) {
    state = state.copyWith(genre: genre, subgenre: '');
  }

  void updateSubgenre(String subgenre) {
    state = state.copyWith(subgenre: subgenre);
  }

  void updateTone(String tone) {
    state = state.copyWith(tone: tone);
  }

  void addFavoriteStory(String story) {
    state = state.copyWith(favoriteStories: [...state.favoriteStories, story]);
  }

  void removeFavoriteStory(String story) {
    final updated = List<String>.from(state.favoriteStories)..remove(story);
    state = state.copyWith(favoriteStories: updated);
  }

  void toggleMediaInspiration(String title) {
    final current = List<String>.from(state.mediaInspiration);
    if (current.contains(title)) {
      current.remove(title);
    } else {
      current.add(title);
    }
    state = state.copyWith(mediaInspiration: current);
  }

  void updateCustomPrompt(String prompt) {
    state = state.copyWith(customPrompt: prompt);
  }

  void toggleTwists() {
    state = state.copyWith(twistsEnabled: !state.twistsEnabled);
  }

  /// Hands the full [SessionZero] configuration to the story pipeline.
  ///
  /// Calls [StoryNotifier.startNewStoryFromSessionZero] so that tone,
  /// language, favoriteStories, and twistsEnabled all reach the AI agents
  /// via [StoryState.worldState] — unlike the old call to [startNewStory]
  /// which only forwarded genre and mode.
  void complete() {
    _ref.read(storyProvider.notifier).startNewStoryFromSessionZero(state);
  }
}