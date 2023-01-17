import 'package:flutter/material.dart';
import 'package:insight/features/categories/presentation/stores/categories_store.dart';
import 'package:insight/features/categories/presentation/widgets/category_widget.dart';
import 'package:provider/provider.dart';

class CategoriesScreenLoaded extends StatelessWidget {
  const CategoriesScreenLoaded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<CategoriesStore>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2 / 1,
        ),
        children: store.entity!
            .map(
              (category) => CategoryWidget(category),
            )
            .toList(),
      ),
    );
  }
}
