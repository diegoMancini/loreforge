// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'twist_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TwistState _$TwistStateFromJson(Map<String, dynamic> json) {
  return _TwistState.fromJson(json);
}

/// @nodoc
mixin _$TwistState {
  List<String> get seeds => throw _privateConstructorUsedError;
  int get twistCount => throw _privateConstructorUsedError;
  int get scenesSinceLastTwist => throw _privateConstructorUsedError;

  /// Serializes this TwistState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TwistState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TwistStateCopyWith<TwistState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TwistStateCopyWith<$Res> {
  factory $TwistStateCopyWith(
          TwistState value, $Res Function(TwistState) then) =
      _$TwistStateCopyWithImpl<$Res, TwistState>;
  @useResult
  $Res call({List<String> seeds, int twistCount, int scenesSinceLastTwist});
}

/// @nodoc
class _$TwistStateCopyWithImpl<$Res, $Val extends TwistState>
    implements $TwistStateCopyWith<$Res> {
  _$TwistStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TwistState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seeds = null,
    Object? twistCount = null,
    Object? scenesSinceLastTwist = null,
  }) {
    return _then(_value.copyWith(
      seeds: null == seeds
          ? _value.seeds
          : seeds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      twistCount: null == twistCount
          ? _value.twistCount
          : twistCount // ignore: cast_nullable_to_non_nullable
              as int,
      scenesSinceLastTwist: null == scenesSinceLastTwist
          ? _value.scenesSinceLastTwist
          : scenesSinceLastTwist // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TwistStateImplCopyWith<$Res>
    implements $TwistStateCopyWith<$Res> {
  factory _$$TwistStateImplCopyWith(
          _$TwistStateImpl value, $Res Function(_$TwistStateImpl) then) =
      __$$TwistStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> seeds, int twistCount, int scenesSinceLastTwist});
}

/// @nodoc
class __$$TwistStateImplCopyWithImpl<$Res>
    extends _$TwistStateCopyWithImpl<$Res, _$TwistStateImpl>
    implements _$$TwistStateImplCopyWith<$Res> {
  __$$TwistStateImplCopyWithImpl(
      _$TwistStateImpl _value, $Res Function(_$TwistStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TwistState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seeds = null,
    Object? twistCount = null,
    Object? scenesSinceLastTwist = null,
  }) {
    return _then(_$TwistStateImpl(
      seeds: null == seeds
          ? _value._seeds
          : seeds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      twistCount: null == twistCount
          ? _value.twistCount
          : twistCount // ignore: cast_nullable_to_non_nullable
              as int,
      scenesSinceLastTwist: null == scenesSinceLastTwist
          ? _value.scenesSinceLastTwist
          : scenesSinceLastTwist // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TwistStateImpl implements _TwistState {
  const _$TwistStateImpl(
      {required final List<String> seeds,
      required this.twistCount,
      required this.scenesSinceLastTwist})
      : _seeds = seeds;

  factory _$TwistStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TwistStateImplFromJson(json);

  final List<String> _seeds;
  @override
  List<String> get seeds {
    if (_seeds is EqualUnmodifiableListView) return _seeds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_seeds);
  }

  @override
  final int twistCount;
  @override
  final int scenesSinceLastTwist;

  @override
  String toString() {
    return 'TwistState(seeds: $seeds, twistCount: $twistCount, scenesSinceLastTwist: $scenesSinceLastTwist)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TwistStateImpl &&
            const DeepCollectionEquality().equals(other._seeds, _seeds) &&
            (identical(other.twistCount, twistCount) ||
                other.twistCount == twistCount) &&
            (identical(other.scenesSinceLastTwist, scenesSinceLastTwist) ||
                other.scenesSinceLastTwist == scenesSinceLastTwist));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_seeds),
      twistCount,
      scenesSinceLastTwist);

  /// Create a copy of TwistState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TwistStateImplCopyWith<_$TwistStateImpl> get copyWith =>
      __$$TwistStateImplCopyWithImpl<_$TwistStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TwistStateImplToJson(
      this,
    );
  }
}

abstract class _TwistState implements TwistState {
  const factory _TwistState(
      {required final List<String> seeds,
      required final int twistCount,
      required final int scenesSinceLastTwist}) = _$TwistStateImpl;

  factory _TwistState.fromJson(Map<String, dynamic> json) =
      _$TwistStateImpl.fromJson;

  @override
  List<String> get seeds;
  @override
  int get twistCount;
  @override
  int get scenesSinceLastTwist;

  /// Create a copy of TwistState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TwistStateImplCopyWith<_$TwistStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
