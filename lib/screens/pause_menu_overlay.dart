import 'package:flutter/material.dart';
import '../theme/loreforge_theme.dart';
import 'settings_screen.dart';

/// Semi-transparent pause menu shown as a Stack overlay inside GameplayScreen.
///
/// [onResume] is called when the player taps "Resume" — the caller is
/// responsible for hiding this widget (e.g. by toggling a bool in setState).
///
/// [onMainMenu] is called when the player confirms "Return to Main Menu".
/// [onSave] is called when the player taps "Save Game".
class PauseMenuOverlay extends StatelessWidget {
  const PauseMenuOverlay({
    super.key,
    required this.onResume,
    required this.onSave,
    required this.onMainMenu,
  });

  final VoidCallback onResume;
  final VoidCallback onSave;
  final VoidCallback onMainMenu;

  @override
  Widget build(BuildContext context) {
    return Material(
      // Transparent Material so GestureDetector background can capture taps.
      color: Colors.transparent,
      child: Stack(
        children: [
          // ── Semi-transparent backdrop ──────────────────────────────────
          GestureDetector(
            onTap: onResume, // Tapping outside the card resumes.
            child: Container(
              color: Colors.black.withValues(alpha: 0.65),
            ),
          ),

          // ── Centred menu card ──────────────────────────────────────────
          Center(
            child: _PauseCard(
              onResume: onResume,
              onSave: onSave,
              onMainMenu: onMainMenu,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private card widget ────────────────────────────────────────────────────

class _PauseCard extends StatelessWidget {
  const _PauseCard({
    required this.onResume,
    required this.onSave,
    required this.onMainMenu,
  });

  final VoidCallback onResume;
  final VoidCallback onSave;
  final VoidCallback onMainMenu;

  @override
  Widget build(BuildContext context) {
    const cardWidth = 280.0;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: LoreforgeColors.surface.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LoreforgeColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.7),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          const Text(
            'Paused',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: LoreforgeColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(color: LoreforgeColors.border, thickness: 1),
          const SizedBox(height: 12),

          // Resume
          _PauseButton(
            label: 'Resume',
            icon: Icons.play_arrow_rounded,
            isPrimary: true,
            onPressed: onResume,
          ),
          const SizedBox(height: 10),

          // Save
          _PauseButton(
            label: 'Save Game',
            icon: Icons.save_outlined,
            onPressed: onSave,
          ),
          const SizedBox(height: 10),

          // Settings — opens SettingsScreen as a dialog
          _PauseButton(
            label: 'Settings',
            icon: Icons.settings_outlined,
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const SettingsScreen(),
            ),
          ),
          const SizedBox(height: 10),

          // Main Menu
          _PauseButton(
            label: 'Main Menu',
            icon: Icons.home_outlined,
            isDangerous: true,
            onPressed: () => _confirmMainMenu(context),
          ),
        ],
      ),
    );
  }

  void _confirmMainMenu(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: LoreforgeColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: LoreforgeColors.border),
        ),
        title: const Text(
          'Return to Main Menu?',
          style: TextStyle(
            color: LoreforgeColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Unsaved progress will be lost.',
          style: TextStyle(
            color: LoreforgeColors.textSecondary,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: LoreforgeColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
              onMainMenu();
            },
            child: const Text(
              'Leave',
              style: TextStyle(color: LoreforgeColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  const _PauseButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
    this.isDangerous = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDangerous;

  @override
  Widget build(BuildContext context) {
    final Color labelColor;
    final Color borderColor;

    if (isPrimary) {
      labelColor = LoreforgeColors.accentGold;
      borderColor = LoreforgeColors.accentGold.withValues(alpha: 0.6);
    } else if (isDangerous) {
      labelColor = LoreforgeColors.error;
      borderColor = LoreforgeColors.errorBorder.withValues(alpha: 0.6);
    } else {
      labelColor = LoreforgeColors.textSecondary;
      borderColor = LoreforgeColors.border;
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: labelColor),
        label: Text(
          label,
          style: TextStyle(fontSize: 15, color: labelColor),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: isPrimary
              ? LoreforgeColors.accentGoldDim.withValues(alpha: 0.12)
              : Colors.transparent,
        ),
      ),
    );
  }
}
