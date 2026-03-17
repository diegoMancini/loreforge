import 'package:flutter/material.dart';

/// Semantic color palette for the LoreForge dark fantasy UI.
///
/// All hex values are defined once here; nothing else in the codebase should
/// use raw Color(0x…) literals for these semantics.
class LoreforgeColors {
  LoreforgeColors._();

  // ── Core background surfaces ──────────────────────────────────────────────
  static const background = Color(0xFF06060F);
  static const surface = Color(0xFF0F0F1A);
  static const surfaceElevated = Color(0xFF161625);
  static const surfaceOverlay = Color(0xFF1C1C2E);

  // ── Borders ───────────────────────────────────────────────────────────────
  static const border = Color(0xFF2A2A3E);
  static const borderMuted = Color(0xFF1E1E2E);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFFF0E8D5);
  static const textSecondary = Color(0xFFB8A898);
  static const textMuted = Color(0xFF6B5F5F);

  // ── Genre accent (default; overridden per-genre at runtime) ───────────────
  static const accentGold = Color(0xFFD4A853);
  static const accentGoldDim = Color(0xFF8B6914);

  // ── Error colors ─────────────────────────────────────────────────────────
  static const error = Color(0xFFF87171);
  static const errorLight = Color(0xFFFCA5A5);
  static const errorBg = Color(0xFF450A0A);
  static const errorBorder = Color(0xFF7F1D1D);

  // ── Success colors ────────────────────────────────────────────────────────
  static const success = Color(0xFF4ADE80);
  static const successBg = Color(0xFF0A1E10);
  static const successBorder = Color(0xFF14532D);

  // ── Warning colors ────────────────────────────────────────────────────────
  static const warning = Color(0xFFF59E0B);
  static const warningBg = Color(0xFF451A03);

  // ── UI chrome ─────────────────────────────────────────────────────────────
  static const snackBarBg = Color(0xFF1E293B);

  // ── Genre accent lookup ───────────────────────────────────────────────────

  /// Returns the primary accent color for a given genre string.
  static Color genreAccent(String genre) {
    switch (genre.toLowerCase()) {
      case 'fantasy':
        return const Color(0xFFD4A853); // gold
      case 'horror':
        return const Color(0xFFDC2626); // blood red
      case 'mystery':
        return const Color(0xFF818CF8); // violet
      case 'sci-fi':
      case 'scifi':
        return const Color(0xFF22D3EE); // cyan
      default:
        return accentGold;
    }
  }

  /// Returns a dim/muted variant of the genre accent for backgrounds.
  static Color genreAccentDim(String genre) {
    switch (genre.toLowerCase()) {
      case 'fantasy':
        return const Color(0xFF8B6914);
      case 'horror':
        return const Color(0xFF7F1D1D);
      case 'mystery':
        return const Color(0xFF312E81);
      case 'sci-fi':
      case 'scifi':
        return const Color(0xFF164E63);
      default:
        return accentGoldDim;
    }
  }
}

/// Material ThemeData wired with LoreForge dark palette.
class LoreforgeTheme {
  LoreforgeTheme._();

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: LoreforgeColors.background,
      colorScheme: const ColorScheme.dark(
        surface: LoreforgeColors.surface,
        primary: LoreforgeColors.accentGold,
        error: LoreforgeColors.error,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: LoreforgeColors.surface,
      ),
      dividerColor: LoreforgeColors.border,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: LoreforgeColors.snackBarBg,
        contentTextStyle: TextStyle(color: LoreforgeColors.textPrimary),
      ),
      useMaterial3: true,
    );
  }
}
