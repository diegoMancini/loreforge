import 'package:freezed_annotation/freezed_annotation.dart';

part 'twist_state.freezed.dart';
part 'twist_state.g.dart';

@freezed
class TwistState with _$TwistState {
  const factory TwistState({
    required List<String> seeds,
    required int twistCount,
    required int scenesSinceLastTwist,
  }) = _TwistState;

  factory TwistState.initial() => const TwistState(
        seeds: [],
        twistCount: 0,
        scenesSinceLastTwist: 0,
      );

  factory TwistState.fromJson(Map<String, dynamic> json) => _$TwistStateFromJson(json);
}