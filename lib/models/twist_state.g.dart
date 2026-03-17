// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twist_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TwistStateImpl _$$TwistStateImplFromJson(Map<String, dynamic> json) =>
    _$TwistStateImpl(
      seeds: (json['seeds'] as List<dynamic>).map((e) => e as String).toList(),
      twistCount: (json['twistCount'] as num).toInt(),
      scenesSinceLastTwist: (json['scenesSinceLastTwist'] as num).toInt(),
    );

Map<String, dynamic> _$$TwistStateImplToJson(_$TwistStateImpl instance) =>
    <String, dynamic>{
      'seeds': instance.seeds,
      'twistCount': instance.twistCount,
      'scenesSinceLastTwist': instance.scenesSinceLastTwist,
    };
