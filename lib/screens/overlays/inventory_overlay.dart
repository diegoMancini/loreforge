import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/story_provider.dart';

class InventoryOverlay extends ConsumerWidget {
  const InventoryOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyProvider);
    final rpgState = storyState.rpgState;

    if (rpgState == null) return const SizedBox.shrink();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        constraints: const BoxConstraints(maxHeight: 400),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Inventory',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (rpgState.inventory.isEmpty)
              const Text('Your inventory is empty.', style: TextStyle(fontStyle: FontStyle.italic))
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: rpgState.inventory.length,
                  itemBuilder: (context, index) {
                    final item = rpgState.inventory[index];
                    return ListTile(
                      leading: const Icon(Icons.inventory),
                      title: Text(item),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // TODO: Implement remove item
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}