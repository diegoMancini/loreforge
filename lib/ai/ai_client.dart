import 'package:loreforge/ai/agents/story_architect.dart';
import 'package:loreforge/ai/agents/story_director.dart';
import 'package:loreforge/ai/agents/scene_writer.dart';
import 'package:loreforge/ai/agents/choice_generator.dart';
import 'package:loreforge/ai/agents/consistency_auditor.dart';
import 'package:loreforge/ai/agents/visual_director.dart';
import 'package:loreforge/ai/agents/world_state_manager.dart';
import 'package:loreforge/ai/providers/mock_provider.dart';
import 'package:loreforge/ai/providers/provider_router.dart';
import 'package:loreforge/ai/story_context_manager.dart';
import 'package:loreforge/models/scene.dart';
import 'package:loreforge/models/story_blueprint.dart';
import 'package:loreforge/models/story_state.dart';

/// Facade over all AI agents, backed by a [ProviderRouter] that routes
/// each task to the best available LLM provider.
///
/// Call [AIClient.initialize] once when starting a new adventure (after
/// the user has configured API keys). Use [AIClient.instance] everywhere
/// else. Falls back to [MockProvider] when no router is configured.
class AIClient {
  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  static AIClient? _current;

  /// Create a new [AIClient] wired to [router].
  ///
  /// Replaces any previously initialised instance.
  static void initialize(ProviderRouter router) {
    _current = AIClient._(router);
  }

  /// Returns the current instance.
  ///
  /// If [initialize] has not been called, creates a fallback instance with
  /// [MockProvider] so the app never crashes during development.
  static AIClient get instance {
    if (_current == null) {
      final fallback = ProviderRouter(
        {'mock': MockProvider()},
        preferred: 'mock',
      );
      _current = AIClient._(fallback);
    }
    return _current!;
  }

  /// Legacy factory constructor — returns [instance] for backwards compat.
  factory AIClient() => instance;

  AIClient._(ProviderRouter router)
      : _router = router,
        _storyArchitect =
            StoryArchitect(router.providerFor(AITask.blueprintGeneration)),
        _storyDirector =
            StoryDirector(router.providerFor(AITask.pacingAnalysis)),
        _sceneWriter =
            SceneWriter(router.providerFor(AITask.sceneWriting)),
        _choiceGenerator =
            ChoiceGenerator(router.providerFor(AITask.choiceGeneration)),
        _consistencyAuditor =
            ConsistencyAuditor(router.providerFor(AITask.consistencyCheck)),
        _visualDirector =
            VisualDirector(router.providerFor(AITask.visualDirection)),
        _worldStateManager =
            WorldStateManager(router.providerFor(AITask.worldStateUpdate)),
        _storyContextManager = StoryContextManager();

  // ---------------------------------------------------------------------------
  // Fields
  // ---------------------------------------------------------------------------

  // ignore: unused_field
  final ProviderRouter _router;
  final StoryArchitect _storyArchitect;
  final StoryDirector _storyDirector;
  final SceneWriter _sceneWriter;
  final ChoiceGenerator _choiceGenerator;
  final ConsistencyAuditor _consistencyAuditor;
  final VisualDirector _visualDirector;
  // ignore: unused_field
  final WorldStateManager _worldStateManager;
  final StoryContextManager _storyContextManager;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Generates a complete [StoryBlueprint] before gameplay begins.
  Future<StoryBlueprint> generateBlueprint(StoryState state) async {
    return _storyArchitect.generateBlueprint(state);
  }

  /// Extend the blueprint from [fromNodeId] with additional depth.
  Future<StoryBlueprint> extendBlueprint(
    StoryBlueprint current,
    String fromNodeId,
    StoryState state,
  ) async {
    return _storyArchitect.extendBlueprint(current, fromNodeId, state);
  }

  /// Generates a fully assembled [Scene] synchronously (non-streaming).
  Future<Scene> generateScene(StoryState state) async {
    final narrative = await _sceneWriter.writeScene(state);
    final choices = await _choiceGenerator.generateChoices(state, narrative);

    final isConsistent =
        await _consistencyAuditor.validateScene(state, narrative, choices);
    if (!isConsistent) {
      // Regenerate once on validation failure.
      final retryNarrative = await _sceneWriter.writeScene(state);
      final retryChoices =
          await _choiceGenerator.generateChoices(state, retryNarrative);
      final visualAssets =
          await _visualDirector.selectAssets(state, retryNarrative);
      return Scene(
        narrative: retryNarrative,
        choices: retryChoices,
        background: visualAssets.background,
        sprites: visualAssets.sprites,
      );
    }

    final visualAssets = await _visualDirector.selectAssets(state, narrative);
    return Scene(
      narrative: narrative,
      choices: choices,
      background: visualAssets.background,
      sprites: visualAssets.sprites,
    );
  }

  /// Returns a stream of narrative text tokens for the current scene.
  Future<Stream<String>> generateSceneStream(
    StoryState state, {
    BlueprintNode? blueprintNode,
    Map<String, dynamic>? directorGuidance,
  }) async {
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

  /// Generate player choices for an already-streamed narrative.
  Future<List<String>> generateChoicesOnly(
      StoryState state, String narrative) async {
    return _choiceGenerator.generateChoices(state, narrative);
  }

  /// Plan the next scene — returns a guidance map.
  Future<Map<String, dynamic>> planNextScene(StoryState state) async {
    return _storyDirector.planScene(state);
  }

  /// Builds an updated context summary for the story so far.
  Future<Map<String, dynamic>> summarizeScene(
    StoryState state,
    String narrative,
  ) async {
    return _storyContextManager.updateSummary(state, narrative);
  }
}
