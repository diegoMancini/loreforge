import 'package:freezed_annotation/freezed_annotation.dart';
import 'twist_state.dart';
import 'rpg_state.dart';

part 'story_state.freezed.dart';
part 'story_state.g.dart';

@freezed
class StoryState with _$StoryState {
  const factory StoryState({
    required String genre,
    required List<String> scenes,
    required List<String> choices,
    required Map<String, dynamic> worldState,
    required TwistState twistState,
    required String mode,
    RPGState? rpgState,
  }) = _StoryState;

  factory StoryState.initial() => StoryState(
        genre: 'Fantasy',
        scenes: [],
        choices: [],
        worldState: {},
        twistState: TwistState.initial(),
        mode: 'pure_story',
        rpgState: null,
      );

  factory StoryState.fromJson(Map<String, dynamic> json) => _$StoryStateFromJson(json);

  const StoryState._();

  StoryState withChoice(String choice) => copyWith(
        choices: [...choices, choice],
      );
}