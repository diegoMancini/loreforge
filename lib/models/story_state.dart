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
    /// Rolling prose summary of story so far — updated by StoryContextManager
    /// after each scene. Replaces raw scene dumps in prompts to control tokens.
    @Default('') String storySummary,
    /// Characters currently active in the narrative thread.
    @Default([]) List<String> activeCharacters,
    /// Unresolved plot threads being tracked by the director.
    @Default([]) List<String> activeThreads,
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
