// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpg_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPGState _$RPGStateFromJson(Map<String, dynamic> json) => RPGState(
      strength: json['strength'] as int,
      agility: json['agility'] as int,
      intelligence: json['intelligence'] as int,
      charisma: json['charisma'] as int,
      perception: json['perception'] as int,
      willpower: json['willpower'] as int,
      inventory: (json['inventory'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      score: json['score'] as int,
    );

Map<String, dynamic> _$RPGStateToJson(RPGState instance) => <String, dynamic>{
      'strength': instance.strength,
      'agility': instance.agility,
      'intelligence': instance.intelligence,
      'charisma': instance.charisma,
      'perception': instance.perception,
      'willpower': instance.willpower,
      'inventory': instance.inventory,
      'score': instance.score,
    };