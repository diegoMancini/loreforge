import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/session_zero_provider.dart';
import 'language_step.dart';
import 'mode_step.dart';
import 'setup_method_step.dart';
import 'genre_step.dart';
import 'tone_step.dart';
import 'favorite_stories_step.dart';
import 'twists_step.dart';

class SessionZeroWizard extends ConsumerStatefulWidget {
  const SessionZeroWizard({super.key});

  @override
  ConsumerState<SessionZeroWizard> createState() => _SessionZeroWizardState();
}

class _SessionZeroWizardState extends ConsumerState<SessionZeroWizard> {
  int _currentStep = 0;

  final List<Widget> _steps = const [
    LanguageStep(),
    ModeStep(),
    SetupMethodStep(),
    GenreStep(),
    ToneStep(),
    FavoriteStoriesStep(),
    TwistsStep(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session Zero')),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_currentStep + 1) / _steps.length),
          Expanded(child: _steps[_currentStep]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                ElevatedButton(
                  onPressed: () => setState(() => _currentStep--),
                  child: const Text('Back'),
                ),
              ElevatedButton(
                onPressed: _currentStep < _steps.length - 1
                    ? () => setState(() => _currentStep++)
                    : _completeWizard,
                child: Text(_currentStep < _steps.length - 1 ? 'Next' : 'Start Adventure'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _completeWizard() {
    ref.read(sessionZeroProvider.notifier).complete();
    // Navigate to gameplay
    Navigator.of(context).pushReplacementNamed('/gameplay');
  }
}