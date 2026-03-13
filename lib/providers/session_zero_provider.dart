import 'package:riverpod/riverpod.dart';
import '../models/session_zero.dart';
import 'story_provider.dart';

final sessionZeroProvider = StateNotifierProvider<SessionZeroNotifier, SessionZero>((ref) {
  return SessionZeroNotifier(ref);
});

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
    state = state.copyWith(genre: genre);
  }

  void updateTone(String tone) {
    state = state.copyWith(tone: tone);
  }

  void addFavoriteStory(String story) {
    state = state.copyWith(favoriteStories: [...state.favoriteStories, story]);
  }

  void toggleTwists() {
    state = state.copyWith(twistsEnabled: !state.twistsEnabled);
  }

  void complete() {
    // Start the story with the selected genre and mode
    _ref.read(storyProvider.notifier).startNewStory(state.genre, state.mode);
  }
}