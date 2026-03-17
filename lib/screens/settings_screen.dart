import 'package:flutter/material.dart';
import '../theme/loreforge_theme.dart';

/// Settings dialog.
///
/// Designed to be shown via [showDialog], not pushed as a route. Content
/// is minimal for the initial release — placeholder rows are present so the
/// dialog is non-trivially populated.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
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
            // ── Header ────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
              decoration: BoxDecoration(
                color: LoreforgeColors.accentGoldDim.withValues(alpha: 0.2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                border: const Border(
                  bottom: BorderSide(color: LoreforgeColors.border, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Settings',
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

            // ── Settings rows ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const _SettingRow(
                    label: 'Music Volume',
                    child: _VolumeSlider(initialValue: 0.7),
                  ),
                  const SizedBox(height: 16),
                  const _SettingRow(
                    label: 'SFX Volume',
                    child: _VolumeSlider(initialValue: 1.0),
                  ),
                  const SizedBox(height: 16),
                  const _SettingRow(
                    label: 'Text Speed',
                    child: Text(
                      'Normal',
                      style: TextStyle(
                        color: LoreforgeColors.accentGold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Version watermark
                  const Text(
                    'LoreForge v1.0.0',
                    style: TextStyle(
                      fontSize: 11,
                      color: LoreforgeColors.textMuted,
                      letterSpacing: 0.5,
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

// ── Private helpers ────────────────────────────────────────────────────────

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: LoreforgeColors.textSecondary,
          ),
        ),
        child,
      ],
    );
  }
}

class _VolumeSlider extends StatefulWidget {
  const _VolumeSlider({required this.initialValue});

  final double initialValue;

  @override
  State<_VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<_VolumeSlider> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: LoreforgeColors.accentGold,
          inactiveTrackColor: LoreforgeColors.border,
          thumbColor: LoreforgeColors.accentGold,
          overlayColor: LoreforgeColors.accentGold.withValues(alpha: 0.15),
          trackHeight: 3,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
        ),
        child: Slider(
          value: _value,
          onChanged: (v) => setState(() => _value = v),
        ),
      ),
    );
  }
}
