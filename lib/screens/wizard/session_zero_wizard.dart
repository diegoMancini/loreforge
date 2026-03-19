import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ai/ai_client.dart';
import '../../ai/providers/provider_factory.dart';
import '../../providers/session_zero_provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/loreforge_theme.dart';
import '../../widgets/atmosphere_background.dart';
import 'language_step.dart';
import 'mode_step.dart';
import 'setup_method_step.dart';
import 'genre_step.dart';
import 'tone_step.dart';
import 'favorite_stories_step.dart';
import 'twists_step.dart';

// ---------------------------------------------------------------------------
// Step metadata
// ---------------------------------------------------------------------------

class _StepMeta {
  const _StepMeta({required this.title, required this.icon});
  final String title;
  final IconData icon;
}

const _stepMeta = [
  _StepMeta(title: 'Choose Your Tongue', icon: Icons.translate),
  _StepMeta(title: 'Choose Your Experience', icon: Icons.casino),
  _StepMeta(title: 'How Shall We Begin?', icon: Icons.tune),
  _StepMeta(title: 'Choose Your World', icon: Icons.auto_stories),
  _StepMeta(title: 'Set the Mood', icon: Icons.mood),
  _StepMeta(title: 'Your Literary DNA', icon: Icons.bookmark),
  _StepMeta(title: 'Embrace the Unexpected', icon: Icons.auto_awesome),
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

  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

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
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentStep < _steps.length - 1) {
      _slideController.reset();
      setState(() => _currentStep++);
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
              Navigator.of(context).pop(); // back to main menu
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

  void _goBack() {
    if (_currentStep > 0) {
      _slideController.reset();
      setState(() => _currentStep--);
      _slideController.forward();
    }
  }

  Future<void> _completeWizard() async {
    setState(() => _isGeneratingBlueprint = true);

    // Initialize AIClient with the user's configured API keys.
    final settings = ref.read(settingsProvider);
    final router = createRouter(
      anthropicKey: settings.anthropicApiKey,
      openaiKey: settings.openaiApiKey,
      deepseekKey: settings.deepseekApiKey,
      preferred: settings.preferredProvider,
    );
    AIClient.initialize(router);

    // Start blueprint generation (runs in background via provider)
    ref.read(sessionZeroProvider.notifier).complete();

    // Ensure minimum loading screen display for UX feel
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/gameplay');
    }
  }

  // Build -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Blueprint generation loading screen
    if (_isGeneratingBlueprint) {
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
                    child: const Icon(
                      Icons.auto_stories,
                      size: 56,
                      color: LoreforgeColors.accentGold,
                    ),
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
                  child: SingleChildScrollView(
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

  String _genreLoadingFlavor(String genre) {
    switch (genre.toLowerCase()) {
      case 'fantasy':
        return 'The ancient tome turns its pages...';
      case 'sci-fi':
      case 'scifi':
        return 'Initializing quantum narrative engine...';
      case 'horror':
        return 'Something stirs in the darkness...';
      case 'mystery':
        return 'The pieces are falling into place...';
      case 'romance':
        return 'Destiny weaves two paths together...';
      case 'thriller':
        return 'The countdown has begun...';
      case 'historical fiction':
        return 'History prepares to repeat itself...';
      case 'mythology':
        return 'The gods convene on Mount Olympus...';
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
          // Back / close button
          _HeaderIconButton(
            icon: _currentStep > 0 ? Icons.arrow_back_ios_new : Icons.close,
            onPressed: _currentStep > 0
                ? _goBack
                : () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12),
          // Title
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
                    Icon(meta.icon,
                        size: 16, color: LoreforgeColors.accent),
                    const SizedBox(width: 6),
                    Text(
                      meta.title,
                      style: const TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: LoreforgeColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Step counter
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step indicator dots -----------------------------------------------------

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
                            color:
                                LoreforgeColors.accent.withValues(alpha: 0.5),
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

  // Navigation buttons ------------------------------------------------------

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
          // Back button (hidden on first step)
          if (_currentStep > 0) ...[
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: _goBack,
                style: OutlinedButton.styleFrom(
                  foregroundColor: LoreforgeColors.textSecondary,
                  side: const BorderSide(
                      color: LoreforgeColors.border, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 12),
          ],
          // Next / Start button
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

/// A full-width button with a purple gradient fill — matches primary menu btn.
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
        padding: const EdgeInsets.symmetric(vertical: 16),
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
