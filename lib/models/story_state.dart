import 'package:freezed_annotation/freezed_annotation.dart';
import 'twist_state.dart';
import 'rpg_state.dart';
import 'story_blueprint.dart';

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
    @Default('') String storySummary,
    @Default([]) List<String> activeCharacters,
    @Default([]) List<String> activeThreads,
    RPGState? rpgState,
    StoryBlueprint? blueprint,
  }) = _StoryState;

  factory StoryState.initial() => StoryState(
        genre: 'Fantasy',
        scenes: [],
        choices: [],
        worldState: {},
        twistState: TwistState.initial(),
        mode: 'pure_story',
        rpgState: null,
        storySummary: '',
        activeCharacters: [],
        activeThreads: [],
      );

  factory StoryState.fromJson(Map<String, dynamic> json) =>
      _$StoryStateFromJson(json);

  const StoryState._();

  StoryState withChoice(String choice) => copyWith(
        choices: [...choices, choice],
      );
}
