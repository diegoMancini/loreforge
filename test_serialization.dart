import 'package:loreforge/models/story_state.dart';
import 'package:loreforge/models/session_zero.dart';
import 'package:loreforge/models/rpg_state.dart';
import 'package:loreforge/models/twist_state.dart';

void main() {
  // Test JSON serialization
  final rpgState = RPGState.initial();
  final storyState = StoryState.initial().copyWith(
    genre: 'fantasy',
    mode: 'rpg',
    rpgState: rpgState,
  );
  final sessionZero = SessionZero.initial().copyWith(
    genre: 'fantasy',
    tone: 'epic',
  );
  final twistState = TwistState.initial().copyWith(
    seeds: ['betrayal'],
    twistCount: 1,
  );

  // Test serialization
  final storyJson = storyState.toJson();
  final sessionJson = sessionZero.toJson();
  final twistJson = twistState.toJson();

  // ignore: avoid_print
  print('Story JSON: $storyJson');
  // ignore: avoid_print
  print('Session JSON: $sessionJson');
  // ignore: avoid_print
  print('Twist JSON: $twistJson');

  // Test deserialization
  final storyFromJson = StoryState.fromJson(storyJson);
  final sessionFromJson = SessionZero.fromJson(sessionJson);
  final twistFromJson = TwistState.fromJson(twistJson);

  // ignore: avoid_print
  print('Deserialized story genre: ${storyFromJson.genre}');
  // ignore: avoid_print
  print('Deserialized session genre: ${sessionFromJson.genre}');
  // ignore: avoid_print
  print('Deserialized twist seeds: ${twistFromJson.seeds}');

  // ignore: avoid_print
  print('JSON serialization test passed!');
}
