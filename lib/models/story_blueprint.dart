/// Represents a high-level structural plan for a story generated before gameplay begins.
/// The architect produces a list of [BlueprintNode] entries (acts, beats, twists) that
/// downstream agents can reference when writing scenes and directing pacing.
class StoryBlueprint {
  final String premise;
  final String tone;
  final String language;
  final List<BlueprintNode> nodes;
  final Map<String, dynamic> metadata;

  const StoryBlueprint({
    required this.premise,
    required this.tone,
    required this.language,
    required this.nodes,
    this.metadata = const {},
  });

  factory StoryBlueprint.empty() => const StoryBlueprint(
        premise: '',
        tone: 'epic',
        language: 'en',
        nodes: [],
      );

  factory StoryBlueprint.fromJson(Map<String, dynamic> json) => StoryBlueprint(
        premise: json['premise'] as String? ?? '',
        tone: json['tone'] as String? ?? 'epic',
        language: json['language'] as String? ?? 'en',
        nodes: (json['nodes'] as List<dynamic>?)
                ?.map((n) => BlueprintNode.fromJson(n as Map<String, dynamic>))
                .toList() ??
            [],
        metadata:
            (json['metadata'] as Map<String, dynamic>?) ?? {},
      );

  Map<String, dynamic> toJson() => {
        'premise': premise,
        'tone': tone,
        'language': language,
        'nodes': nodes.map((n) => n.toJson()).toList(),
        'metadata': metadata,
      };
}

/// A single structural unit within a [StoryBlueprint].
///
/// [type] is one of: 'act', 'beat', 'twist', 'climax', 'resolution'.
/// [summary] is a one-sentence description of what should happen.
/// [order] is the zero-based position within the blueprint sequence.
class BlueprintNode {
  final String type;
  final String summary;
  final int order;
  final Map<String, dynamic> hints;

  const BlueprintNode({
    required this.type,
    required this.summary,
    required this.order,
    this.hints = const {},
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'summary': summary,
        'order': order,
        'hints': hints,
      };

  factory BlueprintNode.fromJson(Map<String, dynamic> json) => BlueprintNode(
        type: json['type'] as String,
        summary: json['summary'] as String,
        order: json['order'] as int,
        hints: (json['hints'] as Map<String, dynamic>?) ?? {},
      );
}
