// Mocks generated by Mockito 5.4.2 from annotations
// in insight/test/unit/course_page/bloc/course_page_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:insight/src/features/course_page/data/course_page_repository.dart'
    as _i2;
import 'package:insight/src/features/course_page/model/course_page.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [CoursePageRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockCoursePageRepository extends _i1.Mock
    implements _i2.CoursePageRepository {
  MockCoursePageRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.CoursePage> getCoursePage(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getCoursePage,
          [id],
        ),
        returnValue:
            _i3.Future<_i4.CoursePage>.value(_i5.dummyValue<_i4.CoursePage>(
          this,
          Invocation.method(
            #getCoursePage,
            [id],
          ),
        )),
      ) as _i3.Future<_i4.CoursePage>);
}
