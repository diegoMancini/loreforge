import 'package:freezed_annotation/freezed_annotation.dart';

part 'scene.freezed.dart';

@freezed
class Scene with _$Scene {
  const factory Scene({
    required String narrative,
    required List<String> choices,
    String? background,
    List<String>? sprites,
  }) = _Scene;
}