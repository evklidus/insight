import 'package:flutter/material.dart';

import 'package:glass/glass.dart';
import 'package:insight/src/common/utils/extensions/go_relative_named.dart';
import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight/src/features/categories/model/category.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(this.category, {Key? key}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goRelativeNamed(
        'courses',
        pathParameters: {
          'tag': category.tag,
        },
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          CustomImageWidget(
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
