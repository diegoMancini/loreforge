import 'dart:async';
import 'dart:io';
import '../providers/base_provider.dart';
import '../providers/anthropic_provider.dart' show HttpProviderException;

/// Base class for all LoreForge AI agents.
///
/// Provides [generate] and [generateStream] wrappers over [AIProvider] with
/// automatic retry and exponential backoff for transient failures.
abstract class AIAgent {
  final AIProvider provider;
  AIAgent(this.provider);

  static const _maxRetries = 3;
  static const _backoffMs = [1000, 2000, 4000];

  /// Generate a complete response with retry logic.
  Future<String> generate(String prompt) async {
    for (int attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        return await provider.generate(prompt);
      } on HttpProviderException catch (e) {
        if (!e.isRetryable || attempt == _maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: _backoffMs[attempt]));
      } on SocketException {
        if (attempt == _maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: _backoffMs[attempt]));
      } on TimeoutException {
        if (attempt == _maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: _backoffMs[attempt]));
      }
    }
    // Unreachable, but satisfies the compiler.
    return provider.generate(prompt);
  }

  /// Stream a response with retry on initial connection failure.
  Future<Stream<String>> generateStream(String prompt) async {
    for (int attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        return await provider.generateStream(prompt);
      } on HttpProviderException catch (e) {
        if (!e.isRetryable || attempt == _maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: _backoffMs[attempt]));
      } on SocketException {
        if (attempt == _maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: _backoffMs[attempt]));
      } on TimeoutException {
        if (attempt == _maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: _backoffMs[attempt]));
      }
    }
    return provider.generateStream(prompt);
  }
}
