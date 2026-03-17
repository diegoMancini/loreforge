import '../providers/base_provider.dart';

/// Base class for all AI agents. Concrete agents extend this and call
/// [generate] / [generateStream] which delegate to the injected provider.
abstract class AIAgent {
  final AIProvider provider;

  AIAgent(this.provider);

  /// Sends [prompt] to the provider and returns the complete response text.
  Future<String> generate(String prompt, {int maxTokens = 1024}) =>
      provider.generate(prompt);

  /// Sends [prompt] to the provider and returns a streaming response.
  Future<Stream<String>> generateStream(String prompt) =>
      provider.generateStream(prompt);
}
