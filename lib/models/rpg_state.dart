import 'package:freezed_annotation/freezed_annotation.dart';

part 'rpg_state.freezed.dart';
part 'rpg_state.g.dart';

@freezed
class RPGState with _$RPGState {
  const factory RPGState({
    required int strength,
    required int agility,
    required int intelligence,
    required int charisma,
    required int perception,
    required int willpower,
    required List<String> inventory,
    required int score,
  }) = _RPGState;

  factory RPGState.initial() => const RPGState(
        strength: 10,
        agility: 10,
        intelligence: 10,
        charisma: 10,
        perception: 10,
        willpower: 10,
        inventory: [],
        score: 0,
      );

  factory RPGState.fromJson(Map<String, dynamic> json) => _$RPGStateFromJson(json);
}