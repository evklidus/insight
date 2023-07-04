import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:glass/glass.dart';
import 'package:insight/common/widgets/insight_image_widget.dart';
import 'package:insight/features/categories/data/entities/category_entity.dart';
import 'package:insight/core/navigation/app_router.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(this.category, {Key? key}) : super(key: key);

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(CoursePreviewsRoute(categoryTag: category.tag));
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          InsightImageWidget(
            category.imageUrl,
            height: double.infinity,
            borderRadius: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(category.name),
            ).asGlass(
              clipBorderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}
