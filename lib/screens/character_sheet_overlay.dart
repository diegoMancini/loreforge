import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/story_provider.dart';

class CharacterSheetOverlay extends ConsumerWidget {
  const CharacterSheetOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyProvider);

    if (storyState.rpgState == null) {
      return const SizedBox.shrink();
    }

    final rpg = storyState.rpgState!;

    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.95),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Character Sheet',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Score: ${rpg.score}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Attributes:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildAttributeRow('Strength', rpg.strength),
            _buildAttributeRow('Agility', rpg.agility),
            _buildAttributeRow('Intelligence', rpg.intelligence),
            _buildAttributeRow('Charisma', rpg.charisma),
            _buildAttributeRow('Perception', rpg.perception),
            _buildAttributeRow('Willpower', rpg.willpower),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeRow(String name, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 16)),
          Text('$value', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}