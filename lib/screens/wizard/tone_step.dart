import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/session_zero_provider.dart';

class ToneStep extends ConsumerWidget {
  const ToneStep({super.key});

  static const List<String> tones = [
    'Lighthearted',
    'Epic',
    'Dark',
    'Humorous',
    'Romantic',
    'Gritty',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionZero = ref.watch(sessionZero_provider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose Tone', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: tones.map((tone) => ChoiceChip(
              label: Text(tone),
              selected: sessionZero.tone == tone,
              onSelected: (selected) {
                if (selected) {
                  ref.read(sessionZeroProvider.notifier).updateTone(tone);
                }
              },
            )).toList(),
          ),
        ],
      ),
    );
  }
}