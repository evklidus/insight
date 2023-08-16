import 'package:insight/src/features/course_page/model/lesson.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
final class CoursePage {
  const CoursePage({
    required this.id,
    required this.imageUrl,
    required this.lessons,
  });

  factory CoursePage.fromDTO(CoursePageDTO dto) => CoursePage(
        id: dto.id.toString(),
        imageUrl: dto.imageUrl,
        lessons: dto.lessons.map(Lesson.fromDTO).toList(),
      );

  factory CoursePage.fromFirestore(
    String id,
    Map<String, dynamic>? courseData,
    Map<String, dynamic>? detailData,
  ) =>
      CoursePage(
        id: id,
        imageUrl: courseData!['image_url'],
        lessons: List.of(detailData!['lessons'])
            .map(
              (lessonData) => Lesson(
                name: lessonData['name'],
                videoUrl: lessonData['video_url'],
              ),
            )
            .toList(),
      );

  final String id;
  final String imageUrl;
  final List<Lesson> lessons;
}
