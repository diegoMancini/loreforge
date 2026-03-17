import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/story_provider.dart';
import '../theme/loreforge_theme.dart';

/// Inventory dialog shown over gameplay using a dark fantasy theme.
///
/// Reads item list from [storyProvider]. No constructor parameters required.
/// Shown via [showDialog] from GameplayScreen.
class InventoryOverlay extends ConsumerWidget {
  const InventoryOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyProvider);
    final genre = storyState.genre;
    final accent = LoreforgeColors.genreAccent(genre);
    final accentDim = LoreforgeColors.genreAccentDim(genre);
    final inventory = storyState.rpgState?.inventory ?? const [];

    // Responsive width: 85 % of screen, capped at 480 logical pixels.
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = (screenWidth * 0.85).clamp(0.0, 480.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: dialogWidth,
        constraints: const BoxConstraints(maxHeight: 520),
        decoration: BoxDecoration(
          color: LoreforgeColors.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: 0.35), width: 1.5),
          boxShadow: [
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
            _InventoryHeader(accent: accent, accentDim: accentDim),

            // ── Body ──────────────────────────────────────────────────────
            inventory.isEmpty
                ? _EmptyState(accent: accent)
                : _ItemList(items: inventory, accent: accent),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────

class _InventoryHeader extends StatelessWidget {
  const _InventoryHeader({required this.accent, required this.accentDim});

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
            'Inventory',
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Column(
        children: [
          Icon(
            Icons.backpack_outlined,
            size: 40,
            color: LoreforgeColors.textMuted,
          ),
          SizedBox(height: 12),
          Text(
            'Your pack lies empty, waiting to be filled...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: LoreforgeColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({required this.items, required this.accent});

  final List<String> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(
          color: LoreforgeColors.borderMuted,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Genre accent bullet icon
                Icon(Icons.diamond, size: 10, color: accent.withValues(alpha: 0.8)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    items[index],
                    style: const TextStyle(
                      fontSize: 15,
                      color: LoreforgeColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
