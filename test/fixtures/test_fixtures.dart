import 'dart:async';
import 'dart:convert';

import 'package:loreforge/ai/providers/base_provider.dart';
import 'package:loreforge/models/story_blueprint.dart';
import 'package:loreforge/models/story_state.dart';
import 'package:loreforge/models/twist_state.dart';

// ---------------------------------------------------------------------------
// FakeAIProvider
// ---------------------------------------------------------------------------

/// Test double for [AIProvider].
///
/// Callers set [nextResponse] before invoking a method under test. The
/// [capturedPrompt] property can be inspected after the call to assert on
/// the prompt that was sent to the provider.
class FakeAIProvider implements AIProvider {
  /// The string that [generate] and [generateStream] will return.
  String nextResponse = '';

  /// The last prompt passed to [generate] or [generateStream], or `null` if
  /// no call has been made yet.
  String? capturedPrompt;

  @override
  String get name => 'fake';

  @override
  Future<bool> validateKey() async => true;

  @override
  Future<String> generate(String prompt) async {
    capturedPrompt = prompt;
    return nextResponse;
  }

  /// Streams [nextResponse] word-by-word (splitting on spaces) to mimic token
  /// streaming. Each word has a trailing space to match the real provider.
  @override
  Future<Stream<String>> generateStream(String prompt) async {
    capturedPrompt = prompt;
    final words = nextResponse.split(' ').map((w) => '$w ').toList();
    return Stream.fromIterable(words);
  }
}

// ---------------------------------------------------------------------------
// TestFixtures
// ---------------------------------------------------------------------------

/// Static factory methods for common test objects.
class TestFixtures {
  TestFixtures._();

  /// Returns a minimal [StoryState] suitable for most unit tests.
  static StoryState storyState({
    String genre = 'Fantasy',
    String mode = 'pure_story',
    List<String> scenes = const [],
    List<String> choices = const [],
    Map<String, dynamic>? worldState,
  }) {
    return StoryState(
      genre: genre,
      mode: mode,
      scenes: scenes,
      choices: choices,
      worldState: worldState ?? const {},
      twistState: TwistState.initial(),
    );
  }

  /// Returns a [BlueprintNode] for use in SceneWriter tests.
  static BlueprintNode blueprintNode({
    String type = 'beat',
    String summary = 'A mysterious stranger appears at the tavern.',
    int order = 0,
  }) {
    return BlueprintNode(
      type: type,
      summary: summary,
      order: order,
    );
  }

  /// Returns a valid JSON string for [StoryDirector.planScene] tests.
  ///
  /// Uses the legacy `plot_arc` / `tension` / `active_threads` / `direction`
  /// keys that the test suite asserts on. The director prompt spec uses
  /// camelCase internally, but the test fixtures mirror the response the
  /// AI (or mock) would actually return.
  static String validDirectorJson() {
    return jsonEncode({
      'plot_arc': 'rising',
      'tension': 'medium',
      'active_threads': ['dragon threat'],
      'direction': 'Introduce the mysterious stranger',
    });
  }
}
