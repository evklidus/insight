import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/courses_preview/data/models/course_preview_model.dart';
import 'package:insight/features/courses_preview/presentation/widgets/course_preview_widget.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

const programModel = ProgramModel(
  id: 0,
  name: 'name',
  imageUrl:
      'https://www.apple.com/v/apple-fitness-plus/l/images/meta/apple-fitness-plus__eafl9rq9woom_og.png',
);

void main() {
  testWidgets("Flutter Widget Test", (WidgetTester tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(const TestApp(
        ProgramWidget(
          program: programModel,
        ),
      ));
      var image = find.byType(Image);
      expect(image, findsOneWidget);
    });
  });
}

class TestApp extends StatelessWidget {
  const TestApp(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: child,
    );
  }
}
