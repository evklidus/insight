import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';
import 'package:insight/features/categories/presentation/widgets/category_widget.dart';

class CategoriesScreenLoaded extends StatelessWidget {
  const CategoriesScreenLoaded({
    Key? key,
    required this.categories,
  }) : super(key: key);

  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16.h,
        horizontal: 16.w,
      ),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 25.h,
          crossAxisSpacing: 25.w,
          childAspectRatio: 168.w / 206.h,
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
