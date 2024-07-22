class Course {
  const Course({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tag,
    required this.creatorId,
  });

  factory Course.fromJson(Map json) => Course(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image_url'],
        tag: json['tag'],
        creatorId: json['creatorId'],
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
      );

  final String id;
  final String name;
  final String imageUrl;
  final String tag;
  final String creatorId;
}
