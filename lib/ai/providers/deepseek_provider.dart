import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_provider.dart';

class DeepSeekProvider implements AIProvider {
  final String apiKey;

  DeepSeekProvider(this.apiKey);

  @override
  Future<String> generate(String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.deepseek.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'deepseek-chat',
        'messages': [{'role': 'user', 'content': prompt}],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('DeepSeek API error: ${response.body}');
    }
  }

  @override
  Future<Stream<String>> generateStream(String prompt) async {
    // For streaming, need to handle SSE
    // Simplified for now
    final fullResponse = await generate(prompt);
    return Stream.fromIterable([fullResponse]);
  }
}