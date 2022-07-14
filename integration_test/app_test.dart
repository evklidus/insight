import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:m_sport/components/rounded_back_icon.dart';
import 'package:m_sport/features/program_page/presentation/screens/main/program_page_screen.dart';
import 'package:m_sport/features/program_page/presentation/screens/main/training_screen.dart';
import 'package:m_sport/features/program_page/presentation/widgets/close_icon.dart';
import 'package:m_sport/features/program_page/presentation/widgets/play_pause_button.dart';
import 'package:m_sport/features/program_page/presentation/widgets/training_view.dart';
import 'package:m_sport/features/programs/presentation/screens/main/programs_screen.dart';
import 'package:m_sport/features/programs/presentation/widgets/program_widget.dart';
import 'package:m_sport/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App test', (WidgetTester tester) async {
    app.main(); // Testing starts at the root widget in the widget tree
    await tester.pumpAndSettle(); // Wait for all the animations to finish

    final Finder program = find.byType(ProgramWidget).first;
    await tester.tap(program);
    await tester.pumpAndSettle();
    expect(find.byType(ProgramPageScreen), findsOneWidget);

    final Finder training = find.byType(TrainingView).first;
    await tester.tap(training);
    await tester.pumpAndSettle();
    expect(find.byType(TrainingScreen), findsOneWidget);

    final Finder playPauseButton = find.byType(PlayPauseButton);
    await tester.tap(playPauseButton);
    await tester.pumpAndSettle();
    // expect(find.byType(TrainingScreen), findsOneWidget); //TODO: Will add correct expect

    final Finder trainingCloseIcon = find.byType(CloseIcon);
    await tester.tap(trainingCloseIcon);
    await tester.pumpAndSettle();
    expect(find.byType(ProgramPageScreen), findsOneWidget);

    final Finder programPageCloseIcon = find.byType(RoundedBackIcon);
    await tester.tap(programPageCloseIcon);
    await tester.pumpAndSettle();
    expect(find.byType(ProgramsScreen), findsOneWidget);
  });
}

