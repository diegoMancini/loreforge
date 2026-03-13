import 'dart:async';
import 'base_provider.dart';

class MockProvider implements AIProvider {
  @override
  Future<String> generate(String prompt) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Mock response to: $prompt';
  }

  @override
  Future<Stream<String>> generateStream(String prompt) async {
    return Stream.fromIterable(['Mock ', 'streaming ', 'response ', 'to: ', prompt]);
  }
}