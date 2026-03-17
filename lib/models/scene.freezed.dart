// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scene.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Scene {
  String get narrative => throw _privateConstructorUsedError;
  List<String> get choices => throw _privateConstructorUsedError;
  String? get background => throw _privateConstructorUsedError;
  List<String>? get sprites => throw _privateConstructorUsedError;

  /// Create a copy of Scene
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SceneCopyWith<Scene> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SceneCopyWith<$Res> {
  factory $SceneCopyWith(Scene value, $Res Function(Scene) then) =
      _$SceneCopyWithImpl<$Res, Scene>;
  @useResult
  $Res call(
      {String narrative,
      List<String> choices,
      String? background,
      List<String>? sprites});
}

/// @nodoc
class _$SceneCopyWithImpl<$Res, $Val extends Scene>
    implements $SceneCopyWith<$Res> {
  _$SceneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Scene
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? narrative = null,
    Object? choices = null,
    Object? background = freezed,
    Object? sprites = freezed,
  }) {
    return _then(_value.copyWith(
      narrative: null == narrative
          ? _value.narrative
          : narrative // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _value.choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      background: freezed == background
          ? _value.background
          : background // ignore: cast_nullable_to_non_nullable
              as String?,
      sprites: freezed == sprites
          ? _value.sprites
          : sprites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SceneImplCopyWith<$Res> implements $SceneCopyWith<$Res> {
  factory _$$SceneImplCopyWith(
          _$SceneImpl value, $Res Function(_$SceneImpl) then) =
      __$$SceneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String narrative,
      List<String> choices,
      String? background,
      List<String>? sprites});
}

/// @nodoc
class __$$SceneImplCopyWithImpl<$Res>
    extends _$SceneCopyWithImpl<$Res, _$SceneImpl>
    implements _$$SceneImplCopyWith<$Res> {
  __$$SceneImplCopyWithImpl(
      _$SceneImpl _value, $Res Function(_$SceneImpl) _then)
      : super(_value, _then);

  /// Create a copy of Scene
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? narrative = null,
    Object? choices = null,
    Object? background = freezed,
    Object? sprites = freezed,
  }) {
    return _then(_$SceneImpl(
      narrative: null == narrative
          ? _value.narrative
          : narrative // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _value._choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      background: freezed == background
          ? _value.background
          : background // ignore: cast_nullable_to_non_nullable
              as String?,
      sprites: freezed == sprites
          ? _value._sprites
          : sprites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

class _$SceneImpl implements _Scene {
  const _$SceneImpl(
      {required this.narrative,
      required final List<String> choices,
      this.background,
      final List<String>? sprites})
      : _choices = choices,
        _sprites = sprites;

  @override
  final String narrative;
  final List<String> _choices;
  @override
  List<String> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  final String? background;
  final List<String>? _sprites;
  @override
  List<String>? get sprites {
    final value = _sprites;
    if (value == null) return null;
    if (_sprites is EqualUnmodifiableListView) return _sprites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Scene(narrative: $narrative, choices: $choices, background: $background, sprites: $sprites)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SceneImpl &&
            (identical(other.narrative, narrative) ||
                other.narrative == narrative) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            (identical(other.background, background) ||
                other.background == background) &&
            const DeepCollectionEquality().equals(other._sprites, _sprites));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      narrative,
      const DeepCollectionEquality().hash(_choices),
      background,
      const DeepCollectionEquality().hash(_sprites));

  /// Create a copy of Scene
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SceneImplCopyWith<_$SceneImpl> get copyWith =>
      __$$SceneImplCopyWithImpl<_$SceneImpl>(this, _$identity);
}

abstract class _Scene implements Scene {
  const factory _Scene(
      {required final String narrative,
      required final List<String> choices,
      final String? background,
      final List<String>? sprites}) = _$SceneImpl;

  @override
  String get narrative;
  @override
  List<String> get choices;
  @override
  String? get background;
  @override
  List<String>? get sprites;

  /// Create a copy of Scene
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SceneImplCopyWith<_$SceneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
