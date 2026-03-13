// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryState _$StoryStateFromJson(Map<String, dynamic> json) => StoryState(
      currentScene: json['currentScene'] as String,
      previousScenes: (json['previousScenes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      inventory: (json['inventory'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      score: json['score'] as int,
      genre: json['genre'] as String,
      twist: json['twist'] as String,
      rpgState: RPGState.fromJson(json['rpgState'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoryStateToJson(StoryState instance) =>
    <String, dynamic>{
      'currentScene': instance.currentScene,
      'previousScenes': instance.previousScenes,
      'inventory': instance.inventory,
      'score': instance.score,
      'genre': instance.genre,
      'twist': instance.twist,
      'rpgState': instance.rpgState.toJson(),
    };