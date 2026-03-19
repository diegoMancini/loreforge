import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/save_manager.dart';
import '../models/save_slot_meta.dart';
import '../theme/loreforge_theme.dart';
import '../theme/genre_theme.dart';

/// Multi-slot load game dialog.
class LoadGameDialog extends ConsumerStatefulWidget {
  const LoadGameDialog({super.key});

  @override
  ConsumerState<LoadGameDialog> createState() => _LoadGameDialogState();
}

class _LoadGameDialogState extends ConsumerState<LoadGameDialog> {
  List<SaveSlotMeta?>? _slots;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    final slots = await SaveManager.getSlotMetadata();
    if (mounted) {
      setState(() {
        _slots = slots;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 480),
        decoration: BoxDecoration(
          color: LoreforgeColors.surface.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: LoreforgeColors.border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.65),
              blurRadius: 32,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 8, 14),
              decoration: BoxDecoration(
                color: LoreforgeColors.accentGoldDim.withValues(alpha: 0.2),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
                border: const Border(
                  bottom: BorderSide(color: LoreforgeColors.border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.folder_open,
                      color: LoreforgeColors.accentGold, size: 18),
                  const SizedBox(width: 10),
                  const Text(
                    'Load Game',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: LoreforgeColors.textPrimary,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close,
                        color: LoreforgeColors.textMuted, size: 18),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ),

            // Slots
            Flexible(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: LoreforgeColors.accentGold,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: SaveManager.maxSlots,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final meta = _slots?[index];
                        return _SlotCard(
                          slot: index,
                          meta: meta,
                          onLoad: meta != null
                              ? () => _loadSlot(context, index)
                              : null,
                          onDelete: meta != null
                              ? () => _deleteSlot(index)
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSlot(BuildContext context, int slot) async {
    final data = await SaveManager.loadSlot(slot);
    if (data == null || !mounted) return;

    // Pop dialog and navigate to gameplay
    Navigator.of(context).pop(data);
  }

  Future<void> _deleteSlot(int slot) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Delete Save?',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Text(
          'Delete save in Slot ${slot == 0 ? "Auto" : slot.toString()}? This cannot be undone.',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await SaveManager.deleteSlot(slot);
      _loadSlots();
    }
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.slot,
    required this.meta,
    required this.onLoad,
    required this.onDelete,
  });

  final int slot;
  final SaveSlotMeta? meta;
  final VoidCallback? onLoad;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isEmpty = meta == null;
    final slotLabel = slot == 0 ? 'Auto-Save' : 'Slot $slot';

    return GestureDetector(
      onTap: onLoad,
      onLongPress: onDelete,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isEmpty
              ? LoreforgeColors.surface
              : LoreforgeColors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isEmpty
                ? LoreforgeColors.borderMuted
                : LoreforgeColors.border,
          ),
        ),
        child: isEmpty
            ? Row(
                children: [
                  const Icon(Icons.block,
                      size: 16, color: LoreforgeColors.textMuted),
                  const SizedBox(width: 10),
                  Text(
                    '$slotLabel — Empty',
                    style: const TextStyle(
                      fontSize: 13,
                      color: LoreforgeColors.textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  // Genre icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: GenreTheme.accentColor(meta!.genre)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      GenreTheme.genreIcon(meta!.genre),
                      color: GenreTheme.accentColor(meta!.genre),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              slotLabel,
                              style: const TextStyle(
                                fontFamily: 'Cinzel',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: LoreforgeColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              meta!.genre,
                              style: TextStyle(
                                fontSize: 11,
                                color: GenreTheme.accentColor(meta!.genre),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${meta!.sceneCount} scenes \u2022 ${_formatDate(meta!.savedAt)}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: LoreforgeColors.textMuted,
                          ),
                        ),
                        if (meta!.summaryPreview.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            meta!.summaryPreview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: LoreforgeColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Delete
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline,
                          size: 16, color: LoreforgeColors.textMuted),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 28, minHeight: 28),
                    ),
                ],
              ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}/${date.year}';
  }
}
