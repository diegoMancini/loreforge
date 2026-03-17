// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoryStateImpl _$$StoryStateImplFromJson(Map<String, dynamic> json) =>
    _$StoryStateImpl(
      genre: json['genre'] as String,
      scenes:
          (json['scenes'] as List<dynamic>).map((e) => e as String).toList(),
      choices:
          (json['choices'] as List<dynamic>).map((e) => e as String).toList(),
      worldState: json['worldState'] as Map<String, dynamic>,
      twistState:
          TwistState.fromJson(json['twistState'] as Map<String, dynamic>),
      mode: json['mode'] as String,
      rpgState: json['rpgState'] == null
          ? null
          : RPGState.fromJson(json['rpgState'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$StoryStateImplToJson(_$StoryStateImpl instance) =>
    <String, dynamic>{
      'genre': instance.genre,
      'scenes': instance.scenes,
      'choices': instance.choices,
      'worldState': instance.worldState,
      'twistState': instance.twistState,
      'mode': instance.mode,
      'rpgState': instance.rpgState,
    };
