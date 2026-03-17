import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/session_zero_provider.dart';
import '../../theme/genre_theme.dart';

class ToneStep extends ConsumerWidget {
  const ToneStep({super.key});

  static const _tones = [
    _ToneOption(
      value: 'Lighthearted',
      icon: Icons.wb_sunny,
      description: 'Warm, fun, with a sense of wonder.',
    ),
    _ToneOption(
      value: 'Epic',
      icon: Icons.public,
      description: 'Grand stakes, heroic deeds, legendary journeys.',
    ),
    _ToneOption(
      value: 'Dark',
      icon: Icons.nights_stay,
      description: 'Moral ambiguity, tension, and shadow.',
    ),
    _ToneOption(
      value: 'Humorous',
      icon: Icons.sentiment_very_satisfied,
      description: 'Wit, absurdity, and comic relief throughout.',
    ),
    _ToneOption(
      value: 'Romantic',
      icon: Icons.favorite,
      description: 'Emotion, longing, and heartfelt connection.',
    ),
    _ToneOption(
      value: 'Gritty',
      icon: Icons.bolt,
      description: 'Brutal realism, hard choices, real consequences.',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionZero = ref.watch(sessionZeroProvider);
    final selected = sessionZero.tone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tone',
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
          'Set the emotional register of your adventure.',
          style: TextStyle(
            fontSize: 14,
            color: LoreforgeColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.9,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _tones
              .map((tone) => _ToneCard(
                    tone: tone,
                    isSelected: selected == tone.value,
                    onTap: () => ref
                        .read(sessionZeroProvider.notifier)
                        .updateTone(tone.value),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

class _ToneOption {
  const _ToneOption({
    required this.value,
    required this.icon,
    required this.description,
  });

  final String value;
  final IconData icon;
  final String description;
}

// ---------------------------------------------------------------------------
// Card widget
// ---------------------------------------------------------------------------

class _ToneCard extends StatelessWidget {
  const _ToneCard({
    required this.tone,
    required this.isSelected,
    required this.onTap,
  });

  final _ToneOption tone;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? LoreforgeColors.accent.withValues(alpha: 0.15)
              : LoreforgeColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? LoreforgeColors.accent : LoreforgeColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: LoreforgeColors.accent.withValues(alpha: 0.2),
                    blurRadius: 14,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    tone.icon,
                    size: 18,
                    color: isSelected
                        ? LoreforgeColors.accent
                        : LoreforgeColors.textMuted,
                  ),
                  const Spacer(),
                  if (isSelected)
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: LoreforgeColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 11,
                      ),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tone.value,
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? LoreforgeColors.accent
                          : LoreforgeColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tone.description,
                    style: const TextStyle(
                      fontSize: 10,
                      height: 1.3,
                      color: LoreforgeColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
