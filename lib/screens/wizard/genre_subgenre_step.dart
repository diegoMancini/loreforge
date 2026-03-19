import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/genre_catalog.dart';
import '../../providers/session_zero_provider.dart';
import '../../theme/genre_theme.dart';

/// Compact genre + subgenre picker with accordion expansion.
///
/// Replaces the old 2-column grid of oversized cards with a scrollable
/// list of genre rows. Tapping a genre expands its subgenre options.
class GenreSubgenreStep extends ConsumerStatefulWidget {
  const GenreSubgenreStep({super.key});

  @override
  ConsumerState<GenreSubgenreStep> createState() => _GenreSubgenreStepState();
}

class _GenreSubgenreStepState extends ConsumerState<GenreSubgenreStep> {
  String? _expandedGenre;

  @override
  void initState() {
    super.initState();
    _expandedGenre = ref.read(sessionZeroProvider).genre;
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionZeroProvider);
    final notifier = ref.read(sessionZeroProvider.notifier);
    final selectedGenre = session.genre;
    final selectedSubgenre = session.subgenre;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your World',
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: LoreforgeColors.textPrimary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Select a genre and optionally a subgenre to shape your story.',
          style: TextStyle(fontSize: 13, color: LoreforgeColors.textSecondary),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: GenreCatalog.categories.length,
            itemBuilder: (context, index) {
              final genre = GenreCatalog.categories[index];
              final isSelected = selectedGenre == genre.name;
              final isExpanded = _expandedGenre == genre.name;
              final accent = genre.accent;

              return Column(
                children: [
                  // ── Genre row ──────────────────────────────────
                  GestureDetector(
                    onTap: () {
                      notifier.updateGenre(genre.name);
                      setState(() {
                        _expandedGenre = isExpanded ? null : genre.name;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? accent.withValues(alpha: 0.1)
                            : Colors.transparent,
                        border: Border(
                          left: BorderSide(
                            color: isSelected ? accent : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Icon badge
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? accent.withValues(alpha: 0.2)
                                  : LoreforgeColors.border.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(genre.icon,
                                color: isSelected
                                    ? accent
                                    : LoreforgeColors.textMuted,
                                size: 16),
                          ),
                          const SizedBox(width: 12),
                          // Name + tagline
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  genre.name,
                                  style: TextStyle(
                                    fontFamily: 'Cinzel',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? accent
                                        : LoreforgeColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  genre.tagline,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: LoreforgeColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Expand chevron
                          AnimatedRotation(
                            turns: isExpanded ? 0.25 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.chevron_right,
                              color: isSelected
                                  ? accent
                                  : LoreforgeColors.textMuted,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Subgenre expansion ────────────────────────
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                      color: accent.withValues(alpha: 0.05),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: genre.subgenres.map((sub) {
                          final isSubSelected = selectedSubgenre == sub.name &&
                              selectedGenre == genre.name;
                          return GestureDetector(
                            onTap: () {
                              notifier.updateSubgenre(
                                  isSubSelected ? '' : sub.name);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: isSubSelected
                                    ? accent.withValues(alpha: 0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSubSelected
                                      ? accent
                                      : accent.withValues(alpha: 0.3),
                                  width: isSubSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    sub.name,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isSubSelected
                                          ? accent
                                          : LoreforgeColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    sub.tagline,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: LoreforgeColors.textMuted
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                  ),

                  // Thin divider between rows
                  if (index < GenreCatalog.categories.length - 1)
                    const Divider(
                      height: 1,
                      color: LoreforgeColors.borderMuted,
                      indent: 56,
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
