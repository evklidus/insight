import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/programs/data/models/program_model.dart';

import '../../utilities/json_utilities.dart';

void main() {
  final json = jsonDecode(findJson('program'));
  const model = ProgramModel(
    id: 0,
    name: 'name',
    imageUrl:
        'https://www.apple.com/v/apple-fitness-plus/l/images/meta/apple-fitness-plus__eafl9rq9woom_og.png',
  );
  group('work with json', () {
    test('fromJson', () {
      final result = ProgramModel.fromJson(json);
      expect(result, model);
    });

    test('toJson', () {
      final result = model.toJson();
      expect(result, json);
    });
  });
}
