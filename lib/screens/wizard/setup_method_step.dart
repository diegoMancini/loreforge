import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/session_zero_provider.dart';

class SetupMethodStep extends ConsumerWidget {
  const SetupMethodStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionZero = ref.watch(sessionZeroProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Setup Method', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Questions'),
            subtitle: const Text('Answer questions to customize your story'),
            leading: Radio<String>(
              value: 'questions',
              groupValue: sessionZero.setupMethod,
              onChanged: (value) {
                if (value != null) {
                  ref.read(sessionZeroProvider.notifier).updateSetupMethod(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Prompt'),
            subtitle: const Text('Write a custom prompt'),
            leading: Radio<String>(
              value: 'prompt',
              groupValue: sessionZero.setupMethod,
              onChanged: (value) {
                if (value != null) {
                  ref.read(sessionZeroProvider.notifier).updateSetupMethod(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}