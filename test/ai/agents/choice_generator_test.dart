import 'package:flutter_test/flutter_test.dart';
import 'package:loreforge/ai/agents/choice_generator.dart';

import '../../fixtures/test_fixtures.dart';

void main() {
  late FakeAIProvider fake;
  late ChoiceGenerator generator;

  setUp(() {
    fake = FakeAIProvider();
    generator = ChoiceGenerator(fake);
  });

  final state = TestFixtures.storyState();
  const narrative = 'The dragon landed before you, smoke curling from its nostrils.';

  group('ChoiceGenerator.generateChoices', () {
    test('parses "1. X" numbered format into 3 choices', () async {
      fake.nextResponse =
          '1. Draw your sword and charge\n2. Attempt to communicate with the beast\n3. Slowly back away into the shadows';
      final choices = await generator.generateChoices(state, narrative);
      expect(choices, hasLength(3));
      expect(choices[0], 'Draw your sword and charge');
      expect(choices[1], 'Attempt to communicate with the beast');
      expect(choices[2], 'Slowly back away into the shadows');
    });

    test('parses "1) X" parenthesis format — prefix retained since regex only strips "N."',
        () async {
      fake.nextResponse =
          '1) Fight the mighty dragon\n2) Talk to the ancient dragon\n3) Run from the fearsome dragon';
      final choices = await generator.generateChoices(state, narrative);
      expect(choices, hasLength(3));
      // The regex strips "N." but not "N)" — "1)" remains in the cleaned text
      expect(choices[0], '1) Fight the mighty dragon');
      expect(choices[1], '2) Talk to the ancient dragon');
      expect(choices[2], '3) Run from the fearsome dragon');
    });

    test('parses "- X" bulleted format into 3 choices', () async {
      fake.nextResponse =
          '- Confront the beast head on\n- Offer a gift of peace\n- Sneak around the dragon';
      final choices = await generator.generateChoices(state, narrative);
      expect(choices, hasLength(3));
      expect(choices[0], 'Confront the beast head on');
      expect(choices[1], 'Offer a gift of peace');
      expect(choices[2], 'Sneak around the dragon');
    });

    test('handles mix of numbered and bulleted formats', () async {
      fake.nextResponse =
          '1. Charge forward bravely\n- Retreat to safety and regroup\n2. Negotiate a truce carefully';
      final choices = await generator.generateChoices(state, narrative);
      expect(choices, hasLength(3));
      expect(choices[0], 'Charge forward bravely');
      expect(choices[1], 'Retreat to safety and regroup');
      expect(choices[2], 'Negotiate a truce carefully');
    });

    test('falls back to lines >5 chars when no markers found', () async {
      fake.nextResponse =
          'Charge forward into battle\nRetreat and plan carefully\nSeek an alternate path';
      final choices = await generator.generateChoices(state, narrative);
      expect(choices, hasLength(3));
      expect(choices[0], 'Charge forward into battle');
    });

    test('returns fallback defaults for empty response', () async {
      fake.nextResponse = '';
      final choices = await generator.generateChoices(state, narrative);
      expect(choices, hasLength(2));
      expect(choices[0], 'Press forward and confront what lies ahead.');
      expect(choices[1], 'Retreat and reconsider your approach.');
    });

    test('returns defaults when all lines are too short', () async {
      fake.nextResponse = 'Hi\nOk\nYes\nNo';
      final choices = await generator.generateChoices(state, narrative);
      expect(choices, hasLength(2));
      expect(choices[0], 'Press forward and confront what lies ahead.');
    });

    test('strips whitespace from each choice', () async {
      fake.nextResponse =
          '1.   Draw your sword   \n2.   Talk to the dragon   \n3.   Run away quickly   ';
      final choices = await generator.generateChoices(state, narrative);
      expect(choices[0], 'Draw your sword');
      expect(choices[1], 'Talk to the dragon');
      expect(choices[2], 'Run away quickly');
    });
  });
}
