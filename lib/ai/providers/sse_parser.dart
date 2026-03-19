import 'dart:async';
import 'dart:convert';

/// Shared SSE (Server-Sent Events) stream parser.
///
/// All three providers (Anthropic, OpenAI, DeepSeek) use SSE for streaming.
/// This utility handles line buffering, `data:` prefix stripping, JSON
/// parsing, and the `[DONE]` sentinel — differences between providers are
/// isolated to the [extractText] callback.
Stream<String> parseSSE(
  Stream<List<int>> byteStream,
  String? Function(Map<String, dynamic> json) extractText,
) {
  final controller = StreamController<String>();
  final buffer = StringBuffer();

  byteStream.transform(utf8.decoder).listen(
    (chunk) {
      buffer.write(chunk);
      final raw = buffer.toString();
      final lines = raw.split('\n');

      // Keep the last (potentially incomplete) line in the buffer.
      buffer.clear();
      buffer.write(lines.removeLast());

      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;
        if (!trimmed.startsWith('data:')) continue;

        final payload = trimmed.substring(5).trim();
        if (payload == '[DONE]') continue;

        try {
          final json = jsonDecode(payload) as Map<String, dynamic>;
          final text = extractText(json);
          if (text != null && text.isNotEmpty) {
            controller.add(text);
          }
        } catch (_) {
          // Malformed JSON line — skip silently.
        }
      }
    },
    onError: (Object e) => controller.addError(e),
    onDone: () => controller.close(),
  );

  return controller.stream;
}
