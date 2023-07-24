import 'package:flutter/material.dart';

import 'package:insight/src/features/categories/model/category.dart';
import 'package:insight/src/features/categories/widget/components/category_widget.dart';

class CategoriesScreenLoaded extends StatelessWidget {
  const CategoriesScreenLoaded({
    Key? key,
    required this.categories,
  }) : super(key: key);

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 25,
          crossAxisSpacing: 25,
          childAspectRatio: 168 / 206,
        ),
        children: categories
            .map(
              (category) => CategoryWidget(category),
            )
            .toList(),
      ),
    );
  }
}
