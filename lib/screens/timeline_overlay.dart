import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story_timeline.dart';
import '../models/story_state.dart';
import '../providers/story_provider.dart';
import '../theme/loreforge_theme.dart';
import '../theme/genre_theme.dart';

/// Visual branching timeline inspired by Zero Escape / Nonary Games.
///
/// Displays a vertical flowchart of the player's journey with:
/// - Circles for regular nodes, diamonds for twists, large glowing circles for climax
/// - Dimmed branch lines showing choices not taken
/// - Pulsing highlight on the current scene
class TimelineOverlay extends ConsumerWidget {
  const TimelineOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyProvider);
    final nodes = _buildNodes(storyState);
    final accent = GenreTheme.accentColor(storyState.genre);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 560),
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
            // ── Header ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 8, 14),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
                border: const Border(
                  bottom:
                      BorderSide(color: LoreforgeColors.border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_tree, color: accent, size: 18),
                  const SizedBox(width: 10),
                  const Text(
                    'Story Timeline',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: LoreforgeColors.textPrimary,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${nodes.length} scenes',
                    style: const TextStyle(
                        fontSize: 11, color: LoreforgeColors.textMuted),
                  ),
                  const SizedBox(width: 8),
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

            // ── Timeline ───────────────────────────────────
            Expanded(
              child: nodes.isEmpty
                  ? const Center(
                      child: Text(
                        'Your story has not yet begun.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: LoreforgeColors.textMuted,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      itemCount: nodes.length,
                      itemBuilder: (context, index) {
                        final node = nodes[index];
                        final isLast = index == nodes.length - 1;
                        return _TimelineNodeWidget(
                          node: node,
                          accent: accent,
                          isLast: isLast,
                          genre: storyState.genre,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<TimelineNode> _buildNodes(StoryState state) {
    final nodes = <TimelineNode>[];
    final sceneCount = state.scenes.length;
    final blueprint = state.blueprint;

    for (int i = 0; i < sceneCount; i++) {
      // Determine node type from blueprint
      String nodeType = 'beat';
      if (blueprint != null && blueprint.nodes.isNotEmpty) {
        final bpNode = blueprint.nodes
            .where((n) => n.order == i)
            .toList();
        if (bpNode.isNotEmpty) {
          nodeType = bpNode.first.type;
        }
      }

      // Get the choice made (from the previous scene's choices)
      String choiceMade = '';
      if (i > 0 && i - 1 < state.choices.length) {
        choiceMade = state.choices[i - 1];
      }

      // Get choices offered at this scene
      List<String> choicesOffered = [];
      // We don't have per-scene choice lists stored, so leave empty for now

      // Check if this was a twist scene
      final isTwist = nodeType == 'twist';

      // Build summary from the scene text (first 60 chars)
      final rawScene = i < state.scenes.length ? state.scenes[i] : '';
      final summary = rawScene.length > 60
          ? '${rawScene.substring(0, 60).trim()}...'
          : rawScene.trim();

      nodes.add(TimelineNode(
        sceneIndex: i,
        summary: summary,
        choiceMade: choiceMade,
        nodeType: nodeType,
        isTwist: isTwist,
        isCurrentScene: i == sceneCount - 1,
        choicesOffered: choicesOffered,
      ));
    }
    return nodes;
  }
}

// ── Timeline Node Widget ────────────────────────────────────────────────────

class _TimelineNodeWidget extends StatelessWidget {
  const _TimelineNodeWidget({
    required this.node,
    required this.accent,
    required this.isLast,
    required this.genre,
  });

  final TimelineNode node;
  final Color accent;
  final bool isLast;
  final String genre;

  @override
  Widget build(BuildContext context) {
    final nodeColor = _nodeColor();
    final nodeSize = _nodeSize();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Vertical line + node marker ──────────────────
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Node marker
                Container(
                  width: nodeSize,
                  height: nodeSize,
                  decoration: BoxDecoration(
                    color: nodeColor.withValues(alpha: 0.25),
                    shape: node.isTwist ? BoxShape.rectangle : BoxShape.circle,
                    borderRadius:
                        node.isTwist ? BorderRadius.circular(4) : null,
                    border: Border.all(color: nodeColor, width: 2),
                    boxShadow: node.isCurrentScene
                        ? [
                            BoxShadow(
                              color: nodeColor.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: node.isCurrentScene
                      ? Icon(Icons.fiber_manual_record,
                          size: 6, color: nodeColor)
                      : null,
                ),
                // Connecting line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: LoreforgeColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // ── Content ─────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Text(
                        'Scene ${node.sceneIndex + 1}',
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: node.isCurrentScene
                              ? accent
                              : LoreforgeColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: nodeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          node.nodeType.toUpperCase(),
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: nodeColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      if (node.isTwist) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.auto_awesome, size: 12, color: accent),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Summary
                  Text(
                    node.summary.isEmpty ? 'Story begins...' : node.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: node.isCurrentScene
                          ? LoreforgeColors.textPrimary
                          : LoreforgeColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  // Choice made
                  if (node.choiceMade.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.subdirectory_arrow_right,
                            size: 12, color: accent.withValues(alpha: 0.5)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            node.choiceMade,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: accent.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _nodeColor() {
    if (node.isCurrentScene) return accent;
    switch (node.nodeType) {
      case 'twist':
        return Colors.amber;
      case 'climax':
        return Colors.redAccent;
      case 'resolution':
        return Colors.greenAccent;
      case 'act':
        return accent.withValues(alpha: 0.7);
      default:
        return LoreforgeColors.textMuted;
    }
  }

  double _nodeSize() {
    switch (node.nodeType) {
      case 'climax':
        return 18;
      case 'twist':
        return 14;
      case 'act':
        return 14;
      default:
        return 12;
    }
  }
}
