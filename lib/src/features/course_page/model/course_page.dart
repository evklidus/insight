import 'package:insight/src/features/course/model/course.dart';
import 'package:insight/src/features/course_page/model/lesson.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
final class CoursePage extends Course {
  const CoursePage({
    required super.id,
    required super.name,
    required this.description,
    required super.imageUrl,
    this.lessons,
    required super.tag,
    required super.isItsOwn,
  });

  factory CoursePage.fromDTO(CoursePageDTO dto, String userId) =>
      throw UnimplementedError();
  // CoursePage(
  //   id: dto.id.toString(),
  //   name: dto.name,
  //   description: dto.description,
  //   imageUrl: dto.imageUrl,
  //   lessons: dto.lessons?.map(Lesson.fromDTO).toList(),
  // )

  factory CoursePage.fromFirestore(
    String id,
    Map<String, dynamic>? courseData,
    Map<String, dynamic>? detailData,
    String userId,
  ) =>
      CoursePage(
        id: id,
        name: courseData!['name'],
        description: detailData!['description'],
        imageUrl: courseData['image_url'],
        lessons: detailData['lessons'] != null
            ? List.of(detailData['lessons'])
                .map(
                  (lessonData) => Lesson(
                    name: lessonData['name'],
                    videoUrl: lessonData['video_url'],
                  ),
                )
                .toList()
            : null,
        tag: courseData['tag'],
        isItsOwn: courseData['owner_id'] == userId,
      );

  final String description;
  final List<Lesson>? lessons;
}
