import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_provider.dart';
import 'anthropic_provider.dart' show HttpProviderException;
import 'sse_parser.dart';

/// OpenAI GPT provider.
class OpenAIProvider implements AIProvider {
  final String apiKey;
  final String model;

  OpenAIProvider(this.apiKey, {this.model = 'gpt-4o'});

  static const _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

  @override
  String get name => 'openai';

  @override
  Future<String> generate(String prompt) async {
    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: _headers,
          body: jsonEncode({
            'model': model,
            'messages': [
              {'role': 'user', 'content': prompt}
            ],
          }),
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>;
      return choices.first['message']['content'] as String;
    }
    throw HttpProviderException(response.statusCode, response.body, name);
  }

  @override
  Future<Stream<String>> generateStream(String prompt) async {
    final request = http.Request('POST', Uri.parse(_baseUrl));
    request.headers.addAll(_headers);
    request.body = jsonEncode({
      'model': model,
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

    // OpenAI SSE: {"choices":[{"delta":{"content":"..."}}]}
    return parseSSE(streamedResponse.stream, (json) {
      final choices = json['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) return null;
      final delta = choices.first['delta'] as Map<String, dynamic>?;
      return delta?['content'] as String?;
    });
  }

  @override
  Future<bool> validateKey() async {
    try {
      final response = await http
          .get(
            Uri.parse('https://api.openai.com/v1/models'),
            headers: {'Authorization': 'Bearer $apiKey'},
          )
          .timeout(const Duration(seconds: 15));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
