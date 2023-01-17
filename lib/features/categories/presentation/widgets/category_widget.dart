import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';
import 'package:insight/services/navigation/app_router.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(this.category, {Key? key}) : super(key: key);

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(CoursePreviewsRoute(categoryTag: category.tag));
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(category.name),
      ),
    );
  }
}
