// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpg_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RPGStateImpl _$$RPGStateImplFromJson(Map<String, dynamic> json) =>
    _$RPGStateImpl(
      strength: (json['strength'] as num).toInt(),
      agility: (json['agility'] as num).toInt(),
      intelligence: (json['intelligence'] as num).toInt(),
      charisma: (json['charisma'] as num).toInt(),
      perception: (json['perception'] as num).toInt(),
      willpower: (json['willpower'] as num).toInt(),
      inventory:
          (json['inventory'] as List<dynamic>).map((e) => e as String).toList(),
      score: (json['score'] as num).toInt(),
    );

Map<String, dynamic> _$$RPGStateImplToJson(_$RPGStateImpl instance) =>
    <String, dynamic>{
      'strength': instance.strength,
      'agility': instance.agility,
      'intelligence': instance.intelligence,
      'charisma': instance.charisma,
      'perception': instance.perception,
      'willpower': instance.willpower,
      'inventory': instance.inventory,
      'score': instance.score,
    };
