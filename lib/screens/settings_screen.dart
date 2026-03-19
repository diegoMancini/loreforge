import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../theme/loreforge_theme.dart';

/// Full settings dialog with API key management, audio, and display controls.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _anthropicCtrl;
  late TextEditingController _openaiCtrl;
  late TextEditingController _deepseekCtrl;

  bool _showAnthropicKey = false;
  bool _showOpenaiKey = false;
  bool _showDeepseekKey = false;

  @override
  void initState() {
    super.initState();
    final s = ref.read(settingsProvider);
    _anthropicCtrl = TextEditingController(text: s.anthropicApiKey ?? '');
    _openaiCtrl = TextEditingController(text: s.openaiApiKey ?? '');
    _deepseekCtrl = TextEditingController(text: s.deepseekApiKey ?? '');
  }

  @override
  void dispose() {
    _anthropicCtrl.dispose();
    _openaiCtrl.dispose();
    _deepseekCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
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
            // ── Header ──────────────────────────────────────────
            _header(context),

            // ── Scrollable body ─────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── AI Provider Keys ────────────────────────
                    _sectionLabel('AI Providers'),
                    const SizedBox(height: 8),
                    _apiKeyField(
                      label: 'Anthropic (Claude)',
                      hint: 'sk-ant-...',
                      controller: _anthropicCtrl,
                      visible: _showAnthropicKey,
                      onToggleVisible: () =>
                          setState(() => _showAnthropicKey = !_showAnthropicKey),
                      onSave: notifier.setAnthropicApiKey,
                      isSet: settings.anthropicApiKey?.isNotEmpty ?? false,
                    ),
                    const SizedBox(height: 10),
                    _apiKeyField(
                      label: 'OpenAI (GPT-4o)',
                      hint: 'sk-...',
                      controller: _openaiCtrl,
                      visible: _showOpenaiKey,
                      onToggleVisible: () =>
                          setState(() => _showOpenaiKey = !_showOpenaiKey),
                      onSave: notifier.setOpenaiApiKey,
                      isSet: settings.openaiApiKey?.isNotEmpty ?? false,
                    ),
                    const SizedBox(height: 10),
                    _apiKeyField(
                      label: 'DeepSeek',
                      hint: 'sk-...',
                      controller: _deepseekCtrl,
                      visible: _showDeepseekKey,
                      onToggleVisible: () =>
                          setState(() => _showDeepseekKey = !_showDeepseekKey),
                      onSave: notifier.setDeepseekApiKey,
                      isSet: settings.deepseekApiKey?.isNotEmpty ?? false,
                    ),
                    const SizedBox(height: 12),

                    // ── Preferred Provider ──────────────────────
                    _settingRow(
                      'Preferred Provider',
                      DropdownButton<String>(
                        value: settings.preferredProvider,
                        dropdownColor: LoreforgeColors.surface,
                        style: const TextStyle(
                          color: LoreforgeColors.accentGold,
                          fontSize: 13,
                        ),
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(
                              value: 'auto', child: Text('Auto (smart routing)')),
                          DropdownMenuItem(
                              value: 'anthropic', child: Text('Anthropic')),
                          DropdownMenuItem(
                              value: 'openai', child: Text('OpenAI')),
                          DropdownMenuItem(
                              value: 'deepseek', child: Text('DeepSeek')),
                        ],
                        onChanged: (v) {
                          if (v != null) notifier.setPreferredProvider(v);
                        },
                      ),
                    ),

                    const Divider(
                      color: LoreforgeColors.border,
                      height: 28,
                    ),

                    // ── Display ─────────────────────────────────
                    _sectionLabel('Display'),
                    const SizedBox(height: 8),
                    _sliderRow(
                      'Text Size',
                      settings.textSize,
                      12,
                      24,
                      '${settings.textSize.round()}pt',
                      notifier.setTextSize,
                    ),
                    const SizedBox(height: 8),
                    _sliderRow(
                      'Text Speed',
                      settings.textSpeed,
                      0.5,
                      3.0,
                      _speedLabel(settings.textSpeed),
                      notifier.setTextSpeed,
                    ),

                    const Divider(
                      color: LoreforgeColors.border,
                      height: 28,
                    ),

                    // ── Audio ───────────────────────────────────
                    _sectionLabel('Audio'),
                    const SizedBox(height: 8),
                    _sliderRow(
                      'Music',
                      settings.musicVolume,
                      0,
                      1,
                      '${(settings.musicVolume * 100).round()}%',
                      notifier.setMusicVolume,
                    ),
                    const SizedBox(height: 8),
                    _sliderRow(
                      'SFX',
                      settings.sfxVolume,
                      0,
                      1,
                      '${(settings.sfxVolume * 100).round()}%',
                      notifier.setSfxVolume,
                    ),

                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'LoreForge v1.0.0-beta',
                        style: TextStyle(
                          fontSize: 11,
                          color: LoreforgeColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Builders ─────────────────────────────────────────────────────────────

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
      decoration: BoxDecoration(
        color: LoreforgeColors.accentGoldDim.withValues(alpha: 0.2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
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
            icon: const Icon(Icons.close,
                color: LoreforgeColors.textMuted, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: LoreforgeColors.accentGold.withValues(alpha: 0.7),
        letterSpacing: 1.4,
      ),
    );
  }

  Widget _settingRow(String label, Widget trailing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, color: LoreforgeColors.textSecondary)),
        trailing,
      ],
    );
  }

  Widget _sliderRow(String label, double value, double min, double max,
      String display, void Function(double) onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 14, color: LoreforgeColors.textSecondary)),
        ),
        Expanded(
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
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 48,
          child: Text(display,
              textAlign: TextAlign.end,
              style: const TextStyle(
                  fontSize: 13, color: LoreforgeColors.accentGold)),
        ),
      ],
    );
  }

  Widget _apiKeyField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggleVisible,
    required void Function(String?) onSave,
    required bool isSet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: LoreforgeColors.textSecondary)),
            const Spacer(),
            if (isSet)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Active',
                    style: TextStyle(fontSize: 10, color: Colors.green)),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: !visible,
                style: const TextStyle(
                    fontSize: 13, color: LoreforgeColors.textPrimary),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                      color: LoreforgeColors.textMuted.withValues(alpha: 0.5),
                      fontSize: 13),
                  filled: true,
                  fillColor: LoreforgeColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: LoreforgeColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: LoreforgeColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: LoreforgeColors.accentGold),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  suffixIcon: IconButton(
                    icon: Icon(
                      visible ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                      color: LoreforgeColors.textMuted,
                    ),
                    onPressed: onToggleVisible,
                  ),
                ),
                onChanged: (v) => onSave(v.isEmpty ? null : v),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _speedLabel(double speed) {
    if (speed <= 0.7) return 'Slow';
    if (speed <= 1.3) return 'Normal';
    if (speed <= 2.0) return 'Fast';
    return 'Instant';
  }
}
