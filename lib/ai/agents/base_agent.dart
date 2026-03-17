import '../providers/base_provider.dart';

/// Base class for all AI agents.
///
/// Provides concrete default implementations of [generate] and [generateStream]
/// that delegate directly to the injected [AIProvider]. Subclasses call these
/// methods in their own prompt-building logic and may override them when they
/// need specialised behaviour (e.g., retry logic, response parsing).
abstract class AIAgent {
  final AIProvider provider;

  AIAgent(this.provider);

  /// Generates a complete text response for [prompt].
  Future<String> generate(String prompt) => provider.generate(prompt);

  /// Generates a streaming text response for [prompt].
  Future<Stream<String>> generateStream(String prompt) =>
      provider.generateStream(prompt);
}
