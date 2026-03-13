import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_zero.freezed.dart';
part 'session_zero.g.dart';

@freezed
class SessionZero with _$SessionZero {
  const factory SessionZero({
    required String language,
    required String mode, // 'pure_story' or 'rpg'
    required String setupMethod, // 'prompt' or 'questions'
    required String genre,
    required String tone,
    required List<String> favoriteStories,
    required bool twistsEnabled,
  }) = _SessionZero;

  factory SessionZero.initial() => const SessionZero(
        language: 'en',
        mode: 'pure_story',
        setupMethod: 'questions',
        genre: 'Fantasy',
        tone: 'epic',
        favoriteStories: [],
        twistsEnabled: true,
      );

  factory SessionZero.fromJson(Map<String, dynamic> json) => _$SessionZeroFromJson(json);
}