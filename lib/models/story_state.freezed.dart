// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StoryState {
  String get genre => throw _privateConstructorUsedError;
  List<String> get scenes => throw _privateConstructorUsedError;
  List<String> get choices => throw _privateConstructorUsedError;
  Map<String, dynamic> get worldState => throw _privateConstructorUsedError;

  /// Create a copy of StoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryStateCopyWith<StoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryStateCopyWith<$Res> {
  factory $StoryStateCopyWith(
          StoryState value, $Res Function(StoryState) then) =
      _$StoryStateCopyWithImpl<$Res, StoryState>;
  @useResult
  $Res call(
      {String genre,
      List<String> scenes,
      List<String> choices,
      Map<String, dynamic> worldState});
}

/// @nodoc
class _$StoryStateCopyWithImpl<$Res, $Val extends StoryState>
    implements $StoryStateCopyWith<$Res> {
  _$StoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? genre = null,
    Object? scenes = null,
    Object? choices = null,
    Object? worldState = null,
  }) {
    return _then(_value.copyWith(
      genre: null == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      scenes: null == scenes
          ? _value.scenes
          : scenes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      choices: null == choices
          ? _value.choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      worldState: null == worldState
          ? _value.worldState
          : worldState // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryStateImplCopyWith<$Res>
    implements $StoryStateCopyWith<$Res> {
  factory _$$StoryStateImplCopyWith(
          _$StoryStateImpl value, $Res Function(_$StoryStateImpl) then) =
      __$$StoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String genre,
      List<String> scenes,
      List<String> choices,
      Map<String, dynamic> worldState});
}

/// @nodoc
class __$$StoryStateImplCopyWithImpl<$Res>
    extends _$StoryStateCopyWithImpl<$Res, _$StoryStateImpl>
    implements _$$StoryStateImplCopyWith<$Res> {
  __$$StoryStateImplCopyWithImpl(
      _$StoryStateImpl _value, $Res Function(_$StoryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? genre = null,
    Object? scenes = null,
    Object? choices = null,
    Object? worldState = null,
  }) {
    return _then(_$StoryStateImpl(
      genre: null == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      scenes: null == scenes
          ? _value._scenes
          : scenes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      choices: null == choices
          ? _value._choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      worldState: null == worldState
          ? _value._worldState
          : worldState // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$StoryStateImpl extends _StoryState {
  const _$StoryStateImpl(
      {required this.genre,
      required final List<String> scenes,
      required final List<String> choices,
      required final Map<String, dynamic> worldState})
      : _scenes = scenes,
        _choices = choices,
        _worldState = worldState,
        super._();

  @override
  final String genre;
  final List<String> _scenes;
  @override
  List<String> get scenes {
    if (_scenes is EqualUnmodifiableListView) return _scenes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scenes);
  }

  final List<String> _choices;
  @override
  List<String> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  final Map<String, dynamic> _worldState;
  @override
  Map<String, dynamic> get worldState {
    if (_worldState is EqualUnmodifiableMapView) return _worldState;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_worldState);
  }

  @override
  String toString() {
    return 'StoryState(genre: $genre, scenes: $scenes, choices: $choices, worldState: $worldState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryStateImpl &&
            (identical(other.genre, genre) || other.genre == genre) &&
            const DeepCollectionEquality().equals(other._scenes, _scenes) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            const DeepCollectionEquality()
                .equals(other._worldState, _worldState));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      genre,
      const DeepCollectionEquality().hash(_scenes),
      const DeepCollectionEquality().hash(_choices),
      const DeepCollectionEquality().hash(_worldState));

  /// Create a copy of StoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryStateImplCopyWith<_$StoryStateImpl> get copyWith =>
      __$$StoryStateImplCopyWithImpl<_$StoryStateImpl>(this, _$identity);
}

abstract class _StoryState extends StoryState {
  const factory _StoryState(
      {required final String genre,
      required final List<String> scenes,
      required final List<String> choices,
      required final Map<String, dynamic> worldState}) = _$StoryStateImpl;
  const _StoryState._() : super._();

  @override
  String get genre;
  @override
  List<String> get scenes;
  @override
  List<String> get choices;
  @override
  Map<String, dynamic> get worldState;

  /// Create a copy of StoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryStateImplCopyWith<_$StoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
