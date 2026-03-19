/// Metadata for a save slot displayed in the load game dialog.
class SaveSlotMeta {
  final int slot;
  final String genre;
  final String mode;
  final DateTime savedAt;
  final int sceneCount;
  final String summaryPreview;

  const SaveSlotMeta({
    required this.slot,
    required this.genre,
    required this.mode,
    required this.savedAt,
    required this.sceneCount,
    required this.summaryPreview,
  });

  Map<String, dynamic> toJson() => {
        'slot': slot,
        'genre': genre,
        'mode': mode,
        'savedAt': savedAt.toIso8601String(),
        'sceneCount': sceneCount,
        'summaryPreview': summaryPreview,
      };

  factory SaveSlotMeta.fromJson(Map<String, dynamic> json) => SaveSlotMeta(
        slot: json['slot'] as int,
        genre: json['genre'] as String? ?? 'Fantasy',
        mode: json['mode'] as String? ?? 'pure_story',
        savedAt: DateTime.parse(json['savedAt'] as String),
        sceneCount: json['sceneCount'] as int? ?? 0,
        summaryPreview: json['summaryPreview'] as String? ?? '',
      );
}
