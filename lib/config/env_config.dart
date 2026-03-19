/// Compile-time environment configuration.
///
/// Values are injected via `--dart-define` flags during build:
/// ```sh
/// flutter build web --dart-define=ANTHROPIC_API_KEY=sk-ant-...
/// ```
class EnvConfig {
  /// Anthropic API key injected at compile time via --dart-define.
  static const String anthropicApiKey =
      String.fromEnvironment('ANTHROPIC_API_KEY');
}
