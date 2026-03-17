import 'dart:convert';

/// Utility for parsing JSON from raw AI text responses.
///
/// AI providers often wrap JSON in markdown code fences or emit surrounding
/// prose. [AIJsonParser] strips that noise and attempts to parse the first
/// complete JSON object or array found in the response text.
class AIJsonParser {
  // Matches ```json ... ``` or ``` ... ``` fences, and bare { / [ blocks.
  static final RegExp _fencePattern = RegExp(
    r'```(?:json)?\s*([\s\S]*?)\s*```',
    multiLine: true,
  );

  /// Attempts to parse [response] as JSON, returning the decoded value on
  /// success or `null` on failure.
  ///
  /// Parsing strategy (in order):
  /// 1. Strip markdown code fences and parse inner content.
  /// 2. Find the first `{` or `[` character and parse from there.
  /// 3. Return `null` if neither strategy succeeds.
  static dynamic tryParse(String response) {
    if (response.isEmpty) return null;

    // Strategy 1: extract from markdown fences.
    final fenceMatch = _fencePattern.firstMatch(response);
    if (fenceMatch != null) {
      final inner = fenceMatch.group(1)?.trim() ?? '';
      try {
        return jsonDecode(inner);
      } catch (_) {
        // Fall through to strategy 2.
      }
    }

    // Strategy 2: find bare JSON object or array.
    final objectStart = response.indexOf('{');
    final arrayStart = response.indexOf('[');
    int start;
    if (objectStart == -1 && arrayStart == -1) return null;
    if (objectStart == -1) {
      start = arrayStart;
    } else if (arrayStart == -1) {
      start = objectStart;
    } else {
      start = objectStart < arrayStart ? objectStart : arrayStart;
    }

    try {
      return jsonDecode(response.substring(start));
    } catch (_) {
      return null;
    }
  }

  /// Legacy name — delegates to [parseMap].
  static Map<String, dynamic>? extractJsonObject(String response) {
    final result = parseMap(response);
    return result.isEmpty ? null : result;
  }

  /// Parses [response] as a `Map<String, dynamic>`.
  /// Returns an empty map if parsing fails or the result is not a map.
  static Map<String, dynamic> parseMap(String response) {
    final parsed = tryParse(response);
    if (parsed is Map<String, dynamic>) return parsed;
    return {};
  }

  /// Parses [response] as a `List<dynamic>`.
  /// Returns an empty list if parsing fails or the result is not a list.
  static List<dynamic> parseList(String response) {
    final parsed = tryParse(response);
    if (parsed is List<dynamic>) return parsed;
    return [];
  }

  /// Extracts a specific [key] from a JSON map in [response].
  /// Returns [defaultValue] if the key is missing or parsing fails.
  static T? extractKey<T>(String response, String key) {
    final map = parseMap(response);
    final value = map[key];
    if (value is T) return value;
    return null;
  }
}
