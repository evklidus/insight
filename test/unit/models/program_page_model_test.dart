import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/courses_preview/data/models/program_page_model.dart';
import 'package:insight/features/courses_/data/models/training_model.dart';

import '../../utilities/json_utilities.dart';

void main() {
  final json = jsonDecode(findJson('program_page'));
  const model = ProgramPageModel(
    id: 0,
    trainings: [
      TrainingModel(
        name: 'Тренировка 1',
        videoUrl:
            'https://player.vimeo.com/external/438451071.hd.mp4?s=863dcc7f2bd294d7968b25a2a867bd0ca1b6522e&profile_id=175&oauth2_token_id=57447761',
      ),
    ],
  );

  group('work with json', () {
    test('fromJson', () {
      final result = ProgramPageModel.fromJson(json);
      expect(result, model);
    });

    test('toJson', () {
      final result = model.toJson();
      expect(result, json);
    });
  });
}
