import 'package:riverpod/riverpod.dart';
import '../models/story_state.dart';
import '../models/scene.dart';
import '../models/rpg_state.dart';
import '../ai/ai_client.dart';

final storyProvider = StateNotifierProvider<StoryNotifier, StoryState>((ref) {
  return StoryNotifier(ref);
});

class StoryNotifier extends StateNotifier<StoryState> {
  final AIClient _aiClient = AIClient();
  final Ref _ref;

  StoryNotifier(this._ref) : super(StoryState.initial());

  Future<void> startNewStory(String genre, String mode, [Map<String, dynamic>? tasteProfile]) async {
    state = StoryState.initial().copyWith(
      genre: genre,
      mode: mode,
      rpgState: mode == 'rpg' ? RPGState.initial() : null,
    );
    await generateNextScene();
  }

  Future<void> makeChoice(String choice) async {
    state = state.copyWith(choices: [...state.choices, choice]);
    await generateNextScene();
  }

  Future<void> generateNextScene() async {
    final scene = await _aiClient.generateScene(state);
    state = state.copyWith(scenes: [...state.scenes, scene.narrative]);
    _ref.read(currentSceneProvider.notifier).setScene(scene);
  }

  void loadStory(StoryState loadedStory) {
    state = loadedStory;
    // Generate a new scene based on the loaded state
    generateNextScene();
  }
}