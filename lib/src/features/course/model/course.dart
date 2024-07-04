class Course {
  const Course({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tag,
    required this.isItsOwn,
  });

  factory Course.fromJson(Map json) => Course(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image_url'],
        tag: json['tag'],
        isItsOwn: json['is_its_own'],
      );

  factory Course.fromFirestore(
    String id,
    Map<String, dynamic>? data,
    String? userId,
  ) =>
      Course(
        id: id,
        name: data!['name'],
        imageUrl: data['image_url'],
        tag: data['tag'],
        isItsOwn: data['owner_id'] == userId,
      );

  final String id;
  final String name;
  final String imageUrl;
  final String tag;
  final bool isItsOwn;
}
