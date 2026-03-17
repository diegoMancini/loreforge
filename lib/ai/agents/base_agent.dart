import '../providers/base_provider.dart';

/// Base class for all LoreForge AI agents.
///
/// Provides thin wrappers over [AIProvider.generate] and
/// [AIProvider.generateStream]. Concrete agents extend this and call
/// [generate] / [generateStream] with their assembled prompts.
abstract class AIAgent {
  final AIProvider provider;
  AIAgent(this.provider);

  Future<String> generate(String prompt) => provider.generate(prompt);

  Future<Stream<String>> generateStream(String prompt) =>
      provider.generateStream(prompt);
}
