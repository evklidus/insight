// Mocks generated by Mockito 5.4.2 from annotations
// in insight/test/unit/categories/data_sources/categories_remote_datasource_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:rest_client/src/client/rest_client.dart' as _i4;
import 'package:rest_client/src/dto/category/category_dto.dart' as _i6;
import 'package:rest_client/src/dto/course/course_dto.dart' as _i7;
import 'package:rest_client/src/dto/course_page/course_page_dto.dart' as _i2;
import 'package:rest_client/src/dto/user/user_dto.dart' as _i3;

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

class _FakeCoursePageDTO_0 extends _i1.SmartFake implements _i2.CoursePageDTO {
  _FakeCoursePageDTO_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserDTO_1 extends _i1.SmartFake implements _i3.UserDTO {
  _FakeUserDTO_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [RestClient].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockRestClient extends _i1.Mock implements _i4.RestClient {
  MockRestClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<List<_i6.CategoryDTO>> getCategories() => (super.noSuchMethod(
        Invocation.method(
          #getCategories,
          [],
        ),
        returnValue:
            _i5.Future<List<_i6.CategoryDTO>>.value(<_i6.CategoryDTO>[]),
      ) as _i5.Future<List<_i6.CategoryDTO>>);
  @override
  _i5.Future<List<_i7.CourseDTO>> getCoursesByCategoryTag(
          String? categoryTag) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCoursesByCategoryTag,
          [categoryTag],
        ),
        returnValue: _i5.Future<List<_i7.CourseDTO>>.value(<_i7.CourseDTO>[]),
      ) as _i5.Future<List<_i7.CourseDTO>>);
  @override
  _i5.Future<_i2.CoursePageDTO> getCoursePage(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCoursePage,
          [id],
        ),
        returnValue: _i5.Future<_i2.CoursePageDTO>.value(_FakeCoursePageDTO_0(
          this,
          Invocation.method(
            #getCoursePage,
            [id],
          ),
        )),
      ) as _i5.Future<_i2.CoursePageDTO>);
  @override
  _i5.Future<_i3.UserDTO> getUser() => (super.noSuchMethod(
        Invocation.method(
          #getUser,
          [],
        ),
        returnValue: _i5.Future<_i3.UserDTO>.value(_FakeUserDTO_1(
          this,
          Invocation.method(
            #getUser,
            [],
          ),
        )),
      ) as _i5.Future<_i3.UserDTO>);
}
