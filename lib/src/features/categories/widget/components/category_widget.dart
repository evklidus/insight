import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:glass/glass.dart';
import 'package:insight/src/common/widgets/insight_image_widget.dart';
import 'package:insight/src/features/categories/model/category.dart';
import 'package:insight/src/core/navigation/app_router.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(this.category, {Key? key}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushRoute(
        CoursePreviewsRoute(categoryTag: category.tag),
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          InsightImageWidget(
            category.imageUrl,
            height: double.infinity,
            borderRadius: BorderRadius.circular(20),
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
