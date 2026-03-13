import '../providers/base_provider.dart';

abstract class AIAgent {
  final AIProvider provider;

  AIAgent(this.provider);

  Future<String> generate(String prompt);
  Future<Stream<String>> generateStream(String prompt);
}