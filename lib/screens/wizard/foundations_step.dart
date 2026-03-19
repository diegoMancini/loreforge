import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/session_zero_provider.dart';
import '../../theme/genre_theme.dart';

/// Combined step 1: Language + Adventure Mode + Setup Method.
///
/// Merges the old language_step, mode_step, and setup_method_step into a
/// single scrollable screen to reduce wizard length from 7 → 4 steps.
class FoundationsStep extends ConsumerWidget {
  const FoundationsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionZeroProvider);
    final notifier = ref.read(sessionZeroProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Language ────────────────────────────────────────────────
          _sectionHeader('Language', 'Choose the language for your adventure.'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _languages
                .map((l) => _LangChip(
                      lang: l,
                      isSelected: session.language == l.value,
                      onTap: () => notifier.updateLanguage(l.value),
                    ))
                .toList(),
          ),

          _divider(),

          // ── Adventure Mode ──────────────────────────────────────────
          _sectionHeader('Adventure Mode', 'How will you experience your story?'),
          const SizedBox(height: 12),
          ..._modes.map((m) => _CompactRadioCard(
                icon: m.icon,
                label: m.label,
                subtitle: m.subtitle,
                isSelected: session.mode == m.value,
                onTap: () => notifier.updateMode(m.value),
              )),

          _divider(),

          // ── Setup Method ────────────────────────────────────────────
          _sectionHeader('Setup Method', 'How do you want to build your adventure?'),
          const SizedBox(height: 12),
          ..._methods.map((m) => _CompactRadioCard(
                icon: m.icon,
                label: m.label,
                subtitle: m.subtitle,
                isSelected: session.setupMethod == m.value,
                onTap: () => notifier.updateSetupMethod(m.value),
              )),
        ],
      ),
    );
  }

  // ── Data ─────────────────────────────────────────────────────────────

  static const _languages = [
    _LangOption('en', 'English', '\u{1F1FA}\u{1F1F8}'),
    _LangOption('es', 'Espa\u{00F1}ol', '\u{1F1EA}\u{1F1F8}'),
    _LangOption('pt', 'Portugu\u{00EA}s', '\u{1F1E7}\u{1F1F7}'),
    _LangOption('fr', 'Fran\u{00E7}ais', '\u{1F1EB}\u{1F1F7}'),
    _LangOption('de', 'Deutsch', '\u{1F1E9}\u{1F1EA}'),
    _LangOption('it', 'Italiano', '\u{1F1EE}\u{1F1F9}'),
    _LangOption('ja', '\u{65E5}\u{672C}\u{8A9E}', '\u{1F1EF}\u{1F1F5}'),
    _LangOption('ko', '\u{D55C}\u{AD6D}\u{C5B4}', '\u{1F1F0}\u{1F1F7}'),
    _LangOption('zh', '\u{4E2D}\u{6587}', '\u{1F1E8}\u{1F1F3}'),
  ];

  static const _modes = [
    _RadioOption('pure_story', 'Pure Story', Icons.menu_book,
        'Emotional depth, character arcs, and choices that test your values.'),
    _RadioOption('rpg', 'RPG Adventure', Icons.casino,
        'Stats, skill checks, inventory, and tactical choices shape your journey.'),
  ];

  static const _methods = [
    _RadioOption('questions', 'Guided Questions', Icons.quiz,
        'Answer a series of questions to shape your world and character.'),
    _RadioOption('prompt', 'Custom Prompt', Icons.edit_note,
        'Write your own premise and let the AI build around your vision.'),
  ];

  // ── Shared builders ──────────────────────────────────────────────────

  static Widget _sectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: LoreforgeColors.textPrimary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: LoreforgeColors.textSecondary,
          ),
        ),
      ],
    );
  }

  static Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Divider(color: LoreforgeColors.border, height: 1),
    );
  }
}

// ── Models ──────────────────────────────────────────────────────────────────

class _LangOption {
  final String value, label, flag;
  const _LangOption(this.value, this.label, this.flag);
}

class _RadioOption {
  final String value, label, subtitle;
  final IconData icon;
  const _RadioOption(this.value, this.label, this.icon, this.subtitle);
}

// ── Widgets ─────────────────────────────────────────────────────────────────

class _LangChip extends StatelessWidget {
  const _LangChip({required this.lang, required this.isSelected, required this.onTap});
  final _LangOption lang;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? LoreforgeColors.accent.withValues(alpha: 0.18)
              : LoreforgeColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? LoreforgeColors.accent : LoreforgeColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(lang.flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              lang.label,
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? LoreforgeColors.accent : LoreforgeColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactRadioCard extends StatelessWidget {
  const _CompactRadioCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label, subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? LoreforgeColors.accent.withValues(alpha: 0.12)
                : LoreforgeColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? LoreforgeColors.accent : LoreforgeColors.border,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: LoreforgeColors.accent.withValues(alpha: 0.12), blurRadius: 12)]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? LoreforgeColors.accent.withValues(alpha: 0.2)
                        : LoreforgeColors.border,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon,
                      color: isSelected ? LoreforgeColors.accent : LoreforgeColors.textMuted,
                      size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? LoreforgeColors.accent : LoreforgeColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 11, height: 1.3, color: LoreforgeColors.textSecondary)),
                    ],
                  ),
                ),
                _RadioDot(isSelected: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.isSelected});
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? LoreforgeColors.accent : LoreforgeColors.textMuted,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: LoreforgeColors.accent,
                ),
              ),
            )
          : null,
    );
  }
}
