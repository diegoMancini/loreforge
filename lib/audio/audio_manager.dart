import 'package:flame_audio/flame_audio.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  AudioPlayer? _backgroundPlayer;
  AudioPlayer? _sfxPlayer;

  Future<void> initialize() async {
    await FlameAudio.audioCache.loadAll([
      'audio/bgm_fantasy.mp3',
      'audio/bgm_horror.mp3',
      'audio/bgm_mystery.mp3',
      'audio/sfx_choice.mp3',
      'audio/sfx_scene.mp3',
    ]);
  }

  Future<void> playBackgroundMusic(String genre) async {
    await stopBackgroundMusic();
    String musicFile = _getMusicForGenre(genre);
    _backgroundPlayer = await FlameAudio.loop(musicFile, volume: 0.3);
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundPlayer?.stop();
    _backgroundPlayer = null;
  }

  Future<void> playSoundEffect(String effect) async {
    await _sfxPlayer?.stop();
    _sfxPlayer = await FlameAudio.play(effect, volume: 0.5);
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