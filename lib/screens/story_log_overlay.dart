import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/story_provider.dart';
import '../theme/loreforge_theme.dart';

/// Scrollable dialog showing the full narrative log of the current session.
///
/// Reads scene history from [storyProvider]. Shown via [showDialog] from
/// [GameplayScreen]. No constructor parameters required.
class StoryLogOverlay extends ConsumerWidget {
  const StoryLogOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyProvider);
    final genre = storyState.genre;
    final accent = LoreforgeColors.genreAccent(genre);
    final accentDim = LoreforgeColors.genreAccentDim(genre);
    final scenes = storyState.scenes;

    // Responsive dialog width
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = (screenWidth * 0.9).clamp(0.0, 560.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Container(
        width: dialogWidth,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: LoreforgeColors.surface.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: 0.35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.15),
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
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
              decoration: BoxDecoration(
                color: accentDim.withValues(alpha: 0.25),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                border: const Border(
                  bottom: BorderSide(color: LoreforgeColors.border, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Story Log',
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
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                ],
              ),
            ),

            // Body — scene list
            scenes.isEmpty
                ? const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                    child: Text(
                      'Your story has not yet begun...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: LoreforgeColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                  )
                : Flexible(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      itemCount: scenes.length,
                      separatorBuilder: (_, __) => Divider(
                        color: accent.withValues(alpha: 0.12),
                        thickness: 1,
                        height: 24,
                      ),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Scene number badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Scene ${index + 1}',
                                style: TextStyle(
                                  fontFamily: 'Cinzel',
                                  fontSize: 10,
                                  letterSpacing: 1,
                                  color: accent.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                            Text(
                              scenes[index],
                              style: const TextStyle(
                                fontFamily: 'Lora',
                                fontSize: 13,
                                height: 1.6,
                                color: LoreforgeColors.textSecondary,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
