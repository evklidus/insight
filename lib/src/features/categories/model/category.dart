import 'package:meta/meta.dart';

@immutable
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tag,
  });

  factory Category.fromJson(Map json) => Category(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image_url'],
        tag: json['tag'],
      );

  factory Category.fromFirestore(
    String id,
    Map<String, dynamic>? categoryData,
  ) =>
      Category(
        id: id,
        name: categoryData!['name'],
        imageUrl: categoryData['image_url'],
        tag: categoryData['tag'],
      );

  final String id;
  final String name;
  final String imageUrl;
  final String tag;

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other);
}
