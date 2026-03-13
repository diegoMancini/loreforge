import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/scene_provider.dart';
import '../providers/story_provider.dart';
import '../audio/audio_manager.dart';
import '../database/save_manager.dart';
import 'character_sheet_overlay.dart';
import 'inventory_overlay.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  const GameplayScreen({super.key});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  final ScrollController _scrollController = ScrollController();
  String _displayedText = '';
  bool _isStreaming = false;
  Stream<String>? _stream;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
    _startStreaming();
  }

  Future<void> _initializeAudio() async {
    await AudioManager().initialize();
    final storyState = ref.read(storyProvider);
    await AudioManager().playBackgroundMusic(storyState.genre);
  }

  void _startStreaming() async {
    final scene = ref.read(currentSceneProvider);
    if (scene == null) return;

    setState(() {
      _isStreaming = true;
      _displayedText = '';
    });

    // Get streaming narrative
    final aiClient = AIClient();
    final storyState = ref.read(storyProvider);
    _stream = await aiClient.generateSceneStream(storyState);

    _stream?.listen(
      (chunk) {
        setState(() {
          _displayedText += chunk;
        });
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 50),
          curve: Curves.easeOut,
        );
      },
      onDone: () {
        setState(() {
          _isStreaming = false;
        });
      },
      onError: (error) {
        setState(() {
          _isStreaming = false;
          _displayedText += '\n[Error: $error]';
        });
      },
    );
  }

  void _showCharacterSheet() {
    showDialog(
      context: context,
      builder: (context) => const CharacterSheetOverlay(),
    );
  }

  void _showInventory() {
    showDialog(
      context: context,
      builder: (context) => const InventoryOverlay(),
    );
  }

  Future<void> _saveGame() async {
    try {
      final storyState = ref.read(storyProvider);
      await SaveManager.saveStory(storyState);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Game saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save game: $e')),
      );
    }
  }

  Future<void> _loadGame() async {
    try {
      final loadedStory = await SaveManager.loadStory();
      if (loadedStory != null) {
        ref.read(storyProvider.notifier).loadStory(loadedStory);
        // Restart streaming with loaded story
        _startStreaming();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Game loaded successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No saved game found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load game: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyState = ref.watch(storyProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background (placeholder)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.indigo],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Top overlay buttons
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  onPressed: _saveGame,
                  icon: const Icon(Icons.save, color: Colors.white),
                  tooltip: 'Save Game',
                ),
                IconButton(
                  onPressed: _loadGame,
                  icon: const Icon(Icons.folder_open, color: Colors.white),
                  tooltip: 'Load Game',
                ),
                if (storyState.mode == 'rpg') ...[
                  IconButton(
                    onPressed: _showCharacterSheet,
                    icon: const Icon(Icons.person, color: Colors.white),
                    tooltip: 'Character Sheet',
                  ),
                  IconButton(
                    onPressed: _showInventory,
                    icon: const Icon(Icons.inventory, color: Colors.white),
                    tooltip: 'Inventory',
                  ),
                ],
                IconButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/wizard'),
                  icon: const Icon(Icons.settings, color: Colors.white),
                  tooltip: 'Settings',
                ),
              ],
            ),
          ),
          // Text box
          Positioned(
            bottom: 200,
            left: 16,
            right: 16,
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Text(
                  _displayedText,
                  style: const TextStyle(fontSize: 18, height: 1.4),
                ),
              ),
            ),
          ),
          // Streaming indicator
          if (_isStreaming)
            Positioned(
              top: 50,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Writing scene...',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          // Choices
          if (!_isStreaming && ref.watch(currentSceneProvider) != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: ref.watch(currentSceneProvider)!.choices.map((choice) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      await AudioManager().playSoundEffect('audio/sfx_choice.mp3');
                      ref.read(storyProvider.notifier).makeChoice(choice);
                      _startStreaming();
                    },
                    child: Text(choice, textAlign: TextAlign.center),
                  ),
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stream?.listen(null)?.cancel();
    _scrollController.dispose();
    AudioManager().dispose();
    super.dispose();
  }
}