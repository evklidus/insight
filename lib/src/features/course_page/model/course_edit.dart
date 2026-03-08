class Course$Edit {
  Course$Edit({
    required this.id,
    this.imagePath,
    required this.name,
    this.description,
    this.tag,
    this.isClosed,
  });

  final String id;
  final String? imagePath;
  final String name;
  final String? description;
  final String? tag;
  final bool? isClosed;
}
