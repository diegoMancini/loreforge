import 'dart:io';
import 'package:loreforge/ai/ai_client.dart';
import 'package:loreforge/models/story_state.dart';

// CLI DISABLED - This was causing terminal to hang
// Uncomment the main function below to enable CLI mode

/*
void main() async {
  print('Welcome to Loreforge CLI Prototype');

  // Initialize AI client
  final aiClient = AIClient();

  // Simple story loop
  var storyState = StoryState.initial();

  while (true) {
    // Generate scene
    print('\nGenerating scene...');
    final scene = await aiClient.generateScene(storyState);
    print(scene.narrative);

    // Show choices
    print('\nChoices:');
    for (var i = 0; i < scene.choices.length; i++) {
      print('${i + 1}. ${scene.choices[i]}');
    }

    // Get user input
    stdout.write('Choose (1-${scene.choices.length}): ');
    final input = stdin.readLineSync();
    final choiceIndex = int.tryParse(input ?? '') ?? 1;
    final choice = scene.choices[choiceIndex - 1];

    // Update story state
    storyState = storyState.withChoice(choice);
  }
}
*/