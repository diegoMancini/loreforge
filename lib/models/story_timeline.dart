/// A node in the visual story timeline (Nonary Games / Zero Escape inspired).
class TimelineNode {
  /// Zero-based scene index.
  final int sceneIndex;

  /// One-line summary from the AI context manager.
  final String summary;

  /// The choice the player made to reach this node (empty for scene 0).
  final String choiceMade;

  /// Blueprint node type: 'act', 'beat', 'twist', 'climax', 'resolution'.
  final String nodeType;

  /// Whether a plot twist was triggered at this node.
  final bool isTwist;

  /// Whether this is the current (latest) scene.
  final bool isCurrentScene;

  /// All choices that were offered at this scene (for showing branches not taken).
  final List<String> choicesOffered;

  const TimelineNode({
    required this.sceneIndex,
    required this.summary,
    required this.choiceMade,
    required this.nodeType,
    required this.isTwist,
    required this.isCurrentScene,
    required this.choicesOffered,
  });
}
