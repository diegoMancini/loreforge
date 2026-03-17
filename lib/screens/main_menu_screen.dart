import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/save_manager.dart';
import '../providers/story_provider.dart';
import '../theme/genre_theme.dart';
import '../widgets/atmosphere_background.dart';
import 'credits_screen.dart';

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;

  /// Drives the gentle breathing glow on the LOREFORGE title.
  late final AnimationController _glowController;
  late final Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowOpacity = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  // Actions ---------------------------------------------------------------

  Future<void> _continueAdventure() async {
    setState(() => _isLoading = true);
    try {
      final loadedStory = await SaveManager.loadStory();
      if (!mounted) return;
      if (loadedStory != null) {
        ref.read(storyProvider.notifier).loadStory(loadedStory);
        Navigator.of(context).pushReplacementNamed('/gameplay');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No saved adventure found.'),
            backgroundColor: Color(0xFF1E293B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load: $e'),
          backgroundColor: const Color(0xFF450A0A),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openCredits() {
    showDialog<void>(
      context: context,
      builder: (_) => const CreditsScreen(),
    );
  }

  void _quit() {
    SystemNavigator.pop();
  }

  // Build -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AtmosphereBackground(
        genre: 'Fantasy',
        mood: 'mysterious',
        child: Stack(
          children: [
            // Menu column wrapped in SingleChildScrollView so it degrades
            // gracefully on short screens (e.g. the 600 px test surface).
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAnimatedTitle(),
                        const SizedBox(height: 8),
                        const Text(
                          'Your story. Your choices. Your legend.',
                          style: TextStyle(
                            fontSize: 15,
                            color: LoreforgeColors.textSecondary,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 56),

                        // Primary buttons
                        _MenuButton(
                          label: 'New Adventure',
                          icon: Icons.auto_stories,
                          primary: true,
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/wizard'),
                        ),
                        const SizedBox(height: 12),
                        _MenuButton(
                          label: _isLoading
                              ? 'Loading...'
                              : 'Continue Adventure',
                          icon: _isLoading
                              ? Icons.hourglass_top
                              : Icons.play_circle_outline,
                          primary: false,
                          onPressed: _isLoading ? () {} : _continueAdventure,
                        ),

                        const SizedBox(height: 24),
                        const _MenuDivider(),
                        const SizedBox(height: 16),

                        // Secondary buttons
                        _SecondaryMenuButton(
                          label: 'Load Game',
                          icon: Icons.folder_open,
                          onPressed: () =>
                              _showSnackBar('Save system coming soon'),
                        ),
                        const SizedBox(height: 8),
                        _SecondaryMenuButton(
                          label: 'Settings',
                          icon: Icons.settings,
                          onPressed: () =>
                              _showSnackBar('Settings coming soon'),
                        ),
                        const SizedBox(height: 8),
                        _SecondaryMenuButton(
                          label: 'Credits',
                          icon: Icons.info_outline,
                          onPressed: _openCredits,
                        ),

                        // Quit only on non-web platforms (desktop / mobile)
                        if (!kIsWeb) ...[
                          const SizedBox(height: 8),
                          _SecondaryMenuButton(
                            label: 'Quit',
                            icon: Icons.exit_to_app,
                            onPressed: _quit,
                          ),
                        ],

                        const SizedBox(height: 48),
                        const Text(
                          'Powered by Claude AI',
                          style: TextStyle(
                            fontSize: 12,
                            color: LoreforgeColors.textDim,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Version tag fixed to bottom-right corner
            const Positioned(
              right: 16,
              bottom: 12,
              child: Text(
                'v0.1.0',
                style: TextStyle(
                  fontSize: 11,
                  color: LoreforgeColors.textDim,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the LOREFORGE title with a gentle pulsing glow driven by
  /// [_glowOpacity]. The ShaderMask gradient is static; only the BoxShadow
  /// opacity breathes.
  Widget _buildAnimatedTitle() {
    return AnimatedBuilder(
      animation: _glowOpacity,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED)
                    .withValues(alpha: _glowOpacity.value * 0.45),
                blurRadius: 40,
                spreadRadius: 8,
              ),
            ],
          ),
          child: child,
        );
      },
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFFA855F7), Color(0xFF6366F1), Color(0xFF818CF8)],
        ).createShader(bounds),
        child: const Text(
          'LOREFORGE',
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 52,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Menu button widgets
// ---------------------------------------------------------------------------

/// Full-width primary or secondary styled button for the two main actions.
class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.icon,
    required this.primary,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (primary) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: LoreforgeColors.accent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            shadowColor: LoreforgeColors.accent.withValues(alpha: 0.5),
          ),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: LoreforgeColors.textSecondary,
          side: const BorderSide(color: Color(0xFF334155), width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

/// Compact text-style button for Load, Settings, Credits, and Quit.
/// Smaller padding and muted colour so it recedes behind primary actions.
class _SecondaryMenuButton extends StatelessWidget {
  const _SecondaryMenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16, color: LoreforgeColors.textMuted),
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: LoreforgeColors.textMuted,
          padding: const EdgeInsets.symmetric(vertical: 11),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

/// A decorative horizontal rule separating primary from secondary buttons.
class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Color(0xFF2D2D4A)],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF3D3D5A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2D2D4A), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
