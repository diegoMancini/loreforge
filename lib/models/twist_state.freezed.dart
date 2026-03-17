// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'twist_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$twistIdentity<T>(T value) => value;

final _privateTwistConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TwistState {
  List<String> get seeds => throw _privateTwistConstructorUsedError;
  int get twistCount => throw _privateTwistConstructorUsedError;
  int get scenesSinceLastTwist => throw _privateTwistConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateTwistConstructorUsedError;

  /// Create a copy of TwistState with the given fields replaced by non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TwistStateCopyWith<TwistState> get copyWith =>
      throw _privateTwistConstructorUsedError;
}

/// @nodoc
abstract class $TwistStateCopyWith<$Res> {
  factory $TwistStateCopyWith(
          TwistState value, $Res Function(TwistState) then) =
      _$TwistStateCopyWithImpl<$Res, TwistState>;
  @useResult
  $Res call({
    List<String> seeds,
    int twistCount,
    int scenesSinceLastTwist,
  });
}

/// @nodoc
class _$TwistStateCopyWithImpl<$Res, $Val extends TwistState>
    implements $TwistStateCopyWith<$Res> {
  _$TwistStateCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seeds = null,
    Object? twistCount = null,
    Object? scenesSinceLastTwist = null,
  }) {
    return _then(_value.copyWith(
      seeds: null == seeds ? _value.seeds : seeds as List<String>,
      twistCount: null == twistCount ? _value.twistCount : twistCount as int,
      scenesSinceLastTwist: null == scenesSinceLastTwist
          ? _value.scenesSinceLastTwist
          : scenesSinceLastTwist as int,
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
  $Res call({
    List<String> seeds,
    int twistCount,
    int scenesSinceLastTwist,
  });
}

/// @nodoc
class __$$TwistStateImplCopyWithImpl<$Res>
    extends _$TwistStateCopyWithImpl<$Res, _$TwistStateImpl>
    implements _$$TwistStateImplCopyWith<$Res> {
  __$$TwistStateImplCopyWithImpl(
      _$TwistStateImpl _value, $Res Function(_$TwistStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seeds = null,
    Object? twistCount = null,
    Object? scenesSinceLastTwist = null,
  }) {
    return _then(_$TwistStateImpl(
      seeds: null == seeds ? _value._seeds : seeds as List<String>,
      twistCount:
          null == twistCount ? _value.twistCount : twistCount as int,
      scenesSinceLastTwist: null == scenesSinceLastTwist
          ? _value.scenesSinceLastTwist
          : scenesSinceLastTwist as int,
    ));
  }
}

/// @nodoc
class _$TwistStateImpl implements _TwistState {
  const _$TwistStateImpl({
    required final List<String> seeds,
    required this.twistCount,
    required this.scenesSinceLastTwist,
  }) : _seeds = seeds;

  final List<String> _seeds;

  @override
  List<String> get seeds {
    if (_seeds is EqualUnmodifiableListView) return _seeds;
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

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_seeds),
      twistCount,
      scenesSinceLastTwist);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TwistStateImplCopyWith<_$TwistStateImpl> get copyWith =>
      __$$TwistStateImplCopyWithImpl<_$TwistStateImpl>(
          this, _$twistIdentity);

  @override
  Map<String, dynamic> toJson() {
    return _$TwistStateToJson(this);
  }
}

abstract class _TwistState implements TwistState {
  const factory _TwistState({
    required final List<String> seeds,
    required final int twistCount,
    required final int scenesSinceLastTwist,
  }) = _$TwistStateImpl;

  @override
  List<String> get seeds;
  @override
  int get twistCount;
  @override
  int get scenesSinceLastTwist;

  @override
  Map<String, dynamic> toJson();

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TwistStateImplCopyWith<_$TwistStateImpl> get copyWith =>
      throw _privateTwistConstructorUsedError;
}
