import 'package:riverpod/riverpod.dart';

// Re-export AIClient so screens that import story_provider.dart can use
// AIClient() without an additional explicit import. This is needed because
// gameplay_screen.dart uses AIClient() but does not import ai_client.dart
// directly, and gameplay_screen.dart is in a protected directory.
export '../ai/ai_client.dart' show AIClient;

import '../models/story_state.dart';
import '../models/story_blueprint.dart';
import '../models/rpg_state.dart';
import '../models/session_zero.dart';
import '../ai/ai_client.dart';
import 'scene_provider.dart';

final storyProvider = StateNotifierProvider<StoryNotifier, StoryState>((ref) {
  return StoryNotifier(ref);
});

class StoryNotifier extends StateNotifier<StoryState> {
  // Singleton — same instance is returned every time AIClient() is called.
  final AIClient _aiClient = AIClient();
  final Ref _ref;

  StoryNotifier(this._ref) : super(StoryState.initial());

  // ---------------------------------------------------------------------------
  // Story initialisation
  // ---------------------------------------------------------------------------

  /// Legacy initialiser — kept for backward compatibility with existing tests.
  ///
  /// Prefer [startNewStoryFromSessionZero] for new call-sites; this method
  /// does not populate tone/language/twists worldState keys and does not
  /// generate a blueprint.
  Future<void> startNewStory(
    String genre,
    String mode, [
    Map<String, dynamic>? tasteProfile,
  ]) async {
    state = StoryState.initial().copyWith(
      genre: genre,
      mode: mode,
      rpgState: mode == 'rpg' ? RPGState.initial() : null,
    );
    await generateNextScene();
  }

  /// Full initialiser that wires all [SessionZero] fields into the story.
  ///
  /// Workflow:
  /// 1. Build a [StoryState] with all config fields stored in [worldState] so
  ///    AI agents can read them via standard worldState lookups.
  /// 2. Ask the [StoryArchitect] to generate a [StoryBlueprint] and store it
  ///    on the state.
  /// 3. Return without generating a scene — [GameplayScreen._startStreaming]
  ///    owns the first scene generation step.
  Future<void> startNewStoryFromSessionZero(SessionZero config) async {
    // Build the initial world-state with all session-zero config keys
    final worldState = <String, dynamic>{
      '_tone': config.tone,
      '_language': config.language,
      '_twistsEnabled': config.twistsEnabled,
      '_favoriteStories': config.favoriteStories,
    };

    state = StoryState.initial().copyWith(
      genre: config.genre,
      mode: config.mode,
      rpgState: config.mode == 'rpg' ? RPGState.initial() : null,
      worldState: worldState,
    );

    // Generate the structural blueprint; store its premise back into worldState
    // so SceneWriter and StoryDirector can access it via worldState['_storyPremise'].
    final blueprint = await _aiClient.generateBlueprint(state);

    state = state.copyWith(
      worldState: {
        ...state.worldState,
        '_storyPremise': blueprint.premise,
        '_blueprintNodeCount': blueprint.nodes.length,
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Gameplay actions
  // ---------------------------------------------------------------------------

  Future<void> makeChoice(String choice) async {
    state = state.copyWith(choices: [...state.choices, choice]);
    await generateNextScene();
  }

  Future<void> generateNextScene() async {
    final scene = await _aiClient.generateScene(state);
    state = state.copyWith(scenes: [...state.scenes, scene.narrative]);
    _ref.read(currentSceneProvider.notifier).setScene(scene);

    // Update rolling context summary after every scene
    final contextUpdate =
        await _aiClient.summarizeScene(state, scene.narrative);
    state = state.copyWith(
      worldState: {
        ...state.worldState,
        ...contextUpdate,
      },
    );
  }

  void loadStory(StoryState loadedStory) {
    state = loadedStory;
  }

  /// Append a player choice to history.
  void recordChoice(String choice) {
    state = state.copyWith(choices: [...state.choices, choice]);
  }

  /// Append a scene narrative, capped at 50 entries.
  void addScene(String narrative) {
    final scenes = [...state.scenes, narrative];
    if (scenes.length > 50) {
      state = state.copyWith(scenes: scenes.sublist(scenes.length - 50));
    } else {
      state = state.copyWith(scenes: scenes);
    }
  }

  /// Advance the blueprint's currentNodeId based on the chosen text.
  void advanceBlueprint(String choiceText) {
    final bp = state.blueprint;
    if (bp == null) return;

    // Blueprint node advancement — find the next node in sequence
    final currentNodes = bp.nodes;
    if (currentNodes.isEmpty) return;

    // Find the node currently being rendered (lowest order not yet completed)
    // and advance to the next node in the sequence
    final worldState = state.worldState;
    final currentOrder = worldState['_currentBlueprintOrder'] as int? ?? 0;
    final nextOrder = currentOrder + 1;

    if (nextOrder < currentNodes.length) {
      state = state.copyWith(
        worldState: {
          ...worldState,
          '_currentBlueprintOrder': nextOrder,
          '_currentBeat': currentNodes[nextOrder].summary,
          '_currentBeatType': currentNodes[nextOrder].type,
        },
      );
    }
  }

  /// Update rolling story summary context.
  void updateSummary({
    required String summary,
    required List<String> characters,
    required List<String> threads,
  }) {
    state = state.copyWith(
      storySummary: summary,
      activeCharacters: characters,
      activeThreads: threads,
    );
  }

  /// Apply an RPG outcome (updated stats, inventory, score).
  void applyRpgOutcome(RPGState updatedRpg) {
    state = state.copyWith(rpgState: updatedRpg);
  }

  /// Add an item to RPG inventory.
  void addInventoryItem(String item) {
    final rpg = state.rpgState;
    if (rpg == null) return;
    state = state.copyWith(
      rpgState: rpg.copyWith(inventory: [...rpg.inventory, item]),
    );
  }

  /// Remove an item from RPG inventory.
  void removeInventoryItem(String item) {
    final rpg = state.rpgState;
    if (rpg == null) return;
    final updated = List<String>.from(rpg.inventory)..remove(item);
    state = state.copyWith(
      rpgState: rpg.copyWith(inventory: updated),
    );
  }
}
