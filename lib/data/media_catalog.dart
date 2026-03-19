enum MediaType { film, book, game, show }

class MediaItem {
  final String title;
  final MediaType type;
  final String year;
  final List<String> genres;
  final List<String> subgenres;
  const MediaItem(this.title, this.type, this.year, this.genres,
      [this.subgenres = const []]);
}

class MediaCatalog {
  /// Returns media items matching [genre] and optionally [subgenre].
  static List<MediaItem> forGenre(String genre, [String? subgenre]) {
    var results = _all.where((m) => m.genres.contains(genre)).toList();
    if (subgenre != null && subgenre.isNotEmpty) {
      final subResults = results.where((m) => m.subgenres.contains(subgenre)).toList();
      if (subResults.isNotEmpty) return subResults;
    }
    return results;
  }

  static const List<MediaItem> _all = [
    // ── Fantasy ──────────────────────────────────────────────────
    MediaItem('The Lord of the Rings', MediaType.film, '2001', ['Fantasy'], ['High Fantasy']),
    MediaItem('The Hobbit', MediaType.book, '1937', ['Fantasy'], ['High Fantasy']),
    MediaItem('A Game of Thrones', MediaType.book, '1996', ['Fantasy'], ['Dark Fantasy']),
    MediaItem('The Name of the Wind', MediaType.book, '2007', ['Fantasy'], ['High Fantasy']),
    MediaItem('The Witcher 3', MediaType.game, '2015', ['Fantasy'], ['Dark Fantasy']),
    MediaItem('Elden Ring', MediaType.game, '2022', ['Fantasy'], ['Dark Fantasy']),
    MediaItem('Dark Souls', MediaType.game, '2011', ['Fantasy'], ['Dark Fantasy']),
    MediaItem("Baldur's Gate 3", MediaType.game, '2023', ['Fantasy'], ['High Fantasy']),
    MediaItem('Game of Thrones', MediaType.show, '2011', ['Fantasy'], ['Dark Fantasy']),
    MediaItem('The Witcher', MediaType.show, '2019', ['Fantasy'], ['Dark Fantasy']),
    MediaItem('Arcane', MediaType.show, '2021', ['Fantasy'], ['Urban Fantasy']),
    MediaItem("Pan's Labyrinth", MediaType.film, '2006', ['Fantasy', 'Horror'], ['Dark Fantasy', 'Folk Horror']),
    MediaItem('Princess Mononoke', MediaType.film, '1997', ['Fantasy'], ['High Fantasy']),
    MediaItem('Stardust', MediaType.film, '2007', ['Fantasy'], ['Fairy Tale']),
    MediaItem('The Princess Bride', MediaType.film, '1987', ['Fantasy'], ['Fairy Tale']),
    MediaItem('Conan the Barbarian', MediaType.film, '1982', ['Fantasy'], ['Sword & Sorcery']),
    MediaItem('The Stormlight Archive', MediaType.book, '2010', ['Fantasy'], ['High Fantasy']),
    MediaItem('American Gods', MediaType.book, '2001', ['Fantasy'], ['Urban Fantasy']),
    MediaItem('Dresden Files', MediaType.book, '2000', ['Fantasy'], ['Urban Fantasy']),
    MediaItem('Wheel of Time', MediaType.show, '2021', ['Fantasy'], ['High Fantasy']),

    // ── Sci-Fi ───────────────────────────────────────────────────
    MediaItem('Blade Runner', MediaType.film, '1982', ['Sci-Fi'], ['Cyberpunk']),
    MediaItem('Blade Runner 2049', MediaType.film, '2017', ['Sci-Fi'], ['Cyberpunk']),
    MediaItem('Interstellar', MediaType.film, '2014', ['Sci-Fi'], ['Hard Sci-Fi']),
    MediaItem('The Martian', MediaType.film, '2015', ['Sci-Fi'], ['Hard Sci-Fi']),
    MediaItem('Arrival', MediaType.film, '2016', ['Sci-Fi'], ['Hard Sci-Fi']),
    MediaItem('Dune', MediaType.film, '2021', ['Sci-Fi'], ['Space Opera']),
    MediaItem('Star Wars', MediaType.film, '1977', ['Sci-Fi'], ['Space Opera']),
    MediaItem('Mad Max: Fury Road', MediaType.film, '2015', ['Sci-Fi'], ['Post-Apocalyptic']),
    MediaItem('Neuromancer', MediaType.book, '1984', ['Sci-Fi'], ['Cyberpunk']),
    MediaItem('Dune', MediaType.book, '1965', ['Sci-Fi'], ['Space Opera']),
    MediaItem('The Expanse', MediaType.book, '2011', ['Sci-Fi'], ['Space Opera']),
    MediaItem('Foundation', MediaType.book, '1951', ['Sci-Fi'], ['Space Opera']),
    MediaItem('The Left Hand of Darkness', MediaType.book, '1969', ['Sci-Fi'], ['Hard Sci-Fi']),
    MediaItem('Cyberpunk 2077', MediaType.game, '2020', ['Sci-Fi'], ['Cyberpunk']),
    MediaItem('Mass Effect', MediaType.game, '2007', ['Sci-Fi'], ['Space Opera']),
    MediaItem('Fallout', MediaType.game, '1997', ['Sci-Fi'], ['Post-Apocalyptic']),
    MediaItem('The Expanse', MediaType.show, '2015', ['Sci-Fi'], ['Space Opera']),
    MediaItem('Black Mirror', MediaType.show, '2011', ['Sci-Fi', 'Thriller'], ['Hard Sci-Fi']),
    MediaItem('Westworld', MediaType.show, '2016', ['Sci-Fi'], ['Cyberpunk']),
    MediaItem('Dark', MediaType.show, '2017', ['Sci-Fi'], ['Time Travel']),

    // ── Horror ───────────────────────────────────────────────────
    MediaItem('The Shining', MediaType.film, '1980', ['Horror'], ['Psychological']),
    MediaItem('Hereditary', MediaType.film, '2018', ['Horror'], ['Psychological']),
    MediaItem('The Witch', MediaType.film, '2015', ['Horror'], ['Folk Horror']),
    MediaItem('Midsommar', MediaType.film, '2019', ['Horror'], ['Folk Horror']),
    MediaItem('Alien', MediaType.film, '1979', ['Horror', 'Sci-Fi'], ['Survival Horror']),
    MediaItem('Get Out', MediaType.film, '2017', ['Horror'], ['Psychological']),
    MediaItem('The Thing', MediaType.film, '1982', ['Horror'], ['Cosmic Horror']),
    MediaItem('House of Leaves', MediaType.book, '2000', ['Horror'], ['Psychological']),
    MediaItem('The Haunting of Hill House', MediaType.book, '1959', ['Horror'], ['Gothic']),
    MediaItem('Frankenstein', MediaType.book, '1818', ['Horror'], ['Gothic']),
    MediaItem('Dracula', MediaType.book, '1897', ['Horror'], ['Gothic']),
    MediaItem('At the Mountains of Madness', MediaType.book, '1936', ['Horror'], ['Cosmic Horror']),
    MediaItem('The Call of Cthulhu', MediaType.book, '1928', ['Horror'], ['Cosmic Horror']),
    MediaItem('Silent Hill 2', MediaType.game, '2001', ['Horror'], ['Psychological', 'Survival Horror']),
    MediaItem('Resident Evil', MediaType.game, '1996', ['Horror'], ['Survival Horror']),
    MediaItem('Amnesia: The Dark Descent', MediaType.game, '2010', ['Horror'], ['Survival Horror']),
    MediaItem('Bloodborne', MediaType.game, '2015', ['Horror', 'Fantasy'], ['Cosmic Horror', 'Gothic']),
    MediaItem('The Haunting of Hill House', MediaType.show, '2018', ['Horror'], ['Gothic']),
    MediaItem('Stranger Things', MediaType.show, '2016', ['Horror'], ['Survival Horror']),

    // ── Mystery ──────────────────────────────────────────────────
    MediaItem('Knives Out', MediaType.film, '2019', ['Mystery'], ['Whodunit']),
    MediaItem('Chinatown', MediaType.film, '1974', ['Mystery', 'Noir'], ['Noir Detective']),
    MediaItem('Se7en', MediaType.film, '1995', ['Mystery', 'Thriller'], ['Police Procedural']),
    MediaItem('Clue', MediaType.film, '1985', ['Mystery'], ['Whodunit']),
    MediaItem('Murder on the Orient Express', MediaType.book, '1934', ['Mystery'], ['Locked Room', 'Whodunit']),
    MediaItem('The Big Sleep', MediaType.book, '1939', ['Mystery', 'Noir'], ['Noir Detective']),
    MediaItem('Gone Girl', MediaType.book, '2012', ['Mystery', 'Thriller'], ['Psychological']),
    MediaItem('The Girl with the Dragon Tattoo', MediaType.book, '2005', ['Mystery', 'Thriller'], ['Police Procedural']),
    MediaItem('Sherlock Holmes', MediaType.book, '1887', ['Mystery'], ['Whodunit']),
    MediaItem('Return of the Obra Dinn', MediaType.game, '2018', ['Mystery'], ['Locked Room']),
    MediaItem('Disco Elysium', MediaType.game, '2019', ['Mystery', 'Noir'], ['Noir Detective']),
    MediaItem('L.A. Noire', MediaType.game, '2011', ['Mystery', 'Noir'], ['Noir Detective', 'Police Procedural']),
    MediaItem('Her Story', MediaType.game, '2015', ['Mystery'], ['Police Procedural']),
    MediaItem('True Detective', MediaType.show, '2014', ['Mystery'], ['Noir Detective']),
    MediaItem('Broadchurch', MediaType.show, '2013', ['Mystery'], ['Police Procedural']),
    MediaItem('Only Murders in the Building', MediaType.show, '2021', ['Mystery'], ['Cozy Mystery']),

    // ── Thriller ─────────────────────────────────────────────────
    MediaItem('No Country for Old Men', MediaType.film, '2007', ['Thriller'], ['Psychological Thriller']),
    MediaItem('The Bourne Identity', MediaType.film, '2002', ['Thriller'], ['Espionage']),
    MediaItem('Sicario', MediaType.film, '2015', ['Thriller'], ['Psychological Thriller']),
    MediaItem('A Few Good Men', MediaType.film, '1992', ['Thriller'], ['Legal Thriller']),
    MediaItem('The Silence of the Lambs', MediaType.film, '1991', ['Thriller', 'Horror'], ['Psychological Thriller']),
    MediaItem('The Spy Who Came in from the Cold', MediaType.book, '1963', ['Thriller'], ['Espionage']),
    MediaItem('The Firm', MediaType.book, '1991', ['Thriller'], ['Legal Thriller']),
    MediaItem('Tinker Tailor Soldier Spy', MediaType.book, '1974', ['Thriller'], ['Espionage']),
    MediaItem('The Girl on the Train', MediaType.book, '2015', ['Thriller'], ['Psychological Thriller']),
    MediaItem('Splinter Cell', MediaType.game, '2002', ['Thriller'], ['Espionage']),
    MediaItem('Metal Gear Solid', MediaType.game, '1998', ['Thriller'], ['Espionage', 'Techno-Thriller']),
    MediaItem('Homeland', MediaType.show, '2011', ['Thriller'], ['Espionage']),
    MediaItem('Breaking Bad', MediaType.show, '2008', ['Thriller'], ['Psychological Thriller']),
    MediaItem('The Americans', MediaType.show, '2013', ['Thriller'], ['Espionage']),
    MediaItem('Mindhunter', MediaType.show, '2017', ['Thriller'], ['Psychological Thriller']),

    // ── Romance ──────────────────────────────────────────────────
    MediaItem('Pride and Prejudice', MediaType.film, '2005', ['Romance', 'Historical'], ['Historical Romance']),
    MediaItem('Before Sunrise', MediaType.film, '1995', ['Romance'], ['Contemporary', 'Slow Burn']),
    MediaItem('The Notebook', MediaType.film, '2004', ['Romance'], ['Contemporary']),
    MediaItem('Twilight', MediaType.film, '2008', ['Romance'], ['Paranormal Romance']),
    MediaItem('Outlander', MediaType.book, '1991', ['Romance', 'Historical'], ['Historical Romance']),
    MediaItem('Pride and Prejudice', MediaType.book, '1813', ['Romance', 'Historical'], ['Historical Romance']),
    MediaItem('The Time Traveler\'s Wife', MediaType.book, '2003', ['Romance', 'Sci-Fi'], ['Paranormal Romance']),
    MediaItem('Normal People', MediaType.book, '2018', ['Romance'], ['Contemporary', 'Slow Burn']),
    MediaItem('Florence', MediaType.game, '2018', ['Romance'], ['Contemporary']),
    MediaItem('Bridgerton', MediaType.show, '2020', ['Romance', 'Historical'], ['Historical Romance']),
    MediaItem('Normal People', MediaType.show, '2020', ['Romance'], ['Contemporary', 'Slow Burn']),
    MediaItem('Fleabag', MediaType.show, '2016', ['Romance'], ['Contemporary']),

    // ── War ──────────────────────────────────────────────────────
    MediaItem('Saving Private Ryan', MediaType.film, '1998', ['War'], ['Military Fiction']),
    MediaItem('Dunkirk', MediaType.film, '2017', ['War'], ['Military Fiction']),
    MediaItem('Apocalypse Now', MediaType.film, '1979', ['War'], ['Military Fiction']),
    MediaItem('Das Boot', MediaType.film, '1981', ['War'], ['Naval']),
    MediaItem('Master and Commander', MediaType.film, '2003', ['War'], ['Naval']),
    MediaItem('Inglourious Basterds', MediaType.film, '2009', ['War'], ['Alternate History', 'Resistance']),
    MediaItem('All Quiet on the Western Front', MediaType.book, '1929', ['War'], ['Military Fiction']),
    MediaItem('The Things They Carried', MediaType.book, '1990', ['War'], ['Military Fiction']),
    MediaItem('The Man in the High Castle', MediaType.book, '1962', ['War', 'Sci-Fi'], ['Alternate History']),
    MediaItem('Call of Duty', MediaType.game, '2003', ['War'], ['Military Fiction']),
    MediaItem('Valiant Hearts', MediaType.game, '2014', ['War'], ['Military Fiction']),
    MediaItem('Band of Brothers', MediaType.show, '2001', ['War'], ['Military Fiction']),
    MediaItem('The Pacific', MediaType.show, '2010', ['War'], ['Military Fiction']),

    // ── Historical ───────────────────────────────────────────────
    MediaItem('Gladiator', MediaType.film, '2000', ['Historical'], ['Ancient World']),
    MediaItem('Braveheart', MediaType.film, '1995', ['Historical'], ['Medieval']),
    MediaItem('The Last Samurai', MediaType.film, '2003', ['Historical'], ['Colonial']),
    MediaItem('Barry Lyndon', MediaType.film, '1975', ['Historical'], ['Victorian']),
    MediaItem('Shogun', MediaType.book, '1975', ['Historical'], ['Colonial']),
    MediaItem('The Pillars of the Earth', MediaType.book, '1989', ['Historical'], ['Medieval']),
    MediaItem('Wolf Hall', MediaType.book, '2009', ['Historical'], ['Renaissance']),
    MediaItem('I, Claudius', MediaType.book, '1934', ['Historical'], ['Ancient World']),
    MediaItem('Assassin\'s Creed', MediaType.game, '2007', ['Historical'], ['Renaissance', 'Medieval']),
    MediaItem('Total War: Rome', MediaType.game, '2004', ['Historical'], ['Ancient World']),
    MediaItem('Vikings', MediaType.show, '2013', ['Historical'], ['Medieval']),
    MediaItem('Rome', MediaType.show, '2005', ['Historical'], ['Ancient World']),
    MediaItem('Shogun', MediaType.show, '2024', ['Historical'], ['Colonial']),
    MediaItem('The Crown', MediaType.show, '2016', ['Historical'], ['Victorian']),

    // ── Western ──────────────────────────────────────────────────
    MediaItem('The Good, the Bad and the Ugly', MediaType.film, '1966', ['Western'], ['Classic Western']),
    MediaItem('Unforgiven', MediaType.film, '1992', ['Western'], ['Classic Western']),
    MediaItem('True Grit', MediaType.film, '2010', ['Western'], ['Classic Western']),
    MediaItem('Django Unchained', MediaType.film, '2012', ['Western'], ['Classic Western']),
    MediaItem('Bone Tomahawk', MediaType.film, '2015', ['Western', 'Horror'], ['Weird West']),
    MediaItem('Blood Meridian', MediaType.book, '1985', ['Western'], ['Classic Western']),
    MediaItem('Lonesome Dove', MediaType.book, '1985', ['Western'], ['Frontier']),
    MediaItem('The Dark Tower', MediaType.book, '1982', ['Western', 'Fantasy'], ['Weird West']),
    MediaItem('Red Dead Redemption 2', MediaType.game, '2018', ['Western'], ['Outlaw', 'Frontier']),
    MediaItem('Weird West', MediaType.game, '2022', ['Western'], ['Weird West']),
    MediaItem('Deadwood', MediaType.show, '2004', ['Western'], ['Frontier']),
    MediaItem('Westworld', MediaType.show, '2016', ['Western', 'Sci-Fi'], ['Weird West']),

    // ── Mythology ────────────────────────────────────────────────
    MediaItem('Troy', MediaType.film, '2004', ['Mythology'], ['Greek']),
    MediaItem('Clash of the Titans', MediaType.film, '2010', ['Mythology'], ['Greek']),
    MediaItem('Thor: Ragnarok', MediaType.film, '2017', ['Mythology'], ['Norse']),
    MediaItem('Spirited Away', MediaType.film, '2001', ['Mythology'], ['Japanese']),
    MediaItem('The Mummy', MediaType.film, '1999', ['Mythology'], ['Egyptian']),
    MediaItem('Circe', MediaType.book, '2018', ['Mythology'], ['Greek']),
    MediaItem('The Song of Achilles', MediaType.book, '2011', ['Mythology'], ['Greek']),
    MediaItem('Norse Mythology', MediaType.book, '2017', ['Mythology'], ['Norse']),
    MediaItem('American Gods', MediaType.book, '2001', ['Mythology'], ['Norse', 'Celtic']),
    MediaItem('Hades', MediaType.game, '2020', ['Mythology'], ['Greek']),
    MediaItem('God of War', MediaType.game, '2018', ['Mythology'], ['Norse', 'Greek']),
    MediaItem('Okami', MediaType.game, '2006', ['Mythology'], ['Japanese']),
    MediaItem('Loki', MediaType.show, '2021', ['Mythology'], ['Norse']),
    MediaItem('Kaos', MediaType.show, '2024', ['Mythology'], ['Greek']),

    // ── Steampunk ────────────────────────────────────────────────
    MediaItem('Steamboy', MediaType.film, '2004', ['Steampunk'], ['Victorian Steampunk']),
    MediaItem('Mortal Engines', MediaType.film, '2018', ['Steampunk'], ['Dieselpunk']),
    MediaItem('Hugo', MediaType.film, '2011', ['Steampunk'], ['Clockpunk']),
    MediaItem('The Difference Engine', MediaType.book, '1990', ['Steampunk'], ['Victorian Steampunk']),
    MediaItem('Leviathan', MediaType.book, '2009', ['Steampunk'], ['Dieselpunk']),
    MediaItem('Bioshock Infinite', MediaType.game, '2013', ['Steampunk'], ['Victorian Steampunk']),
    MediaItem('Dishonored', MediaType.game, '2012', ['Steampunk'], ['Victorian Steampunk']),
    MediaItem('Arcanum', MediaType.game, '2001', ['Steampunk'], ['Victorian Steampunk']),
    MediaItem('The Nevers', MediaType.show, '2021', ['Steampunk'], ['Victorian Steampunk']),
    MediaItem('Carnival Row', MediaType.show, '2019', ['Steampunk', 'Fantasy'], ['Victorian Steampunk']),

    // ── Superhero ────────────────────────────────────────────────
    MediaItem('The Dark Knight', MediaType.film, '2008', ['Superhero'], ['Anti-Hero']),
    MediaItem('Spider-Man: Into the Spider-Verse', MediaType.film, '2018', ['Superhero'], ['Origin Story']),
    MediaItem('Logan', MediaType.film, '2017', ['Superhero'], ['Anti-Hero']),
    MediaItem('The Avengers', MediaType.film, '2012', ['Superhero'], ['Team Saga']),
    MediaItem('Joker', MediaType.film, '2019', ['Superhero'], ['Villain Perspective']),
    MediaItem('Watchmen', MediaType.book, '1986', ['Superhero'], ['Anti-Hero']),
    MediaItem('The Boys', MediaType.book, '2006', ['Superhero'], ['Anti-Hero', 'Villain Perspective']),
    MediaItem('Batman: Arkham City', MediaType.game, '2011', ['Superhero'], ['Anti-Hero']),
    MediaItem('Marvel\'s Spider-Man', MediaType.game, '2018', ['Superhero'], ['Origin Story']),
    MediaItem('Infamous', MediaType.game, '2009', ['Superhero'], ['Origin Story']),
    MediaItem('The Boys', MediaType.show, '2019', ['Superhero'], ['Anti-Hero', 'Villain Perspective']),
    MediaItem('Invincible', MediaType.show, '2021', ['Superhero'], ['Origin Story']),
    MediaItem('Daredevil', MediaType.show, '2015', ['Superhero'], ['Anti-Hero']),

    // ── Survival ─────────────────────────────────────────────────
    MediaItem('The Revenant', MediaType.film, '2015', ['Survival'], ['Wilderness']),
    MediaItem('Cast Away', MediaType.film, '2000', ['Survival'], ['Castaway']),
    MediaItem('127 Hours', MediaType.film, '2010', ['Survival'], ['Wilderness']),
    MediaItem('World War Z', MediaType.film, '2013', ['Survival'], ['Zombie Apocalypse']),
    MediaItem('The Impossible', MediaType.film, '2012', ['Survival'], ['Disaster']),
    MediaItem('The Road', MediaType.book, '2006', ['Survival'], ['Disaster']),
    MediaItem('Hatchet', MediaType.book, '1987', ['Survival'], ['Wilderness']),
    MediaItem('World War Z', MediaType.book, '2006', ['Survival'], ['Zombie Apocalypse']),
    MediaItem('The Long Dark', MediaType.game, '2017', ['Survival'], ['Wilderness']),
    MediaItem('Subnautica', MediaType.game, '2018', ['Survival'], ['Castaway']),
    MediaItem('The Last of Us', MediaType.game, '2013', ['Survival'], ['Zombie Apocalypse']),
    MediaItem('Don\'t Starve', MediaType.game, '2013', ['Survival'], ['Wilderness']),
    MediaItem('The Last of Us', MediaType.show, '2023', ['Survival'], ['Zombie Apocalypse']),
    MediaItem('Yellowjackets', MediaType.show, '2021', ['Survival'], ['Wilderness']),
    MediaItem('The 100', MediaType.show, '2014', ['Survival'], ['Disaster']),

    // ── Noir ─────────────────────────────────────────────────────
    MediaItem('Double Indemnity', MediaType.film, '1944', ['Noir'], ['Classic Noir']),
    MediaItem('Mulholland Drive', MediaType.film, '2001', ['Noir'], ['Neo-Noir']),
    MediaItem('Drive', MediaType.film, '2011', ['Noir'], ['Neo-Noir']),
    MediaItem('Nightcrawler', MediaType.film, '2014', ['Noir'], ['Neo-Noir']),
    MediaItem('The Maltese Falcon', MediaType.film, '1941', ['Noir'], ['Classic Noir']),
    MediaItem('The Big Sleep', MediaType.book, '1939', ['Noir', 'Mystery'], ['Classic Noir']),
    MediaItem('The Postman Always Rings Twice', MediaType.book, '1934', ['Noir'], ['Classic Noir']),
    MediaItem('Altered Carbon', MediaType.book, '2002', ['Noir', 'Sci-Fi'], ['Tech Noir']),
    MediaItem('Disco Elysium', MediaType.game, '2019', ['Noir', 'Mystery'], ['Neo-Noir']),
    MediaItem('Max Payne', MediaType.game, '2001', ['Noir'], ['Neo-Noir']),
    MediaItem('Observer', MediaType.game, '2017', ['Noir', 'Sci-Fi'], ['Tech Noir']),
    MediaItem('Altered Carbon', MediaType.show, '2018', ['Noir', 'Sci-Fi'], ['Tech Noir']),
    MediaItem('Ozark', MediaType.show, '2017', ['Noir'], ['Neo-Noir']),
  ];
}
