import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/save_manager.dart';
import '../providers/story_provider.dart';
import '../theme/loreforge_theme.dart';
import 'settings_screen.dart';

/// Main menu — entry point of the application.
///
/// Provides three actions:
///  - New Adventure   → navigates to the Session Zero wizard.
///  - Continue Adventure → loads the most recent save and enters gameplay.
///  - Settings        → opens [SettingsScreen] as a dialog.
///
/// The former "Load Game" TextButton has been removed as it duplicated the
/// "Continue Adventure" functionality.
class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A18), Color(0xFF1A0A2E), Colors.black],
            stops: [0.0, 0.5, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Logo / title ─────────────────────────────────────────────
              const Text(
                'LOREFORGE',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: LoreforgeColors.accentGold,
                  letterSpacing: 6,
                  shadows: [
                    Shadow(
                      color: LoreforgeColors.accentGold,
                      blurRadius: 24,
                    ),
                    Shadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'AI-Powered Adventure Stories',
                style: TextStyle(
                  fontSize: 15,
                  color: LoreforgeColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 56),

              // ── New Adventure ─────────────────────────────────────────────
              _MenuButton(
                label: 'New Adventure',
                icon: Icons.auto_awesome,
                isPrimary: true,
                onPressed: () => Navigator.of(context).pushNamed('/wizard'),
              ),

              const SizedBox(height: 14),

              // ── Continue Adventure ─────────────────────────────────────────
              _MenuButton(
                label: 'Continue Adventure',
                icon: Icons.play_circle_outline,
                onPressed: () => _continueAdventure(context, ref),
              ),

              const SizedBox(height: 24),

              // ── Settings (text-style link) ────────────────────────────────
              TextButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const SettingsScreen(),
                ),
                icon: const Icon(
                  Icons.settings_outlined,
                  size: 16,
                  color: LoreforgeColors.textMuted,
                ),
                label: const Text(
                  'Settings',
                  style: TextStyle(
                    color: LoreforgeColors.textMuted,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _continueAdventure(BuildContext context, WidgetRef ref) async {
    try {
      final loadedStory = await SaveManager.loadStory();
      if (loadedStory != null) {
        ref.read(storyProvider.notifier).loadStory(loadedStory);
        if (context.mounted) {
          Navigator.of(context).pushNamed('/gameplay');
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No saved adventure found.'),
              backgroundColor: LoreforgeColors.snackBarBg,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not load save: $e'),
            backgroundColor: LoreforgeColors.errorBg,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

// ── Private helpers ────────────────────────────────────────────────────────

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.auto_awesome, size: 18),
        label: const Text('New Adventure'),
        style: ElevatedButton.styleFrom(
          backgroundColor: LoreforgeColors.accentGold,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 6,
          shadowColor: LoreforgeColors.accentGold.withValues(alpha: 0.4),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: LoreforgeColors.textSecondary),
      label: Text(
        label,
        style: const TextStyle(color: LoreforgeColors.textSecondary),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        side: const BorderSide(color: LoreforgeColors.border, width: 1.5),
        textStyle: const TextStyle(fontSize: 16, letterSpacing: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
