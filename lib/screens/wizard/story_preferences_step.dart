import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/session_zero_provider.dart';
import '../../theme/genre_theme.dart';

/// Final wizard step: custom prompt, additional inspirations, plot twists.
class StoryPreferencesStep extends ConsumerStatefulWidget {
  const StoryPreferencesStep({super.key});

  @override
  ConsumerState<StoryPreferencesStep> createState() =>
      _StoryPreferencesStepState();
}

class _StoryPreferencesStepState extends ConsumerState<StoryPreferencesStep> {
  late TextEditingController _promptCtrl;
  late TextEditingController _storyCtrl;

  @override
  void initState() {
    super.initState();
    final session = ref.read(sessionZeroProvider);
    _promptCtrl = TextEditingController(text: session.customPrompt);
    _storyCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _promptCtrl.dispose();
    _storyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionZeroProvider);
    final notifier = ref.read(sessionZeroProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Custom Instructions ────────────────────────────────────
          const Text(
            'Custom Instructions',
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
            'Give the AI additional creative direction for your story.',
            style: TextStyle(fontSize: 13, color: LoreforgeColors.textSecondary),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _promptCtrl,
            maxLines: 4,
            maxLength: 500,
            onChanged: notifier.updateCustomPrompt,
            style: const TextStyle(
                fontSize: 13, color: LoreforgeColors.textPrimary, height: 1.4),
            decoration: InputDecoration(
              hintText:
                  'e.g. "I want a morally grey protagonist who starts as a villain..." '
                  'or "Focus on political intrigue and slow-burn tension..."',
              hintStyle: TextStyle(
                  color: LoreforgeColors.textMuted.withValues(alpha: 0.5),
                  fontSize: 12),
              filled: true,
              fillColor: LoreforgeColors.surface,
              counterStyle:
                  const TextStyle(fontSize: 10, color: LoreforgeColors.textMuted),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: LoreforgeColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: LoreforgeColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: LoreforgeColors.accent),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: LoreforgeColors.border, height: 1),
          ),

          // ── Additional Inspirations ────────────────────────────────
          const Text(
            'Additional Inspirations',
            style: TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: LoreforgeColors.textPrimary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add any other stories, authors, or references not in the curated list.',
            style: TextStyle(fontSize: 12, color: LoreforgeColors.textMuted),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _storyCtrl,
                  style: const TextStyle(
                      fontSize: 13, color: LoreforgeColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'e.g. "Disco Elysium", "Ursula K. Le Guin"...',
                    hintStyle: TextStyle(
                        color: LoreforgeColors.textMuted.withValues(alpha: 0.5),
                        fontSize: 12),
                    filled: true,
                    fillColor: LoreforgeColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: LoreforgeColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: LoreforgeColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: LoreforgeColors.accent),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onSubmitted: (v) => _addStory(notifier),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _addStory(notifier),
                icon: const Icon(Icons.add_circle, color: LoreforgeColors.accent),
                tooltip: 'Add',
              ),
            ],
          ),
          if (session.favoriteStories.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: session.favoriteStories
                  .map((s) => Chip(
                        label: Text(s,
                            style: const TextStyle(
                                fontSize: 11,
                                color: LoreforgeColors.textPrimary)),
                        deleteIcon: const Icon(Icons.close,
                            size: 14, color: LoreforgeColors.textMuted),
                        onDeleted: () => notifier.removeFavoriteStory(s),
                        backgroundColor:
                            LoreforgeColors.accent.withValues(alpha: 0.1),
                        side: BorderSide(
                            color:
                                LoreforgeColors.accent.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ))
                  .toList(),
            ),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: LoreforgeColors.border, height: 1),
          ),

          // ── Plot Twists ────────────────────────────────────────────
          GestureDetector(
            onTap: notifier.toggleTwists,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: session.twistsEnabled
                    ? LoreforgeColors.accent.withValues(alpha: 0.1)
                    : LoreforgeColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: session.twistsEnabled
                      ? LoreforgeColors.accent
                      : LoreforgeColors.border,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: session.twistsEnabled
                          ? LoreforgeColors.accent.withValues(alpha: 0.2)
                          : LoreforgeColors.border,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.auto_awesome,
                        color: session.twistsEnabled
                            ? LoreforgeColors.accent
                            : LoreforgeColors.textMuted,
                        size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plot Twists',
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: session.twistsEnabled
                                ? LoreforgeColors.accent
                                : LoreforgeColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Allow unexpected turns that reshape the story.',
                          style: TextStyle(
                              fontSize: 11,
                              color: LoreforgeColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: session.twistsEnabled,
                    onChanged: (_) => notifier.toggleTwists(),
                    activeColor: LoreforgeColors.accent,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.info_outline,
                  size: 14, color: LoreforgeColors.textMuted),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'All fields are optional. The AI will fill in the rest based on your genre and tone.',
                  style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: LoreforgeColors.textMuted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addStory(SessionZeroNotifier notifier) {
    final text = _storyCtrl.text.trim();
    if (text.isNotEmpty) {
      notifier.addFavoriteStory(text);
      _storyCtrl.clear();
    }
  }
}
