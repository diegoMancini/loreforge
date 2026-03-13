import 'package:riverpod/riverpod.dart';
import '../models/scene.dart';

final currentSceneProvider = StateNotifierProvider<SceneNotifier, Scene?>((ref) {
  return SceneNotifier();
});

class SceneNotifier extends StateNotifier<Scene?> {
  SceneNotifier() : super(null);

  void setScene(Scene scene) {
    state = scene;
  }

  void clearScene() {
    state = null;
  }
}