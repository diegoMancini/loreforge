import '../providers/base_provider.dart';

abstract class AIAgent {
  final AIProvider provider;
  AIAgent(this.provider);

  Future<String> generate(String prompt, {int maxTokens = 4096}) =>
      provider.generate(prompt, maxTokens: maxTokens);

  Future<Stream<String>> generateStream(String prompt, {int maxTokens = 4096}) =>
      provider.generateStream(prompt, maxTokens: maxTokens);
}
