/// Static genre configuration used across all AI agents.
///
/// Each genre entry contains tone descriptors, narrative elements,
/// craft focus guidance, pacing structure, and choice philosophy.
class GenreRules {
  static const Map<String, Map<String, dynamic>> rules = {
    'Fantasy': {
      'tone': 'epic, magical, wondrous',
      'elements': ['magic systems', 'mythical creatures', 'heroic quests'],
      'twist_types': [
        'scope escalation',
        'prophecy reinterpretation',
        'hidden identity'
      ],
      'craft_focus': 'worldbuilding, character growth, moral choices',
      'pacingStructure':
          'Open with wonder (Act 1: discovery), escalate the stakes through a mentor challenge or betrayal (Act 2), and resolve with a sacrifice or transformation that proves the hero has changed (Act 3). Scenes should alternate between action and quiet character beats.',
      'agencyCalibration':
          "Player shapes the hero's moral compass and alliances",
      'choicePhilosophy':
          'Choices should feel heroic but costly — every victory should demand something. Offer paths of courage, cunning, and compassion, and let the player feel the weight of each.',
    },
    'Horror': {
      'tone': 'tense, suspenseful, terrifying',
      'elements': [
        'psychological tension',
        'unknown threats',
        'survival horror'
      ],
      'twist_types': [
        'false safety',
        'real monster reveal',
        'protagonist threat'
      ],
      'craft_focus': 'atmosphere, pacing, emotional impact',
      'pacingStructure':
          'Build dread slowly (Act 1: something is wrong), isolate characters and deny safety (Act 2: escalating horror), then deliver the full revelation — the monster, the truth, the cost (Act 3). Use quiet moments to make loud ones hit harder.',
      'agencyCalibration': 'Player chooses between self-preservation and helping others',
      'choicePhilosophy':
          'Every choice should feel like a lose-lose dilemma — safety vs. knowledge, survival vs. saving others. The horror is not the monster, it is the impossible choices it forces.',
    },
    'Mystery': {
      'tone': 'intriguing, intellectual, suspenseful',
      'elements': ['clues', 'red herrings', 'detective work'],
      'twist_types': [
        'double cross',
        'cascading revelations',
        'unreliable witness'
      ],
      'craft_focus': 'puzzle design, misdirection, fair play',
      'pacingStructure':
          'Present the crime/puzzle with clear hooks (Act 1), layer in contradictory clues and introduce suspects (Act 2: complication), then allow a deductive breakthrough that recontextualises all prior evidence (Act 3: revelation). Every scene should add or shift a piece of the puzzle.',
      'agencyCalibration': 'Player decides which leads to follow and whom to trust',
      'choicePhilosophy':
          'Choices should be investigative — which lead to pursue, who to trust, when to reveal your hand. Reward careful reasoning; punish recklessness with misdirection, not unfairness.',
    },
    'Sci-Fi': {
      'tone': 'speculative, futuristic, philosophical',
      'elements': ['technology', 'space', 'alternate realities'],
      'twist_types': [
        'paradigm shift',
        'time loop',
        'technology betrayal'
      ],
      'craft_focus': 'worldbuilding, scientific accuracy, thematic depth',
      'pacingStructure':
          'Establish the speculative premise through sensory detail, not exposition (Act 1), then stress-test the premise through escalating human consequences (Act 2), and resolve with a choice that forces the protagonist to redefine what it means to be human (Act 3).',
      'agencyCalibration': 'Player navigates ethical dilemmas of technology and progress',
      'choicePhilosophy':
          'Choices should pit pragmatism against principle — utilitarian calculus versus individual dignity. Let the player feel the philosophical stakes, not just the tactical ones.',
    },
    'Romance': {
      'tone': 'passionate, emotional, intimate',
      'elements': [
        'relationship dynamics',
        'emotional vulnerability',
        'personal growth'
      ],
      'twist_types': ['misunderstanding reveal', 'secret past', 'rival appearance'],
      'craft_focus': 'character chemistry, emotional depth, meaningful dialogue',
      'pacingStructure':
          'Meet → attraction → obstacles → crisis of faith → reunion or resolution',
      'agencyCalibration':
          'Player shapes relationship dynamics and emotional vulnerability',
      'choicePhilosophy':
          'Choices between heart vs head, vulnerability vs protection, past vs future',
    },
    'Thriller': {
      'tone': 'urgent, high-stakes, pulse-pounding',
      'elements': ['time pressure', 'conspiracies', 'pursuit'],
      'twist_types': [
        'betrayal reveal',
        'hidden agenda',
        'ticking clock escalation'
      ],
      'craft_focus': 'tension maintenance, plot twists, high stakes',
      'pacingStructure':
          'Inciting threat → escalating danger → betrayal → race against time → climax',
      'agencyCalibration': 'Player makes split-second decisions under pressure',
      'choicePhilosophy':
          'Choices between speed vs caution, lone wolf vs teamwork, ends vs means',
    },
    'War': {
      'tone': 'grim, heroic, morally complex',
      'elements': ['combat', 'brotherhood', 'sacrifice', 'chain of command'],
      'twist_types': [
        'friendly fire',
        'intelligence failure',
        'moral compromise'
      ],
      'craft_focus': 'realism, moral weight, camaraderie, cost of conflict',
      'pacingStructure':
          'Deployment → first contact → escalation → decisive battle → aftermath',
      'agencyCalibration':
          'Player balances mission objectives with the lives of companions',
      'choicePhilosophy':
          'Choices between orders vs conscience, squad vs mission, survival vs honor',
    },
    'Historical': {
      'tone': 'immersive, authentic, dramatic',
      'elements': [
        'period accuracy',
        'real events',
        'cultural context',
        'social dynamics'
      ],
      'twist_types': [
        'historical irony',
        'hidden document reveal',
        'identity switch'
      ],
      'craft_focus': 'period authenticity, cultural detail, historical consequence',
      'pacingStructure':
          'Setting establishment → personal stakes → historical turning point → resolution',
      'agencyCalibration':
          'Player navigates social hierarchies and historical constraints',
      'choicePhilosophy':
          'Choices between tradition vs change, loyalty vs principle, personal desire vs historical duty',
    },
    'Western': {
      'tone': 'rugged, morally ambiguous, frontier justice',
      'elements': ['frontier life', 'gunfights', 'honor codes', 'lawlessness'],
      'twist_types': ['betrayal by partner', 'law catches up', 'hidden past revealed'],
      'craft_focus': 'landscape as character, moral code, solitude and violence',
      'pacingStructure': 'Arrival in town → tension with locals → showdown → ride into the sunset or grave',
      'agencyCalibration': 'Player defines their own code of justice on the frontier',
      'choicePhilosophy': 'Choices between law vs justice, revenge vs mercy, freedom vs community',
    },
    'Mythology': {
      'tone': 'divine, fateful, larger-than-life',
      'elements': ['gods and mortals', 'fate and prophecy', 'divine intervention', 'heroic trials'],
      'twist_types': ['divine betrayal', 'prophecy misread', 'mortal becomes divine'],
      'craft_focus': 'mythic scale, moral lessons, the cost of hubris',
      'pacingStructure': 'Divine call → heroic journey → trials of character → confrontation with fate → transformation',
      'agencyCalibration': 'Player challenges or accepts the will of the gods',
      'choicePhilosophy': 'Choices between fate vs free will, humility vs ambition, sacrifice vs self-preservation',
    },
    'Steampunk': {
      'tone': 'inventive, adventurous, class-conscious',
      'elements': ['steam technology', 'clockwork', 'airships', 'class struggle', 'invention'],
      'twist_types': ['invention backfires', 'aristocratic conspiracy', 'automaton uprising'],
      'craft_focus': 'mechanical worldbuilding, class dynamics, the cost of progress',
      'pacingStructure': 'Discovery of invention → social consequences → escalation → machine vs humanity → resolution',
      'agencyCalibration': 'Player navigates between innovation and its social cost',
      'choicePhilosophy': 'Choices between progress vs tradition, individual genius vs collective good, order vs freedom',
    },
    'Superhero': {
      'tone': 'heroic, identity-driven, power and responsibility',
      'elements': ['superpowers', 'secret identities', 'moral dilemmas', 'nemeses'],
      'twist_types': ['hero becomes villain', 'power source corrupts', 'ally betrayal'],
      'craft_focus': 'identity duality, power as metaphor, the weight of responsibility',
      'pacingStructure': 'Origin/call → first challenge → escalating threats → moral crisis → defining moment',
      'agencyCalibration': 'Player defines what kind of hero (or anti-hero) they become',
      'choicePhilosophy': 'Choices between power vs restraint, secrecy vs transparency, saving many vs saving one',
    },
    'Survival': {
      'tone': 'desperate, resourceful, primal',
      'elements': ['scarce resources', 'hostile environment', 'human endurance', 'moral erosion'],
      'twist_types': ['rescue that is a trap', 'ally becomes threat', 'environment escalation'],
      'craft_focus': 'physical detail, resource tension, psychological deterioration under pressure',
      'pacingStructure': 'Initial crisis → stabilization attempt → escalating threats → lowest point → escape or adaptation',
      'agencyCalibration': 'Player manages resources and decides who to trust',
      'choicePhilosophy': 'Choices between self-preservation vs helping others, short-term survival vs long-term planning, humanity vs pragmatism',
    },
    'Noir': {
      'tone': 'cynical, atmospheric, morally grey',
      'elements': ['corruption', 'femmes fatales', 'moral compromise', 'rain-soaked streets'],
      'twist_types': ['double cross', 'client is the criminal', 'detective becomes suspect'],
      'craft_focus': 'atmosphere and voice, moral ambiguity, the impossibility of justice',
      'pacingStructure': 'Case arrives → investigation deepens → everything is connected → betrayal → pyrrhic resolution',
      'agencyCalibration': 'Player navigates a world where everyone lies and justice is a luxury',
      'choicePhilosophy': 'Choices between truth vs survival, justice vs self-interest, trust vs cynicism',
    },
  };

  static Map<String, dynamic> getRules(String genre) {
    return rules[genre] ?? rules['Fantasy']!;
  }
}
