import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/session_zero_provider.dart';

class TwistsStep extends ConsumerWidget {
  const TwistsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionZero = ref.watch(sessionZeroProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Plot Twists', style: TextStyle(fontSize: 24)),
          const Text('Enable unexpected plot developments for more exciting stories.'),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Enable Plot Twists'),
            value: sessionZero.twistsEnabled,
            onChanged: (value) {
              ref.read(sessionZeroProvider.notifier).toggleTwists();
            },
          ),
        ],
      ),
    );
  }
}