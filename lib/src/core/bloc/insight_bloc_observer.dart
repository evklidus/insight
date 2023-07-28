import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stack_trace/stack_trace.dart';

class InsightBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    log(
      formatError(
        '${bloc.runtimeType}',
        error.toString(),
        stackTrace,
      ),
    );
    super.onError(bloc, error, stackTrace);
  }
}

String formatError(
  String type,
  String error,
  StackTrace? stackTrace,
) {
  final trace = stackTrace ?? StackTrace.current;

  final buffer = StringBuffer(type)
    ..write(' 🆘 error: ')
    ..writeln(error)
    ..writeln('Stack trace:')
    ..write(Trace.from(trace).terse);

  return buffer.toString();
}
