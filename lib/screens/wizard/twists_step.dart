import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/session_zero_provider.dart';
import '../../theme/genre_theme.dart';

class TwistsStep extends ConsumerWidget {
  const TwistsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionZero = ref.watch(sessionZeroProvider);
    final enabled = sessionZero.twistsEnabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plot Twists',
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: LoreforgeColors.textPrimary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Allow unexpected turns that reshape the story in ways '
          'you never saw coming.',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: LoreforgeColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),

        // Toggle card
        GestureDetector(
          onTap: () =>
              ref.read(sessionZeroProvider.notifier).toggleTwists(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              color: enabled
                  ? LoreforgeColors.accent.withValues(alpha: 0.12)
                  : LoreforgeColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: enabled
                    ? LoreforgeColors.accent
                    : LoreforgeColors.border,
                width: enabled ? 1.5 : 1,
              ),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: LoreforgeColors.accent.withValues(alpha: 0.18),
                        blurRadius: 18,
                      ),
                    ]
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: enabled
                          ? LoreforgeColors.accent.withValues(alpha: 0.2)
                          : LoreforgeColors.border,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: enabled
                          ? LoreforgeColors.accent
                          : LoreforgeColors.textMuted,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Text
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enable Plot Twists',
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: LoreforgeColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'The narrative may take unexpected turns that '
                          'surprise even seasoned adventurers.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: LoreforgeColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Switch
                  Switch(
                    value: enabled,
                    onChanged: (_) =>
                        ref.read(sessionZeroProvider.notifier).toggleTwists(),
                    thumbColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? LoreforgeColors.accent
                          : LoreforgeColors.textMuted,
                    ),
                    trackColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? LoreforgeColors.accent.withValues(alpha: 0.35)
                          : LoreforgeColors.border,
                    ),
                    trackOutlineColor: WidgetStateProperty.all(
                      Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Info cards
        _InfoRow(
          icon: Icons.shuffle,
          text: 'Twists trigger based on narrative pacing, not randomly — '
              'they always make story sense.',
          enabled: enabled,
        ),
        const SizedBox(height: 10),
        _InfoRow(
          icon: Icons.undo,
          text: 'You can react to twists through your choices; '
              'you are never a passive observer.',
          enabled: enabled,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Info row
// ---------------------------------------------------------------------------

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.enabled,
  });

  final IconData icon;
  final String text;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 14,
          color: enabled ? LoreforgeColors.accent : LoreforgeColors.textMuted,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: LoreforgeColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
