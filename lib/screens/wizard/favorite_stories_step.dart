import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/session_zero_provider.dart';
import '../../theme/genre_theme.dart';

class FavoriteStoriesStep extends ConsumerStatefulWidget {
  const FavoriteStoriesStep({super.key});

  @override
  ConsumerState<FavoriteStoriesStep> createState() =>
      _FavoriteStoriesStepState();
}

class _FavoriteStoriesStepState extends ConsumerState<FavoriteStoriesStep> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addStory() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      ref.read(sessionZeroProvider.notifier).addFavoriteStory(text);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionZero = ref.watch(sessionZeroProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Favorite Stories',
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
          'Tell us about stories you love — books, films, games. '
          'We will weave those influences into your adventure.',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: LoreforgeColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),

        // Input field
        Container(
          decoration: BoxDecoration(
            color: LoreforgeColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: LoreforgeColors.border),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: 3,
            style: const TextStyle(
              fontSize: 14,
              color: LoreforgeColors.textPrimary,
            ),
            decoration: const InputDecoration(
              hintText:
                  'e.g. "The Name of the Wind", Blade Runner, Dark Souls...',
              hintStyle: TextStyle(
                fontSize: 13,
                color: LoreforgeColors.textMuted,
              ),
              contentPadding: EdgeInsets.all(14),
              border: InputBorder.none,
            ),
            onSubmitted: (_) => _addStory(),
          ),
        ),
        const SizedBox(height: 10),

        // Add button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _addStory,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Story'),
            style: OutlinedButton.styleFrom(
              foregroundColor: LoreforgeColors.accent,
              side: const BorderSide(color: LoreforgeColors.accent, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        if (sessionZero.favoriteStories.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            'ADDED',
            style: TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 10,
              letterSpacing: 2,
              color: LoreforgeColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sessionZero.favoriteStories
                .map((story) => _StoryChip(
                      label: story,
                      onRemove: () => ref
                          .read(sessionZeroProvider.notifier)
                          .removeFavoriteStory(story),
                    ))
                .toList(),
          ),
        ],

        // Skip hint
        const SizedBox(height: 16),
        const Row(
          children: [
            Icon(Icons.info_outline,
                size: 14, color: LoreforgeColors.textMuted),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Optional — you can skip this step.',
                style: TextStyle(
                  fontSize: 12,
                  color: LoreforgeColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Story chip
// ---------------------------------------------------------------------------

class _StoryChip extends StatelessWidget {
  const _StoryChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: LoreforgeColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: LoreforgeColors.accent.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: LoreforgeColors.textPrimary,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: LoreforgeColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
