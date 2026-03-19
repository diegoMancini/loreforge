/// Compile-time environment configuration.
///
/// Values are injected via `--dart-define` flags during `flutter build` or
/// `flutter run`. Example:
///
/// ```sh
/// flutter build web --dart-define=ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY
/// ```
class EnvConfig {
  /// Anthropic API key injected at compile time.
  static const String anthropicApiKey =
      String.fromEnvironment('ANTHROPIC_API_KEY');
}
