import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'base_provider.dart';
import 'anthropic_provider.dart' show HttpProviderException;
import 'sse_parser.dart';

/// DeepSeek provider (OpenAI-compatible API).
class DeepSeekProvider implements AIProvider {
  final String apiKey;
  DeepSeekProvider(this.apiKey);

  static const _baseUrl = 'https://api.deepseek.com/v1/chat/completions';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

  http.Client _createClient() => http.Client();

  @override
  String get name => 'deepseek';

  @override
  Future<String> generate(String prompt) async {
    final client = _createClient();
    try {
      final response = await client
          .post(Uri.parse(_baseUrl), headers: _headers, body: jsonEncode({
            'model': 'deepseek-chat',
            'messages': [{'role': 'user', 'content': prompt}],
          }))
          .timeout(const Duration(seconds: 90));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['choices'][0]['message']['content'] as String;
      }
      throw HttpProviderException(response.statusCode, response.body, name);
    } finally {
      client.close();
    }
  }

  @override
  Future<Stream<String>> generateStream(String prompt) async {
    if (kIsWeb) {
      final full = await generate(prompt);
      final words = full.split(' ');
      final c = StreamController<String>();
      () async {
        for (int i = 0; i < words.length; i++) {
          if (c.isClosed) break;
          c.add(i == 0 ? words[i] : ' ${words[i]}');
          await Future.delayed(const Duration(milliseconds: 30));
        }
        c.close();
      }();
      return c.stream;
    }
    final request = http.Request('POST', Uri.parse(_baseUrl));
    request.headers.addAll(_headers);
    request.body = jsonEncode({
      'model': 'deepseek-chat', 'stream': true,
      'messages': [{'role': 'user', 'content': prompt}],
    });
    final client = http.Client();
    final resp = await client.send(request).timeout(const Duration(seconds: 90));
    if (resp.statusCode != 200) {
      final body = await resp.stream.bytesToString();
      client.close();
      throw HttpProviderException(resp.statusCode, body, name);
    }
    return parseSSE(resp.stream, (json) {
      final choices = json['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) return null;
      return (choices.first['delta'] as Map<String, dynamic>?)?['content'] as String?;
    });
  }

  @override
  Future<bool> validateKey() async {
    final client = _createClient();
    try {
      final r = await client.post(Uri.parse(_baseUrl), headers: _headers,
          body: jsonEncode({'model': 'deepseek-chat', 'max_tokens': 1,
            'messages': [{'role': 'user', 'content': 'Hi'}]}))
          .timeout(const Duration(seconds: 15));
      return r.statusCode == 200;
    } catch (_) { return false; } finally { client.close(); }
  }
}
