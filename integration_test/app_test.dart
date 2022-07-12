import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:m_sport/features/program_page/presentation/screens/main/program_page_screen.dart';
import 'package:m_sport/features/program_page/presentation/screens/main/training_screen.dart';
import 'package:m_sport/features/program_page/presentation/widgets/training_view.dart';
import 'package:m_sport/features/programs/presentation/widgets/program_widget.dart';
import 'package:m_sport/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // testWidgets('Tap to program', (WidgetTester tester) async {
  //   app.main();
  //   await tester.pumpAndSettle();
  //   final Finder program = find.byType(ProgramWidget).first;

  //   await tester.tap(program);
  //   await tester.pumpAndSettle();

  //   expect(find.byType(ProgramPageScreen), findsOneWidget);

  //   // final Finder training = find.byType(TrainingView).first;
  //   // await tester.tap(training);
  //   // await tester.pumpAndSettle();

  //   // expect(find.byType(TrainingScreen), findsOneWidget);
  // });

  testWidgets('Tap to training', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    final Finder program = find.byType(ProgramWidget).first;

    await tester.tap(program);
    await tester.pumpAndSettle();
    // final Finder training = find.byType(TrainingView).first;
    // await tester.tap(training);
    // await tester.pumpAndSettle();

    expect(find.byType(ProgramPageScreen), findsOneWidget);
  });
}
