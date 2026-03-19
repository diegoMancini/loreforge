import 'package:flutter/material.dart';

class Subgenre {
  final String name;
  final String tagline;
  const Subgenre(this.name, this.tagline);
}

class GenreCategory {
  final String name;
  final IconData icon;
  final Color accent;
  final String tagline;
  final List<Subgenre> subgenres;
  const GenreCategory(this.name, this.icon, this.accent, this.tagline, this.subgenres);
}

class GenreCatalog {
  static const List<GenreCategory> categories = [
    GenreCategory('Fantasy', Icons.auto_stories, Color(0xFFD4A853),
        'Magic, myth, and wonder', [
      Subgenre('High Fantasy', 'Epic quests across vast realms'),
      Subgenre('Dark Fantasy', 'Magic has a price in blood'),
      Subgenre('Urban Fantasy', 'Magic hides in modern cities'),
      Subgenre('Fairy Tale', 'Enchanted stories, timeless lessons'),
      Subgenre('Sword & Sorcery', 'Blades clash, spells fly'),
    ]),
    GenreCategory('Sci-Fi', Icons.rocket_launch, Color(0xFF22D3EE),
        'Technology, space, and possibility', [
      Subgenre('Space Opera', 'Epic tales across the stars'),
      Subgenre('Cyberpunk', 'High tech, low life'),
      Subgenre('Hard Sci-Fi', 'Science drives the story'),
      Subgenre('Post-Apocalyptic', 'Civilization has fallen'),
      Subgenre('Time Travel', 'The past and future collide'),
    ]),
    GenreCategory('Horror', Icons.visibility_off, Color(0xFFDC2626),
        'Fear, dread, and the unknown', [
      Subgenre('Cosmic Horror', 'Unknowable forces beyond reason'),
      Subgenre('Gothic', 'Crumbling castles, dark secrets'),
      Subgenre('Psychological', 'The mind is the monster'),
      Subgenre('Survival Horror', 'Scarce resources, constant dread'),
      Subgenre('Folk Horror', 'Ancient rituals, rural terror'),
    ]),
    GenreCategory('Mystery', Icons.search, Color(0xFF818CF8),
        'Clues, deception, and truth', [
      Subgenre('Noir Detective', 'Rain-soaked streets, hard truths'),
      Subgenre('Cozy Mystery', 'Charming puzzles, no gore'),
      Subgenre('Police Procedural', 'By the book, badge and all'),
      Subgenre('Locked Room', 'Impossible crimes, clever solutions'),
      Subgenre('Whodunit', 'Everyone is a suspect'),
    ]),
    GenreCategory('Thriller', Icons.bolt, Color(0xFFFBBF24),
        'Tension, stakes, and velocity', [
      Subgenre('Espionage', 'Shadows, secrets, and spycraft'),
      Subgenre('Legal Thriller', 'Justice hangs in the balance'),
      Subgenre('Psychological Thriller', 'Trust no one, not even yourself'),
      Subgenre('Techno-Thriller', 'Technology as weapon and shield'),
    ]),
    GenreCategory('Romance', Icons.favorite, Color(0xFFF472B6),
        'Heart, passion, and connection', [
      Subgenre('Contemporary', 'Love in the modern world'),
      Subgenre('Historical Romance', 'Passion across the ages'),
      Subgenre('Paranormal Romance', 'Love beyond the natural'),
      Subgenre('Slow Burn', 'Tension builds, hearts ignite'),
    ]),
    GenreCategory('War', Icons.shield, Color(0xFF6B7280),
        'Conflict, sacrifice, and duty', [
      Subgenre('Military Fiction', 'Strategy, combat, brotherhood'),
      Subgenre('Alternate History', 'Wars that never were'),
      Subgenre('Resistance', 'Fighting back from the shadows'),
      Subgenre('Naval', 'Battles on the open sea'),
    ]),
    GenreCategory('Historical', Icons.account_balance, Color(0xFFB45309),
        'The past brought to life', [
      Subgenre('Ancient World', 'Empires of antiquity rise and fall'),
      Subgenre('Medieval', 'Knights, kings, and kingdoms'),
      Subgenre('Renaissance', 'Art, intrigue, and rebirth'),
      Subgenre('Victorian', 'Empire, industry, and secrets'),
      Subgenre('Colonial', 'New worlds, old conflicts'),
    ]),
    GenreCategory('Western', Icons.landscape, Color(0xFFD97706),
        'Dust, honor, and the frontier', [
      Subgenre('Classic Western', 'Lawmen, outlaws, showdowns'),
      Subgenre('Weird West', 'Supernatural meets the frontier'),
      Subgenre('Frontier', 'Taming wild, uncharted land'),
      Subgenre('Outlaw', 'Running from the law, riding free'),
    ]),
    GenreCategory('Mythology', Icons.temple_hindu, Color(0xFFEAB308),
        'Gods, heroes, and legends', [
      Subgenre('Greek', 'Olympus, fate, and hubris'),
      Subgenre('Norse', 'Valhalla, runes, and ragnarok'),
      Subgenre('Egyptian', 'Pharaohs, the Nile, and the afterlife'),
      Subgenre('Japanese', 'Kami, honor, and yokai'),
      Subgenre('Celtic', 'Fae courts, druids, and mist'),
    ]),
    GenreCategory('Steampunk', Icons.precision_manufacturing, Color(0xFFA16207),
        'Gears, steam, and invention', [
      Subgenre('Victorian Steampunk', 'Brass, clockwork, and empire'),
      Subgenre('Dieselpunk', 'Grease, steel, and war machines'),
      Subgenre('Clockpunk', 'Renaissance-era mechanical wonders'),
    ]),
    GenreCategory('Superhero', Icons.flash_on, Color(0xFF3B82F6),
        'Powers, purpose, and identity', [
      Subgenre('Origin Story', 'Discovering what you can become'),
      Subgenre('Anti-Hero', 'Doing wrong for the right reasons'),
      Subgenre('Team Saga', 'Together, unstoppable'),
      Subgenre('Villain Perspective', 'Every villain is the hero of their story'),
    ]),
    GenreCategory('Survival', Icons.terrain, Color(0xFF059669),
        'Endurance against all odds', [
      Subgenre('Wilderness', 'Nature is the enemy'),
      Subgenre('Zombie Apocalypse', 'The dead walk, the living run'),
      Subgenre('Disaster', 'When the world breaks apart'),
      Subgenre('Castaway', 'Alone, far from everything'),
    ]),
    GenreCategory('Noir', Icons.local_bar, Color(0xFF9CA3AF),
        'Shadows, smoke, and moral grey', [
      Subgenre('Classic Noir', 'Femmes fatales and private eyes'),
      Subgenre('Neo-Noir', 'Modern darkness, timeless corruption'),
      Subgenre('Tech Noir', 'Digital age, analog sins'),
    ]),
  ];

  static GenreCategory? findGenre(String name) {
    for (final g in categories) {
      if (g.name == name) return g;
    }
    return null;
  }

  static List<Subgenre> subgenresFor(String genre) {
    return findGenre(genre)?.subgenres ?? [];
  }
}
