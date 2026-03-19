// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_zero.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionZeroImpl _$$SessionZeroImplFromJson(Map<String, dynamic> json) =>
    _$SessionZeroImpl(
      language: json['language'] as String,
      mode: json['mode'] as String,
      setupMethod: json['setupMethod'] as String,
      genre: json['genre'] as String,
      subgenre: json['subgenre'] as String,
      tone: json['tone'] as String,
      favoriteStories: (json['favoriteStories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      mediaInspiration: (json['mediaInspiration'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      customPrompt: json['customPrompt'] as String,
      twistsEnabled: json['twistsEnabled'] as bool,
    );

Map<String, dynamic> _$$SessionZeroImplToJson(_$SessionZeroImpl instance) =>
    <String, dynamic>{
      'language': instance.language,
      'mode': instance.mode,
      'setupMethod': instance.setupMethod,
      'genre': instance.genre,
      'subgenre': instance.subgenre,
      'tone': instance.tone,
      'favoriteStories': instance.favoriteStories,
      'mediaInspiration': instance.mediaInspiration,
      'customPrompt': instance.customPrompt,
      'twistsEnabled': instance.twistsEnabled,
    };
