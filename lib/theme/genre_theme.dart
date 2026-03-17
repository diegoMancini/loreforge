// Re-export LoreforgeColors from this file so that wizard steps that import
// only `genre_theme.dart` can still reference `LoreforgeColors`.
export 'loreforge_theme.dart' show LoreforgeColors;

import 'package:flutter/material.dart';

/// Genre-specific color and icon helpers for LoreForge UI.
///
/// This class is intentionally kept separate from [LoreforgeColors] so that
/// callers can import it with a `show GenreTheme` clause to avoid ambiguity
/// with `LoreforgeColors` defined in `loreforge_theme.dart`.
class GenreTheme {
  GenreTheme._();

  // ---------------------------------------------------------------------------
  // Accent colors — primary tint per genre
  // ---------------------------------------------------------------------------

  static Color accentColor(String genre) {
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
      case 'romance':
        return const Color(0xFFF472B6); // rose
      case 'thriller':
        return const Color(0xFFFBBF24); // amber
      case 'war':
        return const Color(0xFF6B7280); // steel
      case 'historical':
        return const Color(0xFFB45309); // bronze
      case 'western':
        return const Color(0xFFD97706); // tan
      case 'cyberpunk':
        return const Color(0xFF34D399); // neon green
      case 'mythology':
        return const Color(0xFFEAB308); // gold-yellow
      default:
        return const Color(0xFFD4A853);
    }
  }

  // ---------------------------------------------------------------------------
  // Dark background tint — used for top-bar genre badge
  // ---------------------------------------------------------------------------

  static Color darkBgColor(String genre) {
    switch (genre.toLowerCase()) {
      case 'fantasy':
        return const Color(0xFF1A1408);
      case 'horror':
        return const Color(0xFF1A0606);
      case 'mystery':
        return const Color(0xFF0E0E1F);
      case 'sci-fi':
      case 'scifi':
        return const Color(0xFF061418);
      case 'romance':
        return const Color(0xFF1A0A10);
      case 'thriller':
        return const Color(0xFF1A1206);
      case 'war':
        return const Color(0xFF0F1014);
      case 'historical':
        return const Color(0xFF1A1006);
      case 'western':
        return const Color(0xFF1A1206);
      case 'cyberpunk':
        return const Color(0xFF061A10);
      default:
        return const Color(0xFF1A1408);
    }
  }

  // ---------------------------------------------------------------------------
  // Border color — subtle tint for genre badge borders
  // ---------------------------------------------------------------------------

  static Color borderColor(String genre) {
    return accentColor(genre).withValues(alpha: 0.35);
  }

  // ---------------------------------------------------------------------------
  // Genre icon — representative Material icon per genre
  // ---------------------------------------------------------------------------

  static IconData genreIcon(String genre) {
    switch (genre.toLowerCase()) {
      case 'fantasy':
        return Icons.auto_awesome;
      case 'horror':
        return Icons.nightlight;
      case 'mystery':
        return Icons.search;
      case 'sci-fi':
      case 'scifi':
        return Icons.rocket_launch;
      case 'romance':
        return Icons.favorite;
      case 'thriller':
        return Icons.timer;
      case 'war':
        return Icons.shield;
      case 'historical':
        return Icons.account_balance;
      case 'western':
        return Icons.landscape;
      case 'cyberpunk':
        return Icons.memory;
      case 'mythology':
        return Icons.brightness_high;
      default:
        return Icons.auto_stories;
    }
  }
}
