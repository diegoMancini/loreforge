// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$storyIdentity<T>(T value) => value;

final _privateStoryConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StoryState {
  String get genre => throw _privateStoryConstructorUsedError;
  List<String> get scenes => throw _privateStoryConstructorUsedError;
  List<String> get choices => throw _privateStoryConstructorUsedError;
  Map<String, dynamic> get worldState =>
      throw _privateStoryConstructorUsedError;
  TwistState get twistState => throw _privateStoryConstructorUsedError;
  String get mode => throw _privateStoryConstructorUsedError;
  RPGState? get rpgState => throw _privateStoryConstructorUsedError;
  String get storySummary => throw _privateStoryConstructorUsedError;
  List<String> get activeCharacters => throw _privateStoryConstructorUsedError;
  List<String> get activeThreads => throw _privateStoryConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateStoryConstructorUsedError;

  /// Create a copy of StoryState with the given fields replaced by non-null
  /// parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryStateCopyWith<StoryState> get copyWith =>
      throw _privateStoryConstructorUsedError;
}

/// @nodoc
abstract class $StoryStateCopyWith<$Res> {
  factory $StoryStateCopyWith(
          StoryState value, $Res Function(StoryState) then) =
      _$StoryStateCopyWithImpl<$Res, StoryState>;
  @useResult
  $Res call({
    String genre,
    List<String> scenes,
    List<String> choices,
    Map<String, dynamic> worldState,
    TwistState twistState,
    String mode,
    RPGState? rpgState,
    String storySummary,
    List<String> activeCharacters,
    List<String> activeThreads,
  });

  $TwistStateCopyWith<$Res> get twistState;
  $RPGStateCopyWith<$Res>? get rpgState;
}

