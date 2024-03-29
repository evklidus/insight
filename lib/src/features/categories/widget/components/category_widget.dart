import 'dart:ui';

import 'package:flutter/material.dart';

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
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.hardEdge,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Text(category.name),
            ),
          ),
        ],
      ),
    );
  }
}
