class Course {
  const Course({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tag,
    required this.creatorId,
    this.isClosed = false,
  });

  factory Course.fromJson(Map json) => Course(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image_url'],
        tag: json['tag'],
        creatorId: json['creatorId'] ?? json['owner_id'],
        isClosed: json['is_private'] as bool? ??
            json['is_closed'] as bool? ??
            false,
      );

  factory Course.fromFirestore(
    String id,
    Map<String, dynamic>? data,
  ) =>
      Course(
        id: id,
        name: data!['name'],
        imageUrl: data['image_url'],
        tag: data['tag'],
        creatorId: data['owner_id'],
        isClosed: data['is_closed'] as bool? ?? false,
      );

  final String id;
  final String name;
  final String imageUrl;
  final String tag;
  final String creatorId;
  final bool isClosed;
}
