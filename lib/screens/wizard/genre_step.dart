import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/session_zero_provider.dart';

class GenreStep extends ConsumerWidget {
  const GenreStep({super.key});

  static const List<String> genres = [
    'Fantasy',
    'Horror',
    'Mystery',
    'Sci-Fi',
    'Romance',
    'Thriller',
    'War',
    'Business',
    'Political',
    'Sports',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionZero = ref.watch(sessionZeroProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose Genre', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: genres.map((genre) => ChoiceChip(
              label: Text(genre),
              selected: sessionZero.genre == genre,
              onSelected: (selected) {
                if (selected) {
                  ref.read(sessionZeroProvider.notifier).updateGenre(genre);
                }
              },
            )).toList(),
          ),
        ],
      ),
    );
  }
}