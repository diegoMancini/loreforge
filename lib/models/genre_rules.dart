class GenreRules {
  static const Map<String, Map<String, dynamic>> rules = {
    'Fantasy': {
      'tone': 'epic, magical, wondrous',
      'elements': ['magic systems', 'mythical creatures', 'heroic quests'],
      'twist_types': ['scope escalation', 'prophecy reinterpretation', 'hidden identity'],
      'craft_focus': 'worldbuilding, character growth, moral choices',
    },
    'Horror': {
      'tone': 'tense, suspenseful, terrifying',
      'elements': ['psychological tension', 'unknown threats', 'survival horror'],
      'twist_types': ['false safety', 'real monster reveal', 'protagonist threat'],
      'craft_focus': 'atmosphere, pacing, emotional impact',
    },
    'Mystery': {
      'tone': 'intriguing, intellectual, suspenseful',
      'elements': ['clues', 'red herrings', 'detective work'],
      'twist_types': ['double cross', 'cascading revelations', 'unreliable witness'],
      'craft_focus': 'puzzle design, misdirection, fair play',
    },
    'Sci-Fi': {
      'tone': 'speculative, futuristic, philosophical',
      'elements': ['technology', 'space', 'alternate realities'],
      'twist_types': ['paradigm shift', 'time loop', 'technology betrayal'],
      'craft_focus': 'worldbuilding, scientific accuracy, thematic depth',
    },
  };

  static Map<String, dynamic> getRules(String genre) {
    return rules[genre] ?? rules['Fantasy']!;
  }
}