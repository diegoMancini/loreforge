import 'package:riverpod/riverpod.dart';

/// Immutable application settings model.
class AppSettings {
  const AppSettings({
    this.textSize = 16.0,
    this.musicVolume = 0.7,
    this.sfxVolume = 1.0,
  });

  /// Font size used for narrative prose in [GameplayScreen].
  final double textSize;

  /// Background music volume (0.0–1.0).
  final double musicVolume;

  /// Sound effects volume (0.0–1.0).
  final double sfxVolume;

  AppSettings copyWith({
    double? textSize,
    double? musicVolume,
    double? sfxVolume,
  }) {
    return AppSettings(
      textSize: textSize ?? this.textSize,
      musicVolume: musicVolume ?? this.musicVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
    );
  }
}

/// Riverpod notifier for [AppSettings].
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings());

  void setTextSize(double size) {
    state = state.copyWith(textSize: size.clamp(12.0, 24.0));
  }

  void setMusicVolume(double volume) {
    state = state.copyWith(musicVolume: volume.clamp(0.0, 1.0));
  }

  void setSfxVolume(double volume) {
    state = state.copyWith(sfxVolume: volume.clamp(0.0, 1.0));
  }
}

/// Global settings provider.
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);
