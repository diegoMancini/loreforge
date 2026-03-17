import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/scene_provider.dart';
import '../providers/story_provider.dart';
import '../audio/audio_manager.dart';
import '../database/save_manager.dart';
import '../models/scene.dart';
import '../models/story_blueprint.dart';
import '../models/story_state.dart';
import '../theme/loreforge_theme.dart';
import '../theme/genre_theme.dart' show GenreTheme;
import '../widgets/atmosphere_background.dart';
import '../game/rpg_engine.dart';
import 'character_sheet_overlay.dart';
import 'inventory_overlay.dart';
import 'story_log_overlay.dart';
import 'pause_menu_overlay.dart';
import '../providers/settings_provider.dart';

/// Strip markdown formatting (bold, italic, headers) from AI output.
String _stripMarkdown(String text) {
  return text
      .replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (m) => m[1]!) // **bold**
      .replaceAllMapped(RegExp(r'\*(.+?)\*'), (m) => m[1]!) // *italic*
      .replaceAllMapped(RegExp(r'_(.+?)_'), (m) => m[1]!) // _italic_
      .replaceAll(RegExp(r'^#{1,6}\s+', multiLine: true), '') // # headers
      .replaceAllMapped(RegExp(r'`(.+?)`'), (m) => m[1]!); // `code`
}

// ---------------------------------------------------------------------------
// Genre-specific UI text
// ---------------------------------------------------------------------------

String _genreLoadingMessage(String genre) {
  switch (genre.toLowerCase()) {
    case 'fantasy':
      return 'The ancient tome turns its pages...';
    case 'sci-fi':
    case 'scifi':
      return 'Scanning quantum possibilities...';
    case 'horror':
      return 'Something stirs in the darkness...';
    case 'mystery':
      return 'Gathering the clues...';
    case 'romance':
      return 'Hearts entwine across the page...';
    case 'thriller':
      return 'The clock is ticking...';
    case 'historical fiction':
      return 'The chronicles unfold...';
    case 'mythology':
      return 'The gods deliberate your fate...';
    default:
      return 'Weaving the threads of your story...';
  }
}

String _genreChoicePrompt(String genre) {
  switch (genre.toLowerCase()) {
    case 'fantasy':
      return 'What path will you choose?';
    case 'sci-fi':
    case 'scifi':
      return 'How do you proceed?';
    case 'horror':
      return 'What do you dare to do?';
    case 'mystery':
      return "What's your next move?";
    case 'romance':
      return 'What does your heart tell you?';
    case 'thriller':
      return 'Time is running out...';
    case 'historical fiction':
      return 'What course of action do you take?';
    case 'mythology':
      return 'What is your decree?';
    default:
      return 'What do you do?';
  }
}

String _genreChoiceAcknowledgment(String genre) {
  switch (genre.toLowerCase()) {
    case 'fantasy':
      return 'Fate weaves your choice into the tapestry...';
    case 'sci-fi':
    case 'scifi':
      return 'Timeline adjusted. Consequences propagating...';
    case 'horror':
      return 'The shadows note your decision...';
    case 'mystery':
      return 'Another piece of the puzzle falls into place...';
    case 'romance':
      return 'Your heart has spoken...';
    case 'thriller':
      return 'No turning back now...';
    case 'historical fiction':
      return 'History will remember this moment...';
    case 'mythology':
      return 'The Fates take notice...';
    default:
      return 'Your choice echoes forward...';
  }
}

// ---------------------------------------------------------------------------
// GameplayScreen
// ---------------------------------------------------------------------------

