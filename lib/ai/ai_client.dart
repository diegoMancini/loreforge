import 'package:loreforge/ai/agents/story_architect.dart';
import 'package:loreforge/ai/agents/story_director.dart';
import 'package:loreforge/ai/agents/scene_writer.dart';
import 'package:loreforge/ai/agents/choice_generator.dart';
import 'package:loreforge/ai/agents/consistency_auditor.dart';
import 'package:loreforge/ai/agents/visual_director.dart';
import 'package:loreforge/ai/agents/world_state_manager.dart';
import 'package:loreforge/ai/providers/base_provider.dart';
import 'package:loreforge/ai/providers/mock_provider.dart';
import 'package:loreforge/ai/story_context_manager.dart';
import 'package:loreforge/models/scene.dart';
import 'package:loreforge/models/story_blueprint.dart';
import 'package:loreforge/models/story_state.dart';

/// Singleton facade over all AI agents and providers.
///
/// Using a singleton ensures that agent instances (and their internal state /
/// caches) are shared across the entire app lifetime rather than being
/// recreated on every call-site. Callers obtain the instance via the
/// [AIClient()] factory constructor.
class AIClient {
  // ---------------------------------------------------------------------------
  // Singleton plumbing
  // ---------------------------------------------------------------------------

  static AIClient? _instance;

  factory AIClient() {
    _instance ??= AIClient._internal();
    return _instance!;
  }

  AIClient._internal() {
    _provider = MockProvider();
    _storyArchitect = StoryArchitect(_provider);
    _storyDirector = StoryDirector(_provider);
    _sceneWriter = SceneWriter(_provider);
    _choiceGenerator = ChoiceGenerator(_provider);
    _consistencyAuditor = ConsistencyAuditor(_provider);
    _visualDirector = VisualDirector(_provider);
    _worldStateManager = WorldStateManager(_provider);
    _storyContextManager = StoryContextManager();
  }

  // ---------------------------------------------------------------------------
  // Fields
  // ---------------------------------------------------------------------------

  late final AIProvider _provider;
  late final StoryArchitect _storyArchitect;
  late final StoryDirector _storyDirector;
  late final SceneWriter _sceneWriter;
  late final ChoiceGenerator _choiceGenerator;
  late final ConsistencyAuditor _consistencyAuditor;
  late final VisualDirector _visualDirector;
  late final WorldStateManager _worldStateManager;
  late final StoryContextManager _storyContextManager;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Generates a complete [StoryBlueprint] before gameplay begins.
  ///
  /// The architect reads tone, language, and twist preferences from
  /// [state.worldState] (keys: `_tone`, `_language`, `_twistsEnabled`).
  Future<StoryBlueprint> generateBlueprint(StoryState state) async {
    return _storyArchitect.generateBlueprint(state);
  }

  /// Generates a fully assembled [Scene] synchronously (non-streaming).
  ///
  /// Runs the director → writer → choice-generator → auditor → visual pipeline.
  Future<Scene> generateScene(StoryState state) async {
    // Step 1: Story Director plans the scene
    await _storyDirector.planScene(state);

    // Step 2: Scene Writer generates narrative
    final narrative = await _sceneWriter.writeScene(state);

    // Step 3: Choice Generator creates options
    final choices = await _choiceGenerator.generateChoices(state, narrative);

    // Step 4: Consistency Auditor validates
    final isConsistent =
        await _consistencyAuditor.validateScene(state, narrative, choices);
    if (!isConsistent) {
      // TODO(ws2): implement retry / fallback in Workstream 2
    }

    // Step 5: Visual Director selects assets
    final visualAssets = await _visualDirector.selectAssets(state, narrative);

    return Scene(
      narrative: narrative,
      choices: choices,
      background: visualAssets.background,
      sprites: visualAssets.sprites,
    );
  }

  /// Returns a stream of narrative text tokens for the current scene.
  ///
  /// [blueprintNode] is optional — when provided its summary is injected into
  /// the state's worldState as `_currentBeat` so the SceneWriter prompt gains
  /// structural guidance without requiring a signature change on the agent.
  Future<Stream<String>> generateSceneStream(
    StoryState state, {
    BlueprintNode? blueprintNode,
  }) async {
    // Inject blueprint beat hint into a transient worldState copy
    final enrichedState = blueprintNode != null
        ? state.copyWith(
            worldState: {
              ...state.worldState,
              '_currentBeat': blueprintNode.summary,
              '_currentBeatType': blueprintNode.type,
            },
          )
        : state;

    return _sceneWriter.writeSceneStream(enrichedState);
  }

  /// Builds an updated context summary for the story so far.
  ///
  /// Delegates to [StoryContextManager.updateSummary] which returns a map
  /// containing `_summary`, `_recentScenes`, `_characters`, and `_threads`.
  /// Callers should merge this into [StoryState.worldState] via `copyWith`.
  Future<Map<String, dynamic>> summarizeScene(
    StoryState state,
    String narrative,
  ) async {
    return _storyContextManager.updateSummary(state, narrative);
  }
}
