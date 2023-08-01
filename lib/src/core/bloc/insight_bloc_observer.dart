import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/utils/format_error.dart';

class InsightBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    debugPrint(
      formatError(
        '🅱️ ${bloc.runtimeType}',
        error.toString(),
        stackTrace,
      ),
    );
    super.onError(bloc, error, stackTrace);
  }
}
