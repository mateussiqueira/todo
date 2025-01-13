class ItemEntity {
  final String id;
  final String listId;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItemEntity({
    required this.id,
    required this.listId,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });
}
