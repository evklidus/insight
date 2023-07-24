import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
final class Category {
  const Category({
    required this.name,
    required this.imageUrl,
    required this.tag,
  });

  factory Category.fromDTO(CategoryDTO dto) => Category(
        name: dto.name,
        imageUrl: dto.imageUrl,
        tag: dto.tag,
      );

  final String name;
  final String imageUrl;
  final String tag;
}
