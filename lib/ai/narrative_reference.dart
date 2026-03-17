/// Craft guidance distilled from narrative research.
///
/// Provides genre-specific prose techniques, choice architecture principles,
/// and universal storytelling standards. Agents embed these into prompts to
/// ground AI output in established narrative craft rather than generic output.
class NarrativeReference {
  // ---------------------------------------------------------------------------
  // Genre-specific craft guidance
  // ---------------------------------------------------------------------------

  static const Map<String, String> _craftGuidance = {
    'Fantasy': '''
FANTASY CRAFT GUIDANCE
- Ground magic in cost and consequence — every spell or miracle should demand something from the caster (energy, blood, years of life, sanity).
- Use concrete sensory details to make the fantastical feel real: the smell of ozone before a lightning spell, the cold weight of an enchanted sword.
- Subvert expected tropes with honest character motivation — the dragon may be protecting something precious, the prophecy may be a trap.
- Let worldbuilding emerge through action, not exposition: show the trade routes through the merchant's fear of goblin raids, not a history lesson.
- The hero's arc must be internal: the external quest is only the pressure that forces internal transformation.
''',
    'Horror': '''
HORROR CRAFT GUIDANCE
- Terror lives in implication, not description — what the character almost sees is more frightening than what they do see.
- Establish normalcy with precision so its violation is felt viscerally: name the street, describe the routine, let the reader inhabit the safety before destroying it.
- Use pacing as a weapon: short, fragmented sentences during panic; long, slow sentences during dread.
- The most effective horror is personal — it attacks what the character loves most, what they cannot afford to lose.
- Avoid explaining the monster. Mystery multiplies dread; comprehension dissolves it.
- Sound and silence are your best tools. Use them deliberately.
''',
    'Mystery': '''
MYSTERY CRAFT GUIDANCE
- Every scene must serve the puzzle: either plant a clue, introduce a suspect, or create misdirection — never filler.
- Fair play: all information needed to solve the mystery must be available to the reader/player, though not obviously highlighted.
- Contradiction is the engine of mystery — two true facts that cannot both be true until the solution reveals how they can.
- Red herrings must be genuinely misleading, not cheap — they should arise from character motivation, not authorial trickery.
- The detective's voice is the reader's guide: when they are confused, the prose should be terse; when they perceive a pattern, the prose should open up.
- Revelations should recontextualise, not merely inform — the best mystery twist makes the reader re-read every prior scene in a new light.
''',
    'Sci-Fi': '''
SCI-FI CRAFT GUIDANCE
- The speculative element must be load-bearing: if you removed the technology/future/alternate reality, the story would not work. That is how you know it is real science fiction.
- Introduce the world through character interaction with it, never through exposition dumps. The character's emotional response to their environment is the reader's entry point.
- Extrapolate consequences rigorously: if FTL travel exists, what happened to family structures, economies, warfare? Let those ripples show.
- The best science fiction asks a question about being human and answers it by removing the guardrails of the familiar.
- Ground philosophical stakes in personal stakes — the audience cares about ideas only when they see them in flesh and blood.
- Avoid fetishising technology: it is always a means, never an end. The story is always about people.
''',
  };

  // ---------------------------------------------------------------------------
  // Genre-specific choice architecture
  // ---------------------------------------------------------------------------

  static const Map<String, String> _choiceArchitecture = {
    'Fantasy': '''
FANTASY CHOICE ARCHITECTURE
- The Heroic Dilemma: courage vs. self-preservation, loyalty vs. greater good.
- The Moral Fork: the right thing and the easy thing are never the same path.
- The Sacrifice Choice: what are you willing to give up? Power, relationship, safety?
- The Alliance Choice: who do you trust when everyone has a hidden agenda?
- Each choice should visibly advance at least one relationship, one threat, and one mystery simultaneously.
''',
    'Horror': '''
HORROR CHOICE ARCHITECTURE
- The Coward's Bargain: flee safely, or stay and risk everything to save another.
- The Knowledge Trap: look and be changed forever, or stay ignorant and be vulnerable.
- The Trust Problem: every ally might be compromised; every choice to trust is a gamble.
- The Sacrifice Calculus: who do you let die so others might live?
- Choices should narrow options over time — the horror is the closing-in of possibility.
''',
    'Mystery': '''
MYSTERY CHOICE ARCHITECTURE
- The Investigation Fork: which lead to follow when you can only follow one tonight.
- The Disclosure Dilemma: reveal what you know to gain trust, or stay hidden to stay safe.
- The Confrontation Gamble: confront the suspect now with incomplete evidence, or wait and risk evidence disappearing.
- The Alliance Question: accept help from a morally compromised source, or go it alone at greater personal risk.
- Choices should always have informational consequences — every path reveals something and conceals something else.
''',
    'Sci-Fi': '''
SCI-FI CHOICE ARCHITECTURE
- The Utilitarian Trap: sacrifice the few for the many — but who decides the arithmetic?
- The Progress Bargain: advance the technology/mission at a human cost, or protect the individual at the cost of the mission.
- The Identity Question: what makes you still you after augmentation, replacement, or reprogramming?
- The Loyalty Fracture: follow orders from a corrupt institution, or break ranks and risk everything.
- Every choice should have systemic consequences — in science fiction, individual decisions ripple into society.
''',
  };

  // ---------------------------------------------------------------------------
  // Universal principles applied in all genres
  // ---------------------------------------------------------------------------

  static const String _universalPrinciples = '''
UNIVERSAL NARRATIVE PRINCIPLES
1. SHOW, DON'T TELL — render emotion through behaviour and physiology, not label: "his hands wouldn't stop shaking" not "he was afraid."
2. SCENE ECONOMY — every sentence must earn its place. Cut anything that does not advance character, plot, or atmosphere.
3. SPECIFICITY — concrete details create belief; vague details create distance. Name the weapon, the street, the smell.
4. SUBTEXT — what characters don't say is as important as what they do. Let motivation live beneath the dialogue.
5. CONSEQUENCE — every choice must visibly change something. The reader must feel that decisions matter.
6. MOMENTUM — end every scene with a question, a threat, or a revelation that makes the reader need to know what happens next.
7. VOICE CONSISTENCY — maintain a coherent narrative voice. Tone shifts should be intentional and motivated, never accidental.
8. EARNED EMOTION — do not tell the reader how to feel. Build to the emotion through specific, concrete, patient craft; then let the image do the work.
''';

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Returns genre-specific prose craft guidance for embedding in prompts.
  /// Falls back to Fantasy guidance if [genre] is not recognised.
  static String getCraftGuidance(String genre) {
    return _craftGuidance[genre] ?? _craftGuidance['Fantasy']!;
  }

  /// Returns genre-specific choice architecture principles for embedding in
  /// ChoiceGenerator prompts. Falls back to Fantasy if [genre] is not recognised.
  static String getChoiceArchitecture(String genre) {
    return _choiceArchitecture[genre] ?? _choiceArchitecture['Fantasy']!;
  }

  /// Returns the universal narrative principles applied in all genres.
  static String getUniversalPrinciples() {
    return _universalPrinciples;
  }

  /// Returns the full genre context block: craft guidance + choice architecture
  /// + universal principles. Used by agents that need the complete reference.
  static String getFullGenreContext(String genre) {
    return '${getCraftGuidance(genre)}\n\n'
        '${getChoiceArchitecture(genre)}\n\n'
        '${getUniversalPrinciples()}';
  }
}
