/// Contract that every AI provider must implement.
///
/// Callers interact with providers exclusively through this interface,
/// allowing transparent switching between Anthropic, OpenAI, DeepSeek,
/// and the development-only [MockProvider].
abstract class AIProvider {
  /// Short identifier for this provider (e.g. 'anthropic', 'openai', 'deepseek', 'mock').
  String get name;

  /// Generate a complete response for [prompt] in one shot.
  Future<String> generate(String prompt);

  /// Stream a response token-by-token.
  Future<Stream<String>> generateStream(String prompt);

  /// Verify that the configured API key is valid.
  ///
  /// Returns `true` if a lightweight probe call succeeds, `false` on
  /// authentication failure, and throws on network errors.
  Future<bool> validateKey();
}
