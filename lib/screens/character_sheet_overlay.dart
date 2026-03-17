import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/story_provider.dart';
import '../theme/loreforge_theme.dart';

/// Character stat sheet shown as a dark-themed dialog over gameplay.
///
/// Reads RPG state directly from [storyProvider]; no constructor parameters
/// required. Shown via [showDialog] from GameplayScreen.
class CharacterSheetOverlay extends ConsumerWidget {
  const CharacterSheetOverlay({super.key});

  // Stats cap used for the bar visualisation.
  static const int _statMax = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyProvider);

    if (storyState.rpgState == null) {
      return const SizedBox.shrink();
    }

    final rpg = storyState.rpgState!;
    final genre = storyState.genre;
    final accent = LoreforgeColors.genreAccent(genre);
    final accentDim = LoreforgeColors.genreAccentDim(genre);

    // Responsive width: 85 % of screen, capped at 480 logical pixels.
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = (screenWidth * 0.85).clamp(0.0, 480.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: dialogWidth,
        decoration: BoxDecoration(
          color: LoreforgeColors.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: 0.35), width: 1.5),
          boxShadow: [
            // Genre accent glow on the dialog border
            BoxShadow(
              color: accent.withValues(alpha: 0.18),
              blurRadius: 24,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ────────────────────────────────────────────────────
            _Header(accent: accent, accentDim: accentDim),

            // ── Stats ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Column(
                children: [
                  _StatRow(label: 'Strength', value: rpg.strength, accent: accent),
                  _StatRow(label: 'Agility', value: rpg.agility, accent: accent),
                  _StatRow(label: 'Intelligence', value: rpg.intelligence, accent: accent),
                  _StatRow(label: 'Charisma', value: rpg.charisma, accent: accent),
                  _StatRow(label: 'Perception', value: rpg.perception, accent: accent),
                  _StatRow(label: 'Willpower', value: rpg.willpower, accent: accent),
                ],
              ),
            ),

            // ── Divider ───────────────────────────────────────────────────
            const Divider(
              color: LoreforgeColors.border,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),

            // ── Score footer ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Adventure Score',
                    style: TextStyle(
                      fontSize: 14,
                      color: LoreforgeColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '${rpg.score}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.accent, required this.accentDim});

  final Color accent;
  final Color accentDim;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
      decoration: BoxDecoration(
        color: accentDim.withValues(alpha: 0.25),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: const Border(
          bottom: BorderSide(color: LoreforgeColors.border, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Character Sheet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: LoreforgeColors.textPrimary,
              letterSpacing: 1.2,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              color: LoreforgeColors.textMuted,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final int value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    // Bar fill ratio clamped 0–1.
    final ratio = (value / CharacterSheetOverlay._statMax).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: LoreforgeColors.textSecondary,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Stat bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 5,
              backgroundColor: LoreforgeColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(accent.withValues(alpha: 0.75)),
            ),
          ),
        ],
      ),
    );
  }
}
