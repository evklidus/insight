// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:insight/components/rounded_back_icon.dart';
// import 'package:insight/features/courses_preview/presentation/screens/main/programs_screen.dart';
// import 'package:insight/features/courses_preview/presentation/widgets/course_preview_widget.dart';
// import 'package:insight/main.dart' as app;

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets('App test', (WidgetTester tester) async {
//     app.main(); // Testing starts at the root widget in the widget tree
//     await tester.pumpAndSettle(); // Wait for all the animations to finish

//     final Finder program = find.byType(ProgramWidget).first;
//     await tester.tap(program);
//     await tester.pumpAndSettle();
//     expect(find.byType(ProgramPageScreen), findsOneWidget);

//     final Finder training = find.byType(TrainingView).first;
//     await tester.tap(training);
//     await tester.pumpAndSettle();
//     expect(find.byType(TrainingScreen), findsOneWidget);

//     final Finder playPauseButton = find.byType(PlayPauseButton);
//     await tester.tap(playPauseButton);
//     await tester.pumpAndSettle();
//     // expect(find.byType(TrainingScreen), findsOneWidget); //TODO: Will add correct expect

//     final Finder trainingCloseIcon = find.byType(CloseIcon);
//     await tester.tap(trainingCloseIcon);
//     await tester.pumpAndSettle();
//     expect(find.byType(ProgramPageScreen), findsOneWidget);

//     final Finder programPageCloseIcon = find.byType(RoundedBackIcon);
//     await tester.tap(programPageCloseIcon);
//     await tester.pumpAndSettle();
//     expect(find.byType(ProgramsScreen), findsOneWidget);
//   });
// }
