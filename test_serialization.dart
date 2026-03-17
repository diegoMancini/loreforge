import 'package:loreforge/models/story_state.dart';
import 'package:loreforge/models/session_zero.dart';
import 'package:loreforge/models/rpg_state.dart';
import 'package:loreforge/models/twist_state.dart';

/// Manual serialization smoke-test — run with `dart run test_serialization.dart`.
///
/// Not part of the automated test suite; this file verifies JSON round-trips
/// work for the core data models without requiring a full Flutter test harness.
void main() {
  // Build initial objects
  final rpgState = RPGState.initial();
  final storyState = StoryState.initial().copyWith(
    genre: 'fantasy',
    rpgState: rpgState,
  );
  final sessionZero = SessionZero.initial().copyWith(
    genre: 'fantasy',
    tone: 'epic',
  );
  final twistState = TwistState.initial().copyWith(
    seeds: ['betrayal', 'hidden identity'],
    twistCount: 1,
  );

  // Test serialization
  final storyJson = storyState.toJson();
  final sessionJson = sessionZero.toJson();
  final twistJson = twistState.toJson();

  print('Story JSON: $storyJson');
  print('Session JSON: $sessionJson');
  print('Twist JSON: $twistJson');

  // Test deserialization
  final storyFromJson = StoryState.fromJson(storyJson);
  final sessionFromJson = SessionZero.fromJson(sessionJson);
  final twistFromJson = TwistState.fromJson(twistJson);

  print('Deserialized story genre: ${storyFromJson.genre}');
  print('Deserialized session genre: ${sessionFromJson.genre}');
  print('Deserialized twist count: ${twistFromJson.twistCount}');
  print('Deserialized twist seeds: ${twistFromJson.seeds}');

  print('JSON serialization test passed!');
}
