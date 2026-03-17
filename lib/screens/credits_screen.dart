import 'package:flutter/material.dart';
import '../theme/loreforge_theme.dart';

/// Credits dialog shown from the main menu.
///
/// Designed to be shown via [showDialog] so it floats over the menu background.
class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: LoreforgeColors.surface.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: LoreforgeColors.accentGold.withValues(alpha: 0.35),
              width: 1.5),
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
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
              decoration: BoxDecoration(
                color: LoreforgeColors.accentGoldDim.withValues(alpha: 0.2),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
                border: const Border(
                  bottom: BorderSide(color: LoreforgeColors.border, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Credits',
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

            // Body
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Title logo
                  const Text(
                    'LOREFORGE',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: LoreforgeColors.accentGold,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: LoreforgeColors.textDim,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _CreditRow(label: 'Design & Development', value: 'LoreForge Team'),
                  const SizedBox(height: 10),
                  _CreditRow(label: 'AI Narrative Engine', value: 'Claude by Anthropic'),
                  const SizedBox(height: 10),
                  _CreditRow(label: 'Built with', value: 'Flutter & Dart'),
                  const SizedBox(height: 10),
                  _CreditRow(label: 'Typography', value: 'Cinzel & Lora'),

                  const SizedBox(height: 24),
                  const Divider(color: LoreforgeColors.border, thickness: 1),
                  const SizedBox(height: 16),

                  const Text(
                    '"Every story is a world waiting to be born."',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: LoreforgeColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditRow extends StatelessWidget {
  const _CreditRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: LoreforgeColors.textMuted,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: LoreforgeColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
