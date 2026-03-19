import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ai/ai_client.dart';
import '../../ai/providers/provider_factory.dart';
import '../../providers/session_zero_provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/loreforge_theme.dart';
import '../../widgets/atmosphere_background.dart';
import 'foundations_step.dart';
import 'genre_subgenre_step.dart';
import 'tone_inspiration_step.dart';
import 'story_preferences_step.dart';

// ---------------------------------------------------------------------------
// Step metadata
// ---------------------------------------------------------------------------

class _StepMeta {
  const _StepMeta({required this.title, required this.icon});
  final String title;
  final IconData icon;
}

const _stepMeta = [
  _StepMeta(title: 'Lay the Foundations', icon: Icons.foundation),
  _StepMeta(title: 'Choose Your World', icon: Icons.auto_stories),
  _StepMeta(title: 'Set the Mood', icon: Icons.mood),
  _StepMeta(title: 'Final Touches', icon: Icons.edit_note),
];

// ---------------------------------------------------------------------------
// Wizard
// ---------------------------------------------------------------------------

class SessionZeroWizard extends ConsumerStatefulWidget {
  const SessionZeroWizard({super.key});

  @override
  ConsumerState<SessionZeroWizard> createState() => _SessionZeroWizardState();
}

class _SessionZeroWizardState extends ConsumerState<SessionZeroWizard>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  bool _isGeneratingBlueprint = false;
  bool _goingForward = true;

  late final AnimationController _slideController;

  final List<Widget> _steps = const [
    FoundationsStep(),
    GenreSubgenreStep(),
    ToneInspirationStep(),
    StoryPreferencesStep(),
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Animation<Offset> get _slideAnimation {
    final begin = _goingForward
        ? const Offset(0.06, 0)
        : const Offset(-0.06, 0);
    return Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
  }

  Animation<double> get _fadeAnimation {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );
  }

  void _goNext() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _goingForward = true;
        _currentStep++;
      });
      _slideController.reset();
      _slideController.forward();
    } else {
      final settings = ref.read(settingsProvider);
      if (!settings.hasAnyApiKey) {
        _showApiKeyPrompt();
      } else {
        _completeWizard();
      }
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _goingForward = false;
        _currentStep--;
      });
      _slideController.reset();
      _slideController.forward();
    }
  }

  void _showApiKeyPrompt() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('API Key Required',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        content: const Text(
          'To generate real AI-driven stories, you need to add at least '
          'one API key in Settings (Anthropic, OpenAI, or DeepSeek).\n\n'
          'You can continue in demo mode, but the narrative will be '
          'placeholder text.',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Go to Settings',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _completeWizard();
            },
            child: const Text('Continue in Demo Mode',
                style: TextStyle(color: Color(0xFFD4A574))),
          ),
        ],
      ),
    );
  }

  Future<void> _completeWizard() async {
    setState(() => _isGeneratingBlueprint = true);

    final settings = ref.read(settingsProvider);
    final router = createRouter(
      anthropicKey: settings.anthropicApiKey,
      openaiKey: settings.openaiApiKey,
      deepseekKey: settings.deepseekApiKey,
      preferred: settings.preferredProvider,
    );
    AIClient.initialize(router);

    ref.read(sessionZeroProvider.notifier).complete();

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/gameplay');
    }
  }

  // Build -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (_isGeneratingBlueprint) {
      return _buildLoadingScreen();
    }

    final isLastStep = _currentStep == _steps.length - 1;
    final meta = _stepMeta[_currentStep];

    return Scaffold(
      backgroundColor: LoreforgeColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(meta),
            _buildStepIndicator(),
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: _steps[_currentStep],
                  ),
                ),
              ),
            ),
            _buildNavigation(isLastStep),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    final sessionZero = ref.read(sessionZeroProvider);
    final genre = sessionZero.genre;
    return Scaffold(
      backgroundColor: LoreforgeColors.background,
      body: Stack(
        children: [
          AtmosphereBackground(
            genre: genre,
            mood: 'mysterious',
            child: const SizedBox.expand(),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.6, end: 1.0),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: 0.9 + (value * 0.1),
                        child: child,
                      ),
                    );
                  },
                  child: const Icon(Icons.auto_stories,
                      size: 56, color: LoreforgeColors.accentGold),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Forging your adventure...',
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: LoreforgeColors.textPrimary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _genreLoadingFlavor(genre),
                  style: const TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: LoreforgeColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      LoreforgeColors.genreAccent(genre),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _genreLoadingFlavor(String genre) {
    switch (genre.toLowerCase()) {
      case 'fantasy':
        return 'The ancient tome turns its pages...';
      case 'sci-fi':
        return 'Initializing quantum narrative engine...';
      case 'horror':
        return 'Something stirs in the darkness...';
      case 'mystery':
        return 'The pieces are falling into place...';
      case 'romance':
        return 'Destiny weaves two paths together...';
      case 'thriller':
        return 'The countdown has begun...';
      case 'historical':
        return 'History prepares to repeat itself...';
      case 'mythology':
        return 'The gods convene...';
      case 'western':
        return 'Dust rises on the horizon...';
      case 'steampunk':
        return 'Gears begin to turn...';
      case 'superhero':
        return 'A new power awakens...';
      case 'survival':
        return 'The world holds its breath...';
      case 'noir':
        return 'Rain falls on empty streets...';
      default:
        return 'Weaving the threads of your story...';
    }
  }

  // Header ------------------------------------------------------------------

  Widget _buildHeader(_StepMeta meta) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: LoreforgeColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          _HeaderIconButton(
            icon: _currentStep > 0 ? Icons.arrow_back_ios_new : Icons.close,
            onPressed: _currentStep > 0
                ? _goBack
                : () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SESSION ZERO',
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 10,
                    letterSpacing: 3,
                    color: LoreforgeColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(meta.icon, size: 16, color: LoreforgeColors.accent),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        meta.title,
                        style: const TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: LoreforgeColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: LoreforgeColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: LoreforgeColors.border),
            ),
            child: Text(
              '${_currentStep + 1} / ${_steps.length}',
              style: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 11,
                color: LoreforgeColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step indicator -----------------------------------------------------------

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      child: Row(
        children: List.generate(_steps.length, (i) {
          final isPast = i < _currentStep;
          final isCurrent = i == _currentStep;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < _steps.length - 1 ? 4 : 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 3,
                decoration: BoxDecoration(
                  color: isPast || isCurrent
                      ? LoreforgeColors.accent
                      : LoreforgeColors.border,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: LoreforgeColors.accent.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Navigation ---------------------------------------------------------------

  Widget _buildNavigation(bool isLastStep) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: LoreforgeColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: _goBack,
                style: OutlinedButton.styleFrom(
                  foregroundColor: LoreforgeColors.textSecondary,
                  side: const BorderSide(
                      color: LoreforgeColors.border, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 3,
            child: _GradientButton(
              label: isLastStep ? 'Begin Adventure' : 'Continue',
              icon: isLastStep ? Icons.auto_stories : Icons.arrow_forward,
              onPressed: _goNext,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared sub-widgets
// ---------------------------------------------------------------------------

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: LoreforgeColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: LoreforgeColors.border),
        ),
        child: Icon(icon, size: 16, color: LoreforgeColors.textSecondary),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: LoreforgeColors.accent.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
