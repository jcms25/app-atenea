// Modelo del módulo Actitudinal — etiqueta (de GET /classroom-tags)

class ClassroomTag {
  final int id;
  final String emoji;
  final String label;
  final String description;
  final int sortOrder;

  ClassroomTag({
    required this.id,
    required this.emoji,
    required this.label,
    required this.description,
    required this.sortOrder,
  });

  factory ClassroomTag.fromJson(Map<String, dynamic> json) {
    return ClassroomTag(
      id: json['id'] ?? 0,
      emoji: json['emoji'] ?? '',
      label: json['label'] ?? '',
      description: json['description'] ?? '',
      sortOrder: json['sort_order'] ?? 0,
    );
  }
}