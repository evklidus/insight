import 'package:stack_trace/stack_trace.dart';

String formatError(
  String type,
  String error,
  StackTrace? stackTrace,
) {
  final trace = stackTrace ?? StackTrace.current;

  final buffer = StringBuffer(type)
    ..write(' error: ')
    ..writeln(error)
    ..writeln('Stack trace:')
    ..write(Trace.from(trace).terse);

  return buffer.toString();
}
