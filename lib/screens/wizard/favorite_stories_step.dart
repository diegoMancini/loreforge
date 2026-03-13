import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/session_zero_provider.dart';

class FavoriteStoriesStep extends ConsumerStatefulWidget {
  const FavoriteStoriesStep({super.key});

  @override
  ConsumerState<FavoriteStoriesStep> createState() => _FavoriteStoriesStepState();
}

class _FavoriteStoriesStepState extends ConsumerState<FavoriteStoriesStep> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sessionZero = ref.watch(sessionZeroProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Favorite Stories', style: TextStyle(fontSize: 24)),
          const Text('Tell us about stories you love to help personalize your adventure.'),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Describe a favorite story',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                ref.read(sessionZeroProvider.notifier).addFavoriteStory(_controller.text);
                _controller.clear();
              }
            },
            child: const Text('Add Story'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: sessionZero.favoriteStories.map((story) => Chip(
              label: Text(story),
              onDeleted: () {
                // For simplicity, not implementing remove
              },
            )).toList(),
          ),
        ],
      ),
    );
  }
}