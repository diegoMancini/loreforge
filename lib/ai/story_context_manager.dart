import '../models/story_state.dart';

/// Maintains a rolling compressed summary of the story so far.
///
/// As scene count grows, sending the full scene list to every AI call becomes
/// expensive. [StoryContextManager] summarises previous scenes into a compact
/// representation with three keys:
///
///   'summary'    — prose paragraph covering the story so far
///   'characters' — list of active character names seen in recent scenes
///   'threads'    — list of open narrative threads still unresolved
///
/// The returned map is suitable for storing directly in [StoryState.worldState].
class StoryContextManager {
  /// Maximum number of recent scenes to include verbatim before summarising.
  static const int _recentSceneWindow = 3;

  /// Builds a new context summary from [state] and the latest [narrative] chunk.
  ///
  /// This is a pure in-process implementation — it extracts characters via
  /// simple heuristics and compresses older scenes into a prose summary.
  /// A future version can route through the AI provider for richer summaries.
  Map<String, dynamic> updateSummary(StoryState state, String narrative) {
    final allScenes = [...state.scenes, narrative];

    // Scenes older than the window are collapsed into a summary paragraph.
    final olderScenes =
        allScenes.length > _recentSceneWindow
            ? allScenes.sublist(0, allScenes.length - _recentSceneWindow)
            : <String>[];

    final recentScenes =
        allScenes.length > _recentSceneWindow
            ? allScenes.sublist(allScenes.length - _recentSceneWindow)
            : allScenes;

    final existingSummary =
        state.worldState['_summary'] as String? ?? '';

    final compressedSummary = _compressSummary(existingSummary, olderScenes);

    final characters = _extractCharacters(allScenes, state.worldState);
    final threads = _extractThreads(allScenes, state.worldState);

    return {
      '_summary': compressedSummary,
      '_recentScenes': recentScenes,
      '_characters': characters,
      '_threads': threads,
    };
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Compresses [olderScenes] with the existing [priorSummary] into a single
  /// prose paragraph. Uses a simple word-truncation strategy.
  String _compressSummary(String priorSummary, List<String> olderScenes) {
    if (olderScenes.isEmpty) return priorSummary;

    final combinedText =
        [if (priorSummary.isNotEmpty) priorSummary, ...olderScenes].join(' ');

    // Truncate to ~200 words to keep context tokens bounded
    final words = combinedText.split(RegExp(r'\s+'));
    if (words.length <= 200) return combinedText.trim();

    return '${words.sublist(0, 200).join(' ')}...';
  }

  /// Extracts likely character names from scene text using a capitalised-word
  /// heuristic. Merges with any characters already tracked in [worldState].
  List<String> _extractCharacters(
      List<String> scenes, Map<String, dynamic> worldState) {
    final existing =
        (worldState['_characters'] as List<dynamic>?)?.cast<String>().toSet() ??
            {};

    // Find sequences of 1-3 capitalised words that look like proper nouns
    final namePattern = RegExp(r'\b([A-Z][a-z]{2,})(?:\s[A-Z][a-z]+)?\b');

    // Common words that are capitalised but are not names
    const stopWords = {
      'The', 'A', 'An', 'In', 'On', 'At', 'To', 'For', 'Of', 'And', 'But',
      'Or', 'Nor', 'So', 'Yet', 'With', 'From', 'Into', 'Through', 'During',
      'Before', 'After', 'Above', 'Below', 'Between', 'Under', 'Fantasy',
      'Suddenly', 'Meanwhile', 'However', 'Therefore', 'Although', 'Because',
    };

    final allText = scenes.join(' ');
    final found = namePattern
        .allMatches(allText)
        .map((m) => m.group(0)!.trim())
        .where((name) => !stopWords.contains(name))
        .toSet();

    return {...existing, ...found}.take(20).toList()..sort();
  }

  /// Extracts open narrative threads by looking for sentence patterns that
  /// suggest unresolved tension. Merges with threads already in [worldState].
  List<String> _extractThreads(
      List<String> scenes, Map<String, dynamic> worldState) {
    final existing =
        (worldState['_threads'] as List<dynamic>?)?.cast<String>() ?? [];

    if (scenes.isEmpty) return existing;

    // Use the most recent scene only to detect new threads
    final latestScene = scenes.last;

    final threadPatterns = [
      RegExp(r'(?:must|needs? to|has? to|will have to)\s+(.{10,60}?)[\.,!?]',
          caseSensitive: false),
      RegExp(r'(?:promised|vowed|swore)\s+(?:to\s+)?(.{10,60}?)[\.,!?]',
          caseSensitive: false),
      RegExp(r'(?:searching for|looking for|hunting)\s+(.{10,60}?)[\.,!?]',
          caseSensitive: false),
      RegExp(r'(?:danger|threat|enemy|pursuing)\s+(.{10,40}?)[\.,!?]',
          caseSensitive: false),
    ];

    final newThreads = <String>{};
    for (final pattern in threadPatterns) {
      for (final match in pattern.allMatches(latestScene)) {
        final thread = match.group(1)?.trim();
        if (thread != null && thread.length > 8) {
          newThreads.add(thread);
        }
      }
    }

    // Keep list bounded to the 10 most recent threads
    final merged = [...existing, ...newThreads];
    return merged.length > 10
        ? merged.sublist(merged.length - 10)
        : merged;
  }
}
