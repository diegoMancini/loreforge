import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/session_zero_provider.dart';

class LanguageStep extends ConsumerWidget {
  const LanguageStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionZero = ref.watch(sessionZeroProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose Language', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: sessionZero.language,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'es', child: Text('Español')),
              // Add more languages
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(sessionZeroProvider.notifier).updateLanguage(value);
              }
            },
          ),
        ],
      ),
    );
  }
}