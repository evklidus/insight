import 'package:meta/meta.dart';

@immutable
class Category {
  const Category({
    required this.name,
    required this.imageUrl,
    required this.tag,
  });

  factory Category.fromJson(Map json) => Category(
        name: json['name'],
        imageUrl: json['image_url'],
        tag: json['tag'],
      );

  factory Category.fromFirestore(
    // TODO: Добавить id для категорий
    // ignore: avoid-unused-parameters
    String id,
    Map<String, dynamic>? categoryData,
  ) =>
      Category(
        name: categoryData!['name'],
        imageUrl: categoryData['image_url'],
        tag: categoryData['tag'],
      );

  final String name;
  final String imageUrl;
  final String tag;

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other);
}
