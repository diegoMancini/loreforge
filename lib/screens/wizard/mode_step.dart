import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/session_zero_provider.dart';

class ModeStep extends ConsumerWidget {
  const ModeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionZero = ref.watch(sessionZeroProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose Mode', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Pure Story'),
            subtitle: const Text('Focus on narrative and choices'),
            leading: Radio<String>(
              value: 'pure_story',
              groupValue: sessionZero.mode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(sessionZeroProvider.notifier).updateMode(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('RPG Adventure'),
            subtitle: const Text('Include stats, skills, and game mechanics'),
            leading: Radio<String>(
              value: 'rpg',
              groupValue: sessionZero.mode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(sessionZeroProvider.notifier).updateMode(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}