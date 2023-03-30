import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insight/features/categories/presentation/stores/categories_store.dart';
import 'package:insight/features/categories/presentation/widgets/category_widget.dart';
import 'package:provider/provider.dart';

class CategoriesScreenLoaded extends StatelessWidget {
  const CategoriesScreenLoaded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<CategoriesStore>();
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
        children: store.entity!
            .map(
              (category) => CategoryWidget(category),
            )
            .toList(),
      ),
    );
  }
}
