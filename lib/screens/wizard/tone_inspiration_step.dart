import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/media_catalog.dart';
import '../../providers/session_zero_provider.dart';
import '../../theme/genre_theme.dart';

/// Tone selector + curated media recommendations for the selected genre.
class ToneInspirationStep extends ConsumerWidget {
  const ToneInspirationStep({super.key});

  static const _tones = [
    _ToneOption('lighthearted', 'Lighthearted', Icons.wb_sunny),
    _ToneOption('epic', 'Epic', Icons.public),
    _ToneOption('dark', 'Dark', Icons.nights_stay),
    _ToneOption('humorous', 'Humorous', Icons.sentiment_very_satisfied),
    _ToneOption('romantic', 'Romantic', Icons.favorite),
    _ToneOption('gritty', 'Gritty', Icons.bolt),
    _ToneOption('mysterious', 'Mysterious', Icons.visibility),
    _ToneOption('melancholic', 'Melancholic', Icons.water_drop),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionZeroProvider);
    final notifier = ref.read(sessionZeroProvider.notifier);
    final selectedTone = session.tone;
    final selectedGenre = session.genre;
    final selectedSubgenre = session.subgenre;
    final selectedMedia = session.mediaInspiration;

    final mediaItems =
        MediaCatalog.forGenre(selectedGenre, selectedSubgenre.isEmpty ? null : selectedSubgenre);

    // Group by type
    final films = mediaItems.where((m) => m.type == MediaType.film).toList();
    final books = mediaItems.where((m) => m.type == MediaType.book).toList();
    final games = mediaItems.where((m) => m.type == MediaType.game).toList();
    final shows = mediaItems.where((m) => m.type == MediaType.show).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Tone ────────────────────────────────────────────────────
        const Text(
          'Set the Mood',
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
          'Choose the emotional register of your adventure.',
          style: TextStyle(fontSize: 13, color: LoreforgeColors.textSecondary),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _tones
              .map((t) => _ToneChip(
                    tone: t,
                    isSelected: selectedTone == t.value,
                    onTap: () => notifier.updateTone(t.value),
                  ))
              .toList(),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(color: LoreforgeColors.border, height: 1),
        ),

        // ── Inspiration ─────────────────────────────────────────────
        Row(
          children: [
            const Text(
              'Stories That Inspire',
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LoreforgeColors.textPrimary,
                letterSpacing: 0.6,
              ),
            ),
            const Spacer(),
            if (selectedMedia.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: LoreforgeColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${selectedMedia.length} selected',
                  style: const TextStyle(
                      fontSize: 11, color: LoreforgeColors.accent),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Select titles that capture the feel you want.',
          style: TextStyle(fontSize: 12, color: LoreforgeColors.textMuted),
        ),
        const SizedBox(height: 12),

        // Media sections
        Expanded(
          child: ListView(
            children: [
              if (films.isNotEmpty)
                _mediaSection('Films', Icons.movie, films, selectedMedia, notifier),
              if (books.isNotEmpty)
                _mediaSection('Books', Icons.menu_book, books, selectedMedia, notifier),
              if (games.isNotEmpty)
                _mediaSection('Games', Icons.sports_esports, games, selectedMedia, notifier),
              if (shows.isNotEmpty)
                _mediaSection('Shows', Icons.tv, shows, selectedMedia, notifier),
              if (mediaItems.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No curated media for this genre yet.\nYou can add your own inspirations on the next step.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13, color: LoreforgeColors.textMuted),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mediaSection(
    String label,
    IconData icon,
    List<MediaItem> items,
    List<String> selected,
    SessionZeroNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 4),
          child: Row(
            children: [
              Icon(icon, size: 14, color: LoreforgeColors.textMuted),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: LoreforgeColors.accentGold.withValues(alpha: 0.6),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = selected.contains(item.title);
              return _MediaCard(
                item: item,
                isSelected: isSelected,
                onTap: () => notifier.toggleMediaInspiration(item.title),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

// ── Models ──────────────────────────────────────────────────────────────────

class _ToneOption {
  final String value, label;
  final IconData icon;
  const _ToneOption(this.value, this.label, this.icon);
}

// ── Widgets ─────────────────────────────────────────────────────────────────

class _ToneChip extends StatelessWidget {
  const _ToneChip(
      {required this.tone, required this.isSelected, required this.onTap});
  final _ToneOption tone;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? LoreforgeColors.accent.withValues(alpha: 0.18)
              : LoreforgeColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                isSelected ? LoreforgeColors.accent : LoreforgeColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tone.icon,
                size: 14,
                color: isSelected
                    ? LoreforgeColors.accent
                    : LoreforgeColors.textMuted),
            const SizedBox(width: 5),
            Text(
              tone.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? LoreforgeColors.accent
                    : LoreforgeColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaCard extends StatelessWidget {
  const _MediaCard(
      {required this.item, required this.isSelected, required this.onTap});
  final MediaItem item;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _typeIcon {
    switch (item.type) {
      case MediaType.film:
        return Icons.movie;
      case MediaType.book:
        return Icons.menu_book;
      case MediaType.game:
        return Icons.sports_esports;
      case MediaType.show:
        return Icons.tv;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 130,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? LoreforgeColors.accent.withValues(alpha: 0.1)
              : LoreforgeColors.surfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? LoreforgeColors.accent
                : LoreforgeColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: isSelected
                          ? LoreforgeColors.accent
                          : LoreforgeColors.textPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle,
                      size: 14, color: LoreforgeColors.accent),
              ],
            ),
            Row(
              children: [
                Icon(_typeIcon,
                    size: 10, color: LoreforgeColors.textMuted),
                const SizedBox(width: 3),
                Text(
                  item.year,
                  style: const TextStyle(
                      fontSize: 10, color: LoreforgeColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
