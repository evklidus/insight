import 'package:flutter/material.dart';
import 'package:insight/components/boxes/h_box.dart';
import 'package:insight/components/boxes/w_padding_box.dart';
import 'package:insight/core/constants/color_constants.dart';
import 'package:insight/core/stores/entity_store.dart';
import 'package:insight/utilities/load_states.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:insight/gen/assets.gen.dart';

class InformationWidget<T extends EntityStore> extends StatelessWidget {
  const InformationWidget(this.loadState, {Key? key}) : super(key: key);

  final LoadStates loadState;

  @override
  Widget build(BuildContext context) {
    final store = context.read<T>();
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorConstants.grayWithOpacity,
        borderRadius: BorderRadius.circular(25),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Assets.images.emptyImage.image(),
            ),
          ),
          Text(
            getTitle(loadState),
            style: TextStyle(
              fontSize: 21.sp,
              color: Colors.white,
            ),
          ),
          HBox(3.h),
          WPaddingBox(
            child: Text(
              getText(loadState),
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          HBox(2.h),
          if (store.reloadFunc != null)
            TextButton(
              child: const Text('Попробовать снова'),
              onPressed: () {
                store.reloadFunc!();
              },
            ),
        ],
      ),
    );
  }
}

String getImage(LoadStates loadState) {
  switch (loadState) {
    case LoadStates.empty:
      return Assets.images.emptyImage.path;
    case LoadStates.failed:
      return Assets.images.errorImage.path;
    default:
      return Assets.images.errorImage.path;
  }
}

String getTitle(LoadStates loadState) {
  switch (loadState) {
    case LoadStates.empty:
      return 'Упс...';
    case LoadStates.failed:
      return 'Ошибка';
    default:
      return 'Ошибка';
  }
}

String getText(LoadStates loadState) {
  switch (loadState) {
    case LoadStates.empty:
      return 'Видимо объект забыли добавить, попробуйте позже';
    case LoadStates.failed:
      return 'Что-то пошло не так, попробуйте позже';
    default:
      return 'Что-то пошло не так, попробуйте позже';
  }
}
