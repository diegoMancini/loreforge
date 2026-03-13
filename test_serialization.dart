import 'dart:convert';
import 'package:loreforge/models/story_state.dart';
import 'package:loreforge/models/session_zero.dart';
import 'package:loreforge/models/rpg_state.dart';
import 'package:loreforge/models/twist_state.dart';

void main() {
  // Test JSON serialization
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
    twist: 'betrayal',
    description: 'A trusted ally betrays you',
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
  print('Deserialized twist: ${twistFromJson.twist}');

  print('JSON serialization test passed!');
}