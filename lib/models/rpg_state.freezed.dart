// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rpg_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$rpgIdentity<T>(T value) => value;

final _privateRPGConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RPGState {
  int get strength => throw _privateRPGConstructorUsedError;
  int get agility => throw _privateRPGConstructorUsedError;
  int get intelligence => throw _privateRPGConstructorUsedError;
  int get charisma => throw _privateRPGConstructorUsedError;
  int get perception => throw _privateRPGConstructorUsedError;
  int get willpower => throw _privateRPGConstructorUsedError;
  List<String> get inventory => throw _privateRPGConstructorUsedError;
  int get score => throw _privateRPGConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateRPGConstructorUsedError;

  /// Create a copy of RPGState with the given fields replaced by non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RPGStateCopyWith<RPGState> get copyWith =>
      throw _privateRPGConstructorUsedError;
}

/// @nodoc
abstract class $RPGStateCopyWith<$Res> {
  factory $RPGStateCopyWith(RPGState value, $Res Function(RPGState) then) =
      _$RPGStateCopyWithImpl<$Res, RPGState>;
  @useResult
  $Res call({
    int strength,
    int agility,
    int intelligence,
    int charisma,
    int perception,
    int willpower,
    List<String> inventory,
    int score,
  });
}

/// @nodoc
class _$RPGStateCopyWithImpl<$Res, $Val extends RPGState>
    implements $RPGStateCopyWith<$Res> {
  _$RPGStateCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? strength = null,
    Object? agility = null,
    Object? intelligence = null,
    Object? charisma = null,
    Object? perception = null,
    Object? willpower = null,
    Object? inventory = null,
    Object? score = null,
  }) {
    return _then(_value.copyWith(
      strength: null == strength ? _value.strength : strength as int,
      agility: null == agility ? _value.agility : agility as int,
      intelligence:
          null == intelligence ? _value.intelligence : intelligence as int,
      charisma: null == charisma ? _value.charisma : charisma as int,
      perception: null == perception ? _value.perception : perception as int,
      willpower: null == willpower ? _value.willpower : willpower as int,
      inventory: null == inventory
          ? _value.inventory
          : inventory as List<String>,
      score: null == score ? _value.score : score as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RPGStateImplCopyWith<$Res>
    implements $RPGStateCopyWith<$Res> {
  factory _$$RPGStateImplCopyWith(
          _$RPGStateImpl value, $Res Function(_$RPGStateImpl) then) =
      __$$RPGStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int strength,
    int agility,
    int intelligence,
    int charisma,
    int perception,
    int willpower,
    List<String> inventory,
    int score,
  });
}

/// @nodoc
class __$$RPGStateImplCopyWithImpl<$Res>
    extends _$RPGStateCopyWithImpl<$Res, _$RPGStateImpl>
    implements _$$RPGStateImplCopyWith<$Res> {
  __$$RPGStateImplCopyWithImpl(
      _$RPGStateImpl _value, $Res Function(_$RPGStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? strength = null,
    Object? agility = null,
    Object? intelligence = null,
    Object? charisma = null,
    Object? perception = null,
    Object? willpower = null,
    Object? inventory = null,
    Object? score = null,
  }) {
    return _then(_$RPGStateImpl(
      strength: null == strength ? _value.strength : strength as int,
      agility: null == agility ? _value.agility : agility as int,
      intelligence:
          null == intelligence ? _value.intelligence : intelligence as int,
      charisma: null == charisma ? _value.charisma : charisma as int,
      perception: null == perception ? _value.perception : perception as int,
      willpower: null == willpower ? _value.willpower : willpower as int,
      inventory: null == inventory
          ? _value._inventory
          : inventory as List<String>,
      score: null == score ? _value.score : score as int,
    ));
  }
}

/// @nodoc
class _$RPGStateImpl implements _RPGState {
  const _$RPGStateImpl({
    required this.strength,
    required this.agility,
    required this.intelligence,
    required this.charisma,
    required this.perception,
    required this.willpower,
    required final List<String> inventory,
    required this.score,
  }) : _inventory = inventory;

  @override
  final int strength;
  @override
  final int agility;
  @override
  final int intelligence;
  @override
  final int charisma;
  @override
  final int perception;
  @override
  final int willpower;

  final List<String> _inventory;

  @override
  List<String> get inventory {
    if (_inventory is EqualUnmodifiableListView) return _inventory;
    return EqualUnmodifiableListView(_inventory);
  }

  @override
  final int score;

  @override
  String toString() {
    return 'RPGState(strength: $strength, agility: $agility, intelligence: $intelligence, charisma: $charisma, perception: $perception, willpower: $willpower, inventory: $inventory, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RPGStateImpl &&
            (identical(other.strength, strength) ||
                other.strength == strength) &&
            (identical(other.agility, agility) || other.agility == agility) &&
            (identical(other.intelligence, intelligence) ||
                other.intelligence == intelligence) &&
            (identical(other.charisma, charisma) ||
                other.charisma == charisma) &&
            (identical(other.perception, perception) ||
                other.perception == perception) &&
            (identical(other.willpower, willpower) ||
                other.willpower == willpower) &&
            const DeepCollectionEquality()
                .equals(other._inventory, _inventory) &&
            (identical(other.score, score) || other.score == score));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      strength,
      agility,
      intelligence,
      charisma,
      perception,
      willpower,
      const DeepCollectionEquality().hash(_inventory),
      score);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RPGStateImplCopyWith<_$RPGStateImpl> get copyWith =>
      __$$RPGStateImplCopyWithImpl<_$RPGStateImpl>(this, _$rpgIdentity);

  @override
  Map<String, dynamic> toJson() {
    return _$RPGStateToJson(this);
  }
}

abstract class _RPGState implements RPGState {
  const factory _RPGState({
    required final int strength,
    required final int agility,
    required final int intelligence,
    required final int charisma,
    required final int perception,
    required final int willpower,
    required final List<String> inventory,
    required final int score,
  }) = _$RPGStateImpl;

  @override
  int get strength;
  @override
  int get agility;
  @override
  int get intelligence;
  @override
  int get charisma;
  @override
  int get perception;
  @override
  int get willpower;
  @override
  List<String> get inventory;
  @override
  int get score;

  @override
  Map<String, dynamic> toJson();

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RPGStateImplCopyWith<_$RPGStateImpl> get copyWith =>
      throw _privateRPGConstructorUsedError;
}