/// @nodoc
class _$StoryStateCopyWithImpl<$Res, $Val extends StoryState>
    implements $StoryStateCopyWith<$Res> {
  _$StoryStateCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? genre = null,
    Object? scenes = null,
    Object? choices = null,
    Object? worldState = null,
    Object? twistState = null,
    Object? mode = null,
    Object? rpgState = freezed,
    Object? storySummary = null,
    Object? activeCharacters = null,
    Object? activeThreads = null,
  }) {
    return _then(_value.copyWith(
      genre: null == genre ? _value.genre : genre as String,
      scenes: null == scenes ? _value.scenes : scenes as List<String>,
      choices: null == choices ? _value.choices : choices as List<String>,
      worldState: null == worldState
          ? _value.worldState
          : worldState as Map<String, dynamic>,
      twistState: null == twistState
          ? _value.twistState
          : twistState as TwistState,
      mode: null == mode ? _value.mode : mode as String,
      rpgState:
          freezed == rpgState ? _value.rpgState : rpgState as RPGState?,
      storySummary: null == storySummary
          ? _value.storySummary
          : storySummary as String,
      activeCharacters: null == activeCharacters
          ? _value.activeCharacters
          : activeCharacters as List<String>,
      activeThreads: null == activeThreads
          ? _value.activeThreads
          : activeThreads as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TwistStateCopyWith<$Res> get twistState {
    return $TwistStateCopyWith<$Res>(_value.twistState, (value) {
      return _then(_value.copyWith(twistState: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $RPGStateCopyWith<$Res>? get rpgState {
    if (_value.rpgState == null) {
      return null;
    }
    return $RPGStateCopyWith<$Res>(_value.rpgState!, (value) {
      return _then(_value.copyWith(rpgState: value) as $Val);
    });
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
  $Res call({
    String genre,
    List<String> scenes,
    List<String> choices,
    Map<String, dynamic> worldState,
    TwistState twistState,
    String mode,
    RPGState? rpgState,
    String storySummary,
    List<String> activeCharacters,
    List<String> activeThreads,
  });

  @override
  $TwistStateCopyWith<$Res> get twistState;
  @override
  $RPGStateCopyWith<$Res>? get rpgState;
}

/// @nodoc
class __$$StoryStateImplCopyWithImpl<$Res>
    extends _$StoryStateCopyWithImpl<$Res, _$StoryStateImpl>
    implements _$$StoryStateImplCopyWith<$Res> {
  __$$StoryStateImplCopyWithImpl(
      _$StoryStateImpl _value, $Res Function(_$StoryStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? genre = null,
    Object? scenes = null,
    Object? choices = null,
    Object? worldState = null,
    Object? twistState = null,
    Object? mode = null,
    Object? rpgState = freezed,
    Object? storySummary = null,
    Object? activeCharacters = null,
    Object? activeThreads = null,
  }) {
    return _then(_$StoryStateImpl(
      genre: null == genre ? _value.genre : genre as String,
      scenes: null == scenes ? _value._scenes : scenes as List<String>,
      choices: null == choices ? _value._choices : choices as List<String>,
      worldState: null == worldState
          ? _value._worldState
          : worldState as Map<String, dynamic>,
      twistState: null == twistState
          ? _value.twistState
          : twistState as TwistState,
      mode: null == mode ? _value.mode : mode as String,
      rpgState:
          freezed == rpgState ? _value.rpgState : rpgState as RPGState?,
      storySummary: null == storySummary
          ? _value.storySummary
          : storySummary as String,
      activeCharacters: null == activeCharacters
          ? _value._activeCharacters
          : activeCharacters as List<String>,
      activeThreads: null == activeThreads
          ? _value._activeThreads
          : activeThreads as List<String>,
    ));
  }
}

/// @nodoc
class _$StoryStateImpl extends _StoryState {
  const _$StoryStateImpl({
    required this.genre,
    required final List<String> scenes,
    required final List<String> choices,
    required final Map<String, dynamic> worldState,
    required this.twistState,
    required this.mode,
    this.rpgState,
    this.storySummary = '',
    final List<String> activeCharacters = const [],
    final List<String> activeThreads = const [],
  })  : _scenes = scenes,
        _choices = choices,
        _worldState = worldState,
        _activeCharacters = activeCharacters,
        _activeThreads = activeThreads,
        super._();

  @override
  final String genre;

  final List<String> _scenes;

  @override
  List<String> get scenes {
    if (_scenes is EqualUnmodifiableListView) return _scenes;
    return EqualUnmodifiableListView(_scenes);
  }

  final List<String> _choices;

  @override
  List<String> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    return EqualUnmodifiableListView(_choices);
  }

  final Map<String, dynamic> _worldState;

  @override
  Map<String, dynamic> get worldState {
    if (_worldState is EqualUnmodifiableMapView) return _worldState;
    return EqualUnmodifiableMapView(_worldState);
  }

  @override
  final TwistState twistState;

  @override
  final String mode;

  @override
  final RPGState? rpgState;

  @override
  final String storySummary;

  final List<String> _activeCharacters;

  @override
  List<String> get activeCharacters {
    if (_activeCharacters is EqualUnmodifiableListView)
      return _activeCharacters;
    return EqualUnmodifiableListView(_activeCharacters);
  }

  final List<String> _activeThreads;

  @override
  List<String> get activeThreads {
    if (_activeThreads is EqualUnmodifiableListView) return _activeThreads;
    return EqualUnmodifiableListView(_activeThreads);
  }

  @override
  String toString() {
    return 'StoryState(genre: $genre, scenes: $scenes, choices: $choices, worldState: $worldState, twistState: $twistState, mode: $mode, rpgState: $rpgState, storySummary: $storySummary, activeCharacters: $activeCharacters, activeThreads: $activeThreads)';
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
                .equals(other._worldState, _worldState) &&
            (identical(other.twistState, twistState) ||
                other.twistState == twistState) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.rpgState, rpgState) ||
                other.rpgState == rpgState) &&
            (identical(other.storySummary, storySummary) ||
                other.storySummary == storySummary) &&
            const DeepCollectionEquality()
                .equals(other._activeCharacters, _activeCharacters) &&
            const DeepCollectionEquality()
                .equals(other._activeThreads, _activeThreads));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      genre,
      const DeepCollectionEquality().hash(_scenes),
      const DeepCollectionEquality().hash(_choices),
      const DeepCollectionEquality().hash(_worldState),
      twistState,
      mode,
      rpgState,
      storySummary,
      const DeepCollectionEquality().hash(_activeCharacters),
      const DeepCollectionEquality().hash(_activeThreads));

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryStateImplCopyWith<_$StoryStateImpl> get copyWith =>
      __$$StoryStateImplCopyWithImpl<_$StoryStateImpl>(
          this, _$storyIdentity);

  @override
  Map<String, dynamic> toJson() {
    return _$StoryStateToJson(this);
  }
}

abstract class _StoryState extends StoryState {
  const factory _StoryState({
    required final String genre,
    required final List<String> scenes,
    required final List<String> choices,
    required final Map<String, dynamic> worldState,
    required final TwistState twistState,
    required final String mode,
    final RPGState? rpgState,
    final String storySummary,
    final List<String> activeCharacters,
    final List<String> activeThreads,
  }) = _$StoryStateImpl;
  const _StoryState._() : super._();

  @override
  String get genre;
  @override
  List<String> get scenes;
  @override
  List<String> get choices;
  @override
  Map<String, dynamic> get worldState;
  @override
  TwistState get twistState;
  @override
  String get mode;
  @override
  RPGState? get rpgState;
  @override
  String get storySummary;
  @override
  List<String> get activeCharacters;
  @override
  List<String> get activeThreads;

  @override
  Map<String, dynamic> toJson();

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryStateImplCopyWith<_$StoryStateImpl> get copyWith =>
      throw _privateStoryConstructorUsedError;
}
