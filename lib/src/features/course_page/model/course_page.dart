import 'package:insight/src/features/course_page/model/lesson.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
final class CoursePage {
  const CoursePage({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.lessons,
  });

  factory CoursePage.fromDTO(CoursePageDTO dto) => CoursePage(
        id: dto.id.toString(),
        name: dto.name,
        description: dto.description,
        imageUrl: dto.imageUrl,
        lessons: dto.lessons?.map(Lesson.fromDTO).toList(),
      );

  factory CoursePage.fromFirestore(
    String id,
    Map<String, dynamic>? courseData,
    Map<String, dynamic>? detailData,
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
      );

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<Lesson>? lessons;
}
