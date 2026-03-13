import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loreforge/ai/providers/base_provider.dart';
import 'package:loreforge/ai/providers/mock_provider.dart';
import 'package:loreforge/ai/agents/story_director.dart';
import 'package:loreforge/ai/agents/scene_writer.dart';
import 'package:loreforge/ai/agents/choice_generator.dart';
import 'package:loreforge/ai/agents/consistency_auditor.dart';
import 'package:loreforge/ai/agents/visual_director.dart';
import 'package:loreforge/ai/agents/world_state_manager.dart';
import 'package:loreforge/models/scene.dart';
import 'package:loreforge/models/story_state.dart';

class AIClient {
  late final AIProvider _provider;
  late final StoryDirector _storyDirector;
  late final SceneWriter _sceneWriter;
  late final ChoiceGenerator _choiceGenerator;
  late final ConsistencyAuditor _consistencyAuditor;
  late final VisualDirector _visualDirector;
  late final WorldStateManager _worldStateManager;

  AIClient() {
    _provider = MockProvider();
    _storyDirector = StoryDirector(_provider);
    _sceneWriter = SceneWriter(_provider);
    _choiceGenerator = ChoiceGenerator(_provider);
    _consistencyAuditor = ConsistencyAuditor(_provider);
    _visualDirector = VisualDirector(_provider);
    _worldStateManager = WorldStateManager(_provider);
  }

  Future<Scene> generateScene(StoryState state) async {
    // Step 1: Story Director plans the scene
    await _storyDirector.planScene(state);

    // Step 2: Scene Writer generates narrative
    final narrative = await _sceneWriter.writeScene(state);

    // Step 3: Choice Generator creates options
    final choices = await _choiceGenerator.generateChoices(state, narrative);

    // Step 4: Consistency Auditor validates
    final isConsistent = await _consistencyAuditor.validateScene(state, narrative, choices);
    if (!isConsistent) {
      // Retry or handle inconsistency
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

  Future<Stream<String>> generateSceneStream(StoryState state) async {
    // For streaming, stream the narrative
    return _sceneWriter.writeSceneStream(state);
  }
}