// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twist_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwistState _$TwistStateFromJson(Map<String, dynamic> json) => TwistState(
      twist: json['twist'] as String,
      description: json['description'] as String,
      activated: json['activated'] as bool,
    );

Map<String, dynamic> _$TwistStateToJson(TwistState instance) =>
    <String, dynamic>{
      'twist': instance.twist,
      'description': instance.description,
      'activated': instance.activated,
    };