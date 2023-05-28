import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glass/glass.dart';
import 'package:insight/common/widgets/insight_image_widget.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';
import 'package:insight/common/navigation/app_router.dart';

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
            borderRadius: 20.r,
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Text(category.name),
            ).asGlass(
              clipBorderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ],
      ),
    );
  }
}
