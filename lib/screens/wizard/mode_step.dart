import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/session_zero_provider.dart';
import '../../theme/genre_theme.dart';

class ModeStep extends ConsumerWidget {
  const ModeStep({super.key});

  static const _modes = [
    _ModeOption(
      value: 'pure_story',
      label: 'Pure Story',
      subtitle: 'A literary experience focused on emotional depth, '
          'character development, and narrative choices that test your values.',
      icon: Icons.menu_book,
    ),
    _ModeOption(
      value: 'rpg',
      label: 'RPG Adventure',
      subtitle: 'Stats, skill checks, inventory, and tactical choices. '
          'Your abilities shape the story as much as your decisions.',
      icon: Icons.casino,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionZero = ref.watch(sessionZeroProvider);
    final selected = sessionZero.mode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Adventure Mode',
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
          'How would you like to experience your story?',
          style: TextStyle(
            fontSize: 14,
            color: LoreforgeColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        ..._modes.map((option) => _ModeCard(
              option: option,
              isSelected: selected == option.value,
              onTap: () => ref
                  .read(sessionZeroProvider.notifier)
                  .updateMode(option.value),
            )),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

class _ModeOption {
  const _ModeOption({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.icon,
  });

  final String value;
  final String label;
  final String subtitle;
  final IconData icon;
}

// ---------------------------------------------------------------------------
// Card widget
// ---------------------------------------------------------------------------

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final _ModeOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? LoreforgeColors.accent.withValues(alpha: 0.12)
                : LoreforgeColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? LoreforgeColors.accent
                  : LoreforgeColors.border,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: LoreforgeColors.accent.withValues(alpha: 0.15),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? LoreforgeColors.accent.withValues(alpha: 0.2)
                        : LoreforgeColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    option.icon,
                    color: isSelected
                        ? LoreforgeColors.accent
                        : LoreforgeColors.textMuted,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.label,
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? LoreforgeColors.accent
                              : LoreforgeColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: LoreforgeColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Custom radio dot — avoids deprecated Radio.groupValue API
                _RadioDot(isSelected: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom radio indicator — replaces deprecated Radio.groupValue API
// ---------------------------------------------------------------------------

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? LoreforgeColors.accent : LoreforgeColors.textMuted,
          width: 2,
        ),
        color: isSelected
            ? LoreforgeColors.accent.withValues(alpha: 0.15)
            : Colors.transparent,
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: LoreforgeColors.accent,
                ),
              ),
            )
          : null,
    );
  }
}
