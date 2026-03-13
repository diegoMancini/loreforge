import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/story_provider.dart';

class InventoryOverlay extends ConsumerWidget {
  const InventoryOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyProvider);

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
                  'Inventory',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (storyState.rpgState?.inventory.isEmpty ?? true)
              const Text('Your inventory is empty.', style: TextStyle(fontSize: 16))
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: storyState.rpgState!.inventory.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('• $item', style: const TextStyle(fontSize: 16)),
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }
}