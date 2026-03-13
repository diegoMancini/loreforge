// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_zero.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionZero _$SessionZeroFromJson(Map<String, dynamic> json) => SessionZero(
      playerName: json['playerName'] as String,
      characterName: json['characterName'] as String,
      genre: json['genre'] as String,
      twist: json['twist'] as String,
      difficulty: json['difficulty'] as String,
      tone: json['tone'] as String,
      length: json['length'] as String,
    );

Map<String, dynamic> _$SessionZeroToJson(SessionZero instance) =>
    <String, dynamic>{
      'playerName': instance.playerName,
      'characterName': instance.characterName,
      'genre': instance.genre,
      'twist': instance.twist,
      'difficulty': instance.difficulty,
      'tone': instance.tone,
      'length': instance.length,
    };