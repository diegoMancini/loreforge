import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/env_config.dart';

/// Immutable application settings model.
class AppSettings {
  const AppSettings({
    this.textSize = 16.0,
    this.musicVolume = 0.7,
    this.sfxVolume = 1.0,
    this.textSpeed = 1.0,
    this.anthropicApiKey,
    this.openaiApiKey,
    this.deepseekApiKey,
    this.preferredProvider = 'auto',
  });

  final double textSize;
  final double musicVolume;
  final double sfxVolume;
  final double textSpeed;
  final String? anthropicApiKey;
  final String? openaiApiKey;
  final String? deepseekApiKey;
  final String preferredProvider;

  /// Whether at least one real API key is configured.
  bool get hasAnyApiKey =>
      (anthropicApiKey?.isNotEmpty ?? false) ||
      (openaiApiKey?.isNotEmpty ?? false) ||
      (deepseekApiKey?.isNotEmpty ?? false);

  AppSettings copyWith({
    double? textSize,
    double? musicVolume,
    double? sfxVolume,
    double? textSpeed,
    String? anthropicApiKey,
    String? openaiApiKey,
    String? deepseekApiKey,
    String? preferredProvider,
    bool clearAnthropicKey = false,
    bool clearOpenaiKey = false,
    bool clearDeepseekKey = false,
  }) {
    return AppSettings(
      textSize: textSize ?? this.textSize,
      musicVolume: musicVolume ?? this.musicVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
      textSpeed: textSpeed ?? this.textSpeed,
      anthropicApiKey:
          clearAnthropicKey ? null : (anthropicApiKey ?? this.anthropicApiKey),
      openaiApiKey:
          clearOpenaiKey ? null : (openaiApiKey ?? this.openaiApiKey),
      deepseekApiKey:
          clearDeepseekKey ? null : (deepseekApiKey ?? this.deepseekApiKey),
      preferredProvider: preferredProvider ?? this.preferredProvider,
    );
  }
}

/// Riverpod notifier for [AppSettings] with SharedPreferences persistence.
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(
      textSize: prefs.getDouble('lf_text_size') ?? 16.0,
      musicVolume: prefs.getDouble('lf_music_vol') ?? 0.7,
      sfxVolume: prefs.getDouble('lf_sfx_vol') ?? 1.0,
      textSpeed: prefs.getDouble('lf_text_speed') ?? 1.0,
      anthropicApiKey: prefs.getString('lf_anthropic_key')
          ?? (EnvConfig.anthropicApiKey.isNotEmpty ? EnvConfig.anthropicApiKey : null),
      openaiApiKey: prefs.getString('lf_openai_key'),
      deepseekApiKey: prefs.getString('lf_deepseek_key'),
      preferredProvider: prefs.getString('lf_preferred_provider') ?? 'auto',
    );
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('lf_text_size', state.textSize);
    await prefs.setDouble('lf_music_vol', state.musicVolume);
    await prefs.setDouble('lf_sfx_vol', state.sfxVolume);
    await prefs.setDouble('lf_text_speed', state.textSpeed);
    await prefs.setString('lf_preferred_provider', state.preferredProvider);
    _persistKey(prefs, 'lf_anthropic_key', state.anthropicApiKey);
    _persistKey(prefs, 'lf_openai_key', state.openaiApiKey);
    _persistKey(prefs, 'lf_deepseek_key', state.deepseekApiKey);
  }

  void _persistKey(SharedPreferences prefs, String key, String? value) {
    if (value != null && value.isNotEmpty) {
      prefs.setString(key, value);
    } else {
      prefs.remove(key);
    }
  }

  void setTextSize(double size) {
    state = state.copyWith(textSize: size.clamp(12.0, 24.0));
    _persist();
  }

  void setMusicVolume(double volume) {
    state = state.copyWith(musicVolume: volume.clamp(0.0, 1.0));
    _persist();
  }

  void setSfxVolume(double volume) {
    state = state.copyWith(sfxVolume: volume.clamp(0.0, 1.0));
    _persist();
  }

  void setTextSpeed(double speed) {
    state = state.copyWith(textSpeed: speed.clamp(0.5, 3.0));
    _persist();
  }

  void setAnthropicApiKey(String? key) {
    state = key == null || key.isEmpty
        ? state.copyWith(clearAnthropicKey: true)
        : state.copyWith(anthropicApiKey: key);
    _persist();
  }

  void setOpenaiApiKey(String? key) {
    state = key == null || key.isEmpty
        ? state.copyWith(clearOpenaiKey: true)
        : state.copyWith(openaiApiKey: key);
    _persist();
  }

  void setDeepseekApiKey(String? key) {
    state = key == null || key.isEmpty
        ? state.copyWith(clearDeepseekKey: true)
        : state.copyWith(deepseekApiKey: key);
    _persist();
  }

  void setPreferredProvider(String provider) {
    state = state.copyWith(preferredProvider: provider);
    _persist();
  }
}

/// Global settings provider.
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);