class GameplayScreen extends ConsumerStatefulWidget {
  const GameplayScreen({super.key});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String _displayedText = '';
  bool _isStreaming = false;
  bool _isLoadingChoices = false;
  String? _errorMessage;
  StreamSubscription<String>? _streamSub;
  late final AnimationController _dotController;
  String _currentMood = 'calm';
  final Set<String> _extendingNodeIds = {};
  SkillCheckResult? _lastSkillCheck;
  bool _showSkillCheck = false;
  bool _isTransitioning = false;
  bool _showPauseMenu = false;
  String? _choiceAcknowledgment;
  late final AnimationController _choiceAnimController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _choiceAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _initializeAudio();
    _startStreaming();
  }

  Future<void> _initializeAudio() async {
    await AudioManager().initialize();
    final storyState = ref.read(storyProvider);
    await AudioManager().playBackgroundMusic(storyState.genre);
  }

  void _startStreaming() async {
    await _streamSub?.cancel();
    _streamSub = null;

    if (!mounted) return;
    setState(() {
      _isStreaming = true;
      _isLoadingChoices = false;
      _displayedText = '';
      _errorMessage = null;
    });

    ref.read(currentSceneProvider.notifier).clearScene();

    final storyState = ref.read(storyProvider);
    final blueprint = storyState.blueprint;

    BlueprintNode? blueprintNode;
    if (blueprint != null && blueprint.nodes.isNotEmpty) {
      final currentOrder =
          storyState.worldState['_currentBlueprintOrder'] as int? ?? 0;
      final candidates =
          blueprint.nodes.where((n) => n.order == currentOrder).toList();
      blueprintNode = candidates.isNotEmpty ? candidates.first : null;
      blueprintNode ??= blueprint.nodes.first;
    }

    if (blueprintNode != null) {
      await _streamWithBlueprint(storyState, blueprint!, blueprintNode);
    } else {
      await _streamWithFallback(storyState);
    }
  }

  Future<void> _streamWithBlueprint(
    StoryState storyState,
    StoryBlueprint blueprint,
    BlueprintNode node,
  ) async {
    try {
      if (mounted) {
        final derivedMood = switch (node.type) {
          'twist' || 'climax' => 'tense',
          'resolution' || 'beat' => 'calm',
          _ => 'mysterious',
        };
        setState(() => _currentMood = derivedMood);

        await AudioManager().playBackgroundMusic(storyState.genre);
      }

      final stream = await AIClient().generateSceneStream(
        storyState,
        blueprintNode: node,
      );

      _streamSub = stream.listen(
        (chunk) {
          if (!mounted) return;
          setState(() => _displayedText += chunk);
          _autoScroll();
        },
        onDone: () async {
          if (!mounted) return;

          final narrative = _displayedText.trim();
          setState(() {
            _isStreaming = false;
            _isLoadingChoices = true;
          });

          ref.read(storyProvider.notifier).addScene(narrative);
          _updateStorySummary(storyState, narrative);

          List<String> choices;
          try {
            choices =
                await AIClient().generateChoicesOnly(storyState, narrative);
          } catch (e) {
            if (mounted) {
              setState(() {
                _isLoadingChoices = false;
                _errorMessage = 'Could not generate choices: $e';
              });
            }
            return;
          }
          if (!mounted) return;
          setState(() => _isLoadingChoices = false);

          final scene = Scene(narrative: narrative, choices: choices);
          ref.read(currentSceneProvider.notifier).setScene(scene);
          _triggerChoiceAnimation();
          _maybeExtendBlueprint(storyState, node);
        },
        onError: (error) {
          if (!mounted) return;
          setState(() {
            _isStreaming = false;
            _errorMessage = 'Error generating story: $error';
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isStreaming = false;
        _errorMessage = 'Failed to start story generation: $e';
      });
    }
  }

  Future<void> _streamWithFallback(StoryState storyState) async {
    try {
      Map<String, dynamic>? directorGuidance;
      if (storyState.scenes.isNotEmpty) {
        try {
          directorGuidance = await AIClient().planNextScene(storyState);

          if (mounted) {
            final tension =
                directorGuidance['tension'] as String? ?? 'medium';
            setState(() {
              _currentMood = switch (tension) {
                'low' => 'calm',
                'high' => 'tense',
                _ => 'mysterious',
              };
            });
            await AudioManager().playBackgroundMusic(storyState.genre);
          }
        } catch (_) {}
      }

      final stream = await AIClient().generateSceneStream(
        storyState,
        directorGuidance: directorGuidance,
      );

      _streamSub = stream.listen(
        (chunk) {
          if (!mounted) return;
          setState(() => _displayedText += chunk);
          _autoScroll();
        },
        onDone: () async {
          if (!mounted) return;

          final narrative = _displayedText.trim();
          setState(() {
            _isStreaming = false;
            _isLoadingChoices = true;
          });

          ref.read(storyProvider.notifier).addScene(narrative);
          _updateStorySummary(storyState, narrative);

          try {
            final choices =
                await AIClient().generateChoicesOnly(storyState, narrative);

            if (mounted) {
              final scene = Scene(narrative: narrative, choices: choices);
              ref.read(currentSceneProvider.notifier).setScene(scene);
              setState(() => _isLoadingChoices = false);
              _triggerChoiceAnimation();
            }
          } catch (e) {
            if (mounted) {
              setState(() {
                _isLoadingChoices = false;
                _errorMessage = 'Could not load choices: $e';
              });
            }
          }
        },
        onError: (error) {
          if (!mounted) return;
          setState(() {
            _isStreaming = false;
            _errorMessage = 'Error generating story: $error';
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isStreaming = false;
        _errorMessage = 'Failed to start story generation: $e';
      });
    }
  }

  Future<void> _handleChoice(String choice, int choiceIndex) async {
    await AudioManager().playSoundEffect('audio/sfx_choice.mp3');
    final storyState = ref.read(storyProvider);
    final notifier = ref.read(storyProvider.notifier);

    // Genre-themed choice acknowledgment (Telltale-style)
    if (mounted) {
      setState(() =>
          _choiceAcknowledgment = _genreChoiceAcknowledgment(storyState.genre));
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _choiceAcknowledgment = null);
      });
    }

    // RPG mode: run a generic skill check
    if (storyState.mode == 'rpg' && storyState.rpgState != null) {
      const defaultStat = 'strength';
      final statValue =
          RPGEngine.getStatValue(storyState.rpgState!, defaultStat);
      final result = RPGEngine.performCheck(
        stat: defaultStat,
        statValue: statValue,
        dc: 13,
      );

      final updatedRpg = RPGEngine.applyOutcome(
        current: storyState.rpgState!,
        result: result,
        itemsGained: [],
      );
      notifier.applyRpgOutcome(updatedRpg);

      if (mounted) {
        setState(() {
          _lastSkillCheck = result;
          _showSkillCheck = true;
        });
        await Future.delayed(const Duration(milliseconds: 1200));
        if (mounted) setState(() => _showSkillCheck = false);
      }
    }

    if (mounted) {
      setState(() => _isTransitioning = true);
      await Future.delayed(const Duration(milliseconds: 300));
    }

    notifier.recordChoice(choice);
    notifier.advanceBlueprint(choice);

    if (mounted) setState(() => _isTransitioning = false);
    _startStreaming();
  }

  void _updateStorySummary(StoryState storyState, String narrative) {
    AIClient().summarizeScene(storyState, narrative).then((result) {
      if (mounted) {
        ref.read(storyProvider.notifier).updateSummary(
              summary: result['summary'] as String? ?? '',
              characters: (result['characters'] as List<dynamic>?)
                      ?.cast<String>() ??
                  [],
              threads:
                  (result['threads'] as List<dynamic>?)?.cast<String>() ?? [],
            );
      }
    }).catchError((_) {});
  }

  void _maybeExtendBlueprint(
      StoryState storyState, BlueprintNode currentNode) {
    final blueprint = storyState.blueprint;
    if (blueprint == null) return;

    final nodeKey = currentNode.order.toString();
    if (_extendingNodeIds.contains(nodeKey)) return;

    final currentOrder =
        storyState.worldState['_currentBlueprintOrder'] as int? ?? 0;
    final remaining = blueprint.nodes.length - currentOrder;

    if (remaining <= 2) {
      _extendingNodeIds.add(nodeKey);
      AIClient()
          .extendBlueprint(blueprint, nodeKey, storyState)
          .then((extended) {
        if (mounted) {
          final existingOrders = blueprint.nodes.map((n) => n.order).toSet();
          final newNodes = extended.nodes
              .where((n) => !existingOrders.contains(n.order))
              .toList();
          if (newNodes.isNotEmpty) {
            final merged = StoryBlueprint(
              premise: blueprint.premise,
              tone: blueprint.tone,
              language: blueprint.language,
              nodes: [...blueprint.nodes, ...newNodes],
              metadata: blueprint.metadata,
            );
            final current = ref.read(storyProvider);
            ref
                .read(storyProvider.notifier)
                .loadStory(current.copyWith(blueprint: merged));
          }
        }
      }).whenComplete(() {
        _extendingNodeIds.remove(nodeKey);
      });
    }
  }

  void _triggerChoiceAnimation() {
    if (!mounted) return;
    _choiceAnimController.reset();
    _choiceAnimController.forward();
  }

  void _autoScroll() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 60),
        curve: Curves.easeOut,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final storyState = ref.watch(storyProvider);
    final currentScene = ref.watch(currentSceneProvider);
    final accent = GenreTheme.accentColor(storyState.genre);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: LoreforgeColors.background,
      body: Stack(
        children: [
          AtmosphereBackground(
            genre: storyState.genre,
            mood: _currentMood,
            child: const SizedBox.expand(),
          ),
          if (_isTransitioning)
            AnimatedOpacity(
              opacity: _isTransitioning ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(color: LoreforgeColors.background),
            ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context, storyState, accent),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: LoreforgeColors.surface.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: GenreTheme.borderColor(storyState.genre),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_displayedText.isNotEmpty)
                              AnimatedOpacity(
                                opacity: 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  _stripMarkdown(_displayedText),
                                  style: TextStyle(
                                    fontSize: settings.textSize,
                                    height: 1.6,
                                    color: LoreforgeColors.textPrimary,
                                    fontFamily: 'Lora',
                                  ),
                                ),
                              ),
                            if (_isStreaming)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: _buildCursor(accent),
                              ),
                            if (_displayedText.isEmpty && !_isStreaming)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Text(
                                    'Your adventure begins...',
                                    style: TextStyle(
                                      color: LoreforgeColors.textMuted,
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: LoreforgeColors.errorBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: LoreforgeColors.errorBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: LoreforgeColors.error, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                  color: LoreforgeColors.errorLight,
                                  fontSize: 13),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _startStreaming,
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Retry'),
                            style: TextButton.styleFrom(
                                foregroundColor: LoreforgeColors.error),
                          ),
                        ],
                      ),
                    ),
                  ),
                if ((_isStreaming && _displayedText.isEmpty) ||
                    _isLoadingChoices)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(accent),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _isLoadingChoices
                              ? 'Preparing your choices...'
                              : _genreLoadingMessage(storyState.genre),
                          style: TextStyle(
                            color: accent.withValues(alpha: 0.8),
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!_isStreaming &&
                    !_isLoadingChoices &&
                    currentScene != null &&
                    _errorMessage == null)
                  Flexible(
                    child: SingleChildScrollView(
                      child: _buildChoices(
                          currentScene.choices, storyState, accent),
                    ),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ),
          if (_showSkillCheck && _lastSkillCheck != null)
            _buildSkillCheckOverlay(accent),
          if (_choiceAcknowledgment != null)
            _buildChoiceAcknowledgmentOverlay(accent),
          if (_showPauseMenu)
            PauseMenuOverlay(
              onResume: () => setState(() => _showPauseMenu = false),
              onSave: _saveGame,
              onMainMenu: () {
                setState(() => _showPauseMenu = false);
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Overlays
  // ---------------------------------------------------------------------------

  Widget _buildSkillCheckOverlay(Color accent) {
    final result = _lastSkillCheck!;
    final color =
        result.success ? LoreforgeColors.success : LoreforgeColors.error;
    return Positioned.fill(
      child: Center(
        child: AnimatedOpacity(
          opacity: _showSkillCheck ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: LoreforgeColors.surface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: color.withValues(alpha: 0.6), width: 2),
              boxShadow: [
                BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  result.success ? Icons.check_circle : Icons.cancel,
                  color: color,
                  size: 36,
                ),
                const SizedBox(height: 12),
                Text(
                  result.narrative,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                if (result.statDelta != 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    result.statDelta > 0
                        ? '${result.stat[0].toUpperCase()}${result.stat.substring(1)} +1!'
                        : '${result.stat[0].toUpperCase()}${result.stat.substring(1)} -1',
                    style: TextStyle(
                      color: result.statDelta > 0
                          ? LoreforgeColors.success
                          : LoreforgeColors.error,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceAcknowledgmentOverlay(Color accent) {
    return Positioned(
      bottom: 120,
      left: 32,
      right: 32,
      child: AnimatedOpacity(
        opacity: _choiceAcknowledgment != null ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 400),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accent.withValues(alpha: 0.4)),
          ),
          child: Text(
            _choiceAcknowledgment ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cinzel',
              color: accent.withValues(alpha: 0.9),
              fontSize: 13,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top bar
  // ---------------------------------------------------------------------------

  Widget _buildTopBar(BuildContext context, dynamic storyState, Color accent) {
    final state = storyState as StoryState;
    final sceneCount = state.scenes.length;
    final nodeCount = state.worldState['_blueprintNodeCount'] as int? ?? 0;
    final sceneLabel =
        nodeCount > 0 ? 'Scene $sceneCount/$nodeCount' : 'Scene $sceneCount';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: GenreTheme.darkBgColor(state.genre),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GenreTheme.borderColor(state.genre)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_stories,
                    color: accent.withValues(alpha: 0.9), size: 14),
                const SizedBox(width: 6),
                Text(
                  state.genre,
                  style: TextStyle(
                    color: accent.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          if (state.mode == 'rpg') ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: LoreforgeColors.successBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: LoreforgeColors.successBorder),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield,
                      color: LoreforgeColors.success, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'RPG',
                    style: TextStyle(
                      color: LoreforgeColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(width: 8),
          Text(
            sceneLabel,
            style: const TextStyle(
              color: LoreforgeColors.textDim,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
          const Spacer(),
          if (state.mode == 'rpg') ...[
            _TopBarButton(
              icon: Icons.person_outline,
              tooltip: 'Character Sheet',
              onPressed: () => showDialog(
                context: context,
                builder: (_) => const CharacterSheetOverlay(),
              ),
            ),
            _TopBarButton(
              icon: Icons.backpack_outlined,
              tooltip: 'Inventory',
              onPressed: () => showDialog(
                context: context,
                builder: (_) => const InventoryOverlay(),
              ),
            ),
          ],
          _TopBarButton(
            icon: Icons.auto_stories,
            tooltip: 'Story Log',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const StoryLogOverlay(),
            ),
          ),
          _TopBarButton(
            icon: Icons.save_outlined,
            tooltip: 'Save',
            onPressed: _saveGame,
          ),
          _TopBarButton(
            icon: Icons.menu,
            tooltip: 'Menu',
            onPressed: () => setState(() => _showPauseMenu = true),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Choices
  // ---------------------------------------------------------------------------

  Widget _buildChoices(
      List<String> choices, StoryState storyState, Color accent) {
    const staggerMs = 100;
    const durationMs = 300;
    const totalMs = 1200;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              _genreChoicePrompt(storyState.genre),
              style: const TextStyle(
                fontFamily: 'Cinzel',
                color: LoreforgeColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ...choices.asMap().entries.map((entry) {
            final index = entry.key;
            final choice = entry.value;

            final startFraction = (index * staggerMs) / totalMs;
            final endFraction = ((index * staggerMs) + durationMs) / totalMs;

            final intervalCurve = CurvedAnimation(
              parent: _choiceAnimController,
              curve: Interval(
                startFraction.clamp(0.0, 1.0),
                endFraction.clamp(0.0, 1.0),
                curve: Curves.easeOut,
              ),
            );

            final fadeAnim =
                Tween<double>(begin: 0.0, end: 1.0).animate(intervalCurve);
            final slideAnim = Tween<Offset>(
              begin: const Offset(0.15, 0.0),
              end: Offset.zero,
            ).animate(intervalCurve);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FadeTransition(
                opacity: fadeAnim,
                child: SlideTransition(
                  position: slideAnim,
                  child: _ChoiceButton(
                    number: index + 1,
                    text: choice,
                    accent: accent,
                    onPressed: () => _handleChoice(choice, index),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCursor(Color accent) {
    return AnimatedBuilder(
      animation: _dotController,
      builder: (context, child) {
        final opacity = (_dotController.value < 0.5) ? 1.0 : 0.0;
        return Opacity(
          opacity: opacity,
          child: Text(
            '\u258b',
            style: TextStyle(color: accent, fontSize: 17),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Save / Load
  // ---------------------------------------------------------------------------

  Future<void> _saveGame() async {
    try {
      await SaveManager.saveStory(ref.read(storyProvider));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adventure saved.'),
            backgroundColor: LoreforgeColors.snackBarBg,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Save failed: $e'),
              backgroundColor: LoreforgeColors.errorBg),
        );
      }
    }
  }

  Future<void> _loadGame() async {
    try {
      final loadedStory = await SaveManager.loadStory();
      if (loadedStory != null) {
        ref.read(storyProvider.notifier).loadStory(loadedStory);
        _startStreaming();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adventure loaded.'),
              backgroundColor: LoreforgeColors.snackBarBg,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No saved adventure found.'),
              backgroundColor: LoreforgeColors.snackBarBg,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Load failed: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    _scrollController.dispose();
    _dotController.dispose();
    _choiceAnimController.dispose();
    AudioManager().dispose();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _TopBarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: LoreforgeColors.textMuted, size: 24),
        splashRadius: 22,
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final int number;
  final String text;
  final Color accent;
  final VoidCallback onPressed;

  const _ChoiceButton({
    required this.number,
    required this.text,
    required this.accent,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        hoverColor: accent.withValues(alpha: 0.06),
        splashColor: accent.withValues(alpha: 0.12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
          decoration: BoxDecoration(
            color: LoreforgeColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: LoreforgeColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 24,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.7),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$number',
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _stripMarkdown(text),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Lora',
                    color: LoreforgeColors.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              Icon(Icons.chevron_right,
                  color: accent.withValues(alpha: 0.4), size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
