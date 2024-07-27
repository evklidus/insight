import 'package:flutter/material.dart';
import 'package:insight/src/common/widgets/shimmer.dart';

import 'package:insight/src/features/categories/model/category.dart';
import 'package:insight/src/features/categories/widget/components/category_widget.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.categories,
  });

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 16,
        left: 16,
        right: 16,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 25,
        crossAxisSpacing: 25,
        childAspectRatio: 168 / 206,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryWidget(category);
      },
    );
  }
}

class CategoriesListSkeleton extends StatelessWidget {
  const CategoriesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 16,
        left: 16,
        right: 16,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 25,
        crossAxisSpacing: 25,
        childAspectRatio: 168 / 206,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => const Shimmer(cornerRadius: 16),
    );
  }
}
