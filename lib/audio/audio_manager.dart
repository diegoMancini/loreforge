import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  AudioPlayer? _backgroundPlayer;
  AudioPlayer? _sfxPlayer;
  bool _enabled = false;

  /// Call once at startup. On web, audio is disabled when asset files are
  /// missing (the browser media element emits async errors we cannot catch).
  Future<void> initialize() async {
    if (kIsWeb) {
      // Audio assets are not shipped yet — disable on web to avoid
      // uncatchable MEDIA_ELEMENT_ERROR console spam.
      _enabled = false;
      return;
    }
    try {
      await FlameAudio.audioCache.loadAll([
        'audio/bgm_fantasy.mp3',
        'audio/bgm_horror.mp3',
        'audio/bgm_mystery.mp3',
        'audio/sfx_choice.mp3',
        'audio/sfx_scene.mp3',
      ]);
      _enabled = true;
    } catch (_) {
      _enabled = false;
    }
  }

  Future<void> playBackgroundMusic(String genre) async {
    if (!_enabled) return;
    try {
      await stopBackgroundMusic();
      String musicFile = _getMusicForGenre(genre);
      _backgroundPlayer = await FlameAudio.loop(musicFile, volume: 0.3);
    } catch (_) {
      // Audio file missing — skip playback
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundPlayer?.stop();
    _backgroundPlayer = null;
  }

  Future<void> playSoundEffect(String effect) async {
    if (!_enabled) return;
    try {
      await _sfxPlayer?.stop();
      _sfxPlayer = await FlameAudio.play(effect, volume: 0.5);
    } catch (_) {
      // SFX file missing — skip playback
    }
  }

  String _getMusicForGenre(String genre) {
    switch (genre.toLowerCase()) {
      case 'fantasy': return 'audio/bgm_fantasy.mp3';
      case 'horror': return 'audio/bgm_horror.mp3';
      case 'mystery': return 'audio/bgm_mystery.mp3';
      case 'sci-fi': return 'audio/bgm_scifi.mp3';
      default: return 'audio/bgm_default.mp3';
    }
  }

  void dispose() {
    _backgroundPlayer?.dispose();
    _sfxPlayer?.dispose();
  }
}
