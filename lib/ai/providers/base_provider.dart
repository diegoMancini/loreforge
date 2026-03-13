abstract class AIProvider {
  Future<String> generate(String prompt);
  Future<Stream<String>> generateStream(String prompt);
}