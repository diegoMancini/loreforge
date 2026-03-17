import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/session_zero_provider.dart';
import '../../theme/genre_theme.dart';

class LanguageStep extends ConsumerWidget {
  const LanguageStep({super.key});

  static const _languages = [
    _LangOption(value: 'en', label: 'English', flag: '🇺🇸'),
    _LangOption(value: 'es', label: 'Español', flag: '🇪🇸'),
    _LangOption(value: 'pt', label: 'Português', flag: '🇧🇷'),
    _LangOption(value: 'fr', label: 'Français', flag: '🇫🇷'),
    _LangOption(value: 'de', label: 'Deutsch', flag: '🇩🇪'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionZero = ref.watch(sessionZeroProvider);
    final selected = sessionZero.language;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Language',
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
          'Choose the language for your adventure narrative.',
          style: TextStyle(
            fontSize: 14,
            color: LoreforgeColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _languages
              .map((lang) => _LangChip(
                    lang: lang,
                    isSelected: selected == lang.value,
                    onTap: () => ref
                        .read(sessionZeroProvider.notifier)
                        .updateLanguage(lang.value),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

class _LangOption {
  const _LangOption({
    required this.value,
    required this.label,
    required this.flag,
  });

  final String value;
  final String label;
  final String flag;
}

// ---------------------------------------------------------------------------
// Chip widget
// ---------------------------------------------------------------------------

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.lang,
    required this.isSelected,
    required this.onTap,
  });

  final _LangOption lang;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? LoreforgeColors.accent.withValues(alpha: 0.18)
              : LoreforgeColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? LoreforgeColors.accent : LoreforgeColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: LoreforgeColors.accent.withValues(alpha: 0.2),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              lang.flag,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Text(
              lang.label,
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? LoreforgeColors.accent
                    : LoreforgeColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
