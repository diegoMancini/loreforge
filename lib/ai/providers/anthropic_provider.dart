import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_provider.dart';
import 'sse_parser.dart';

/// Anthropic Claude provider.
///
/// Uses the Messages API with streaming support via SSE.
class AnthropicProvider implements AIProvider {
  final String apiKey;
  final String model;

  AnthropicProvider(this.apiKey, {this.model = 'claude-sonnet-4-20250514'});

  static const _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const _version = '2023-06-01';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': _version,
      };

  @override
  String get name => 'anthropic';

  @override
  Future<String> generate(String prompt) async {
    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: _headers,
          body: jsonEncode({
            'model': model,
            'max_tokens': 1024,
            'messages': [
              {'role': 'user', 'content': prompt}
            ],
          }),
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final content = data['content'] as List<dynamic>;
      return content.first['text'] as String;
    }
    throw HttpProviderException(response.statusCode, response.body, name);
  }

  @override
  Future<Stream<String>> generateStream(String prompt) async {
    final request = http.Request('POST', Uri.parse(_baseUrl));
    request.headers.addAll(_headers);
    request.body = jsonEncode({
      'model': model,
      'max_tokens': 1024,
      'stream': true,
      'messages': [
        {'role': 'user', 'content': prompt}
      ],
    });

    final client = http.Client();
    final streamedResponse =
        await client.send(request).timeout(const Duration(seconds: 60));

    if (streamedResponse.statusCode != 200) {
      final body = await streamedResponse.stream.bytesToString();
      client.close();
      throw HttpProviderException(streamedResponse.statusCode, body, name);
    }

    // Anthropic SSE: content_block_delta events contain {"delta": {"text": "..."}}
    return parseSSE(streamedResponse.stream, (json) {
      final type = json['type'] as String?;
      if (type == 'content_block_delta') {
        final delta = json['delta'] as Map<String, dynamic>?;
        return delta?['text'] as String?;
      }
      return null;
    });
  }

  @override
  Future<bool> validateKey() async {
    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: _headers,
            body: jsonEncode({
              'model': model,
              'max_tokens': 1,
              'messages': [
                {'role': 'user', 'content': 'Hi'}
              ],
            }),
          )
          .timeout(const Duration(seconds: 15));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

/// Thrown when an AI provider returns a non-success HTTP status.
class HttpProviderException implements Exception {
  final int statusCode;
  final String body;
  final String provider;
  HttpProviderException(this.statusCode, this.body, this.provider);

  bool get isAuth => statusCode == 401 || statusCode == 403;
  bool get isRateLimit => statusCode == 429;
  bool get isServer =>
      statusCode == 500 || statusCode == 502 || statusCode == 503;
  bool get isRetryable => isRateLimit || isServer;

  @override
  String toString() => '$provider API error $statusCode: $body';
}
