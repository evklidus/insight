import 'package:flutter/material.dart';
import 'package:insight/src/common/widgets/shimmer.dart';
import 'package:insight/src/features/categories/model/category.dart';
import 'package:insight/src/features/categories/widget/components/category_widget.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({
    super.key,
    required this.categories,
  });

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 25,
        crossAxisSpacing: 25,
        childAspectRatio: 168 / 206,
      ),
      initialItemCount: categories.length,
      itemBuilder: (context, index, _) {
        final category = categories[index];
        return CategoryWidget(category);
      },
    );
  }
}

class CategoriesGridSkeleton extends StatelessWidget {
  const CategoriesGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 25,
        crossAxisSpacing: 25,
        childAspectRatio: 168 / 206,
      ),
      initialItemCount: 4,
      itemBuilder: (context, index, _) => const Shimmer(cornerRadius: 16),
    );
  }
}
