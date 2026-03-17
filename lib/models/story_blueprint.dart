/// A single narrative node within a story blueprint.
///
/// Story blueprints are produced by StoryArchitect and represent the
/// high-level structure of a planned story arc. Each node describes a
/// discrete scene with enough guidance for SceneWriter to expand it into
/// full prose.
class StoryBlueprintNode {
  /// One or two sentence description of what happens in this scene.
  final String summary;

  /// The primary dramatic tension driving this scene (e.g. "betrayal imminent").
  final String tension;

  /// The emotional register of the scene (e.g. "foreboding", "triumphant").
  final String mood;

  /// Where this node sits in the story arc (e.g. "Act 2 - rising action").
  final String plotArc;

  /// Whether this node represents a twist reveal.
  final bool isTwist;

  const StoryBlueprintNode({
    required this.summary,
    this.tension = '',
    this.mood = '',
    this.plotArc = '',
    this.isTwist = false,
  });

  factory StoryBlueprintNode.fromJson(Map<String, dynamic> json) {
    return StoryBlueprintNode(
      summary: json['summary'] as String? ?? '',
      tension: json['tension'] as String? ?? '',
      mood: json['mood'] as String? ?? '',
      plotArc: json['plotArc'] as String? ?? '',
      isTwist: json['isTwist'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'summary': summary,
        'tension': tension,
        'mood': mood,
        'plotArc': plotArc,
        'isTwist': isTwist,
      };
}

/// The full story blueprint: an ordered list of [StoryBlueprintNode] objects
/// that map the intended narrative arc.
class StoryBlueprint {
  final String title;
  final List<StoryBlueprintNode> nodes;

  const StoryBlueprint({
    required this.title,
    required this.nodes,
  });

  factory StoryBlueprint.fromJson(Map<String, dynamic> json) {
    final rawNodes = json['nodes'] as List<dynamic>? ?? [];
    return StoryBlueprint(
      title: json['title'] as String? ?? '',
      nodes: rawNodes
          .map((n) =>
              StoryBlueprintNode.fromJson(n as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'nodes': nodes.map((n) => n.toJson()).toList(),
      };
}
