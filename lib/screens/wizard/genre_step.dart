import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/session_zero_provider.dart';
import '../../theme/genre_theme.dart';
import '../../models/genre_rules.dart';

class GenreStep extends ConsumerWidget {
  const GenreStep({super.key});

  static const List<String> genres = [
    'Fantasy',
    'Horror',
    'Mystery',
    'Sci-Fi',
    'Romance',
    'Thriller',
    'War',
    'Historical',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionZero = ref.watch(sessionZeroProvider);
    final selected = sessionZero.genre;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Genre',
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
          'Choose the world your story will inhabit.',
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
          childAspectRatio: 1.35,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: genres
              .map((genre) => _GenreCard(
                    genre: genre,
                    isSelected: selected == genre,
                    onTap: () => ref
                        .read(sessionZeroProvider.notifier)
                        .updateGenre(genre),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Genre card
// ---------------------------------------------------------------------------

class _GenreCard extends StatelessWidget {
  const _GenreCard({
    required this.genre,
    required this.isSelected,
    required this.onTap,
  });

  final String genre;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = GenreTheme.accentColor(genre);
    final icon = GenreTheme.genreIcon(genre);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? accent.withValues(alpha: 0.15)
              : LoreforgeColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accent : LoreforgeColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.25),
                    blurRadius: 18,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Faint watermark icon
            Positioned(
              right: -6,
              bottom: -6,
              child: Icon(
                icon,
                size: 56,
                color: isSelected
                    ? accent.withValues(alpha: 0.12)
                    : LoreforgeColors.border.withValues(alpha: 0.5),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accent.withValues(alpha: 0.25)
                          : LoreforgeColors.border,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? accent : LoreforgeColors.textMuted,
                      size: 18,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        genre,
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color:
                              isSelected ? accent : LoreforgeColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        GenreRules.getRules(genre)['tone'] as String? ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: isSelected
                              ? accent.withValues(alpha: 0.7)
                              : LoreforgeColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Selection checkmark
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 13,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
