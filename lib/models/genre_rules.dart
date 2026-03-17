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
  };

  static Map<String, dynamic> getRules(String genre) {
    return rules[genre] ?? rules['Fantasy']!;
  }
}
