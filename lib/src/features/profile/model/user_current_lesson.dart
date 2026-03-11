class UserCurrentLesson {
  const UserCurrentLesson({
    required this.courseId,
    required this.courseName,
    required this.imageUrl,
    required this.lessonId,
    required this.lessonName,
    required this.lessonVideoUrl,
  });

  factory UserCurrentLesson.fromMap(Map<String, dynamic> map) =>
      UserCurrentLesson(
        courseId: map['course_id'] as String,
        courseName: map['course_name'] as String,
        imageUrl: map['image_url'] as String,
        lessonId: map['lesson_id'] as String? ?? '',
        lessonName: map['lesson_name'] as String,
        lessonVideoUrl: map['lesson_video_url'] as String,
      );

  factory UserCurrentLesson.fromJson(Map<String, dynamic> json) =>
      UserCurrentLesson.fromMap(json);

  final String courseId;
  final String courseName;
  final String imageUrl;
  final String lessonId;
  final String lessonName;
  final String lessonVideoUrl;

  Map<String, dynamic> toMap() => {
        'course_id': courseId,
        'course_name': courseName,
        'image_url': imageUrl,
        'lesson_id': lessonId,
        'lesson_name': lessonName,
        'lesson_video_url': lessonVideoUrl,
      };
}
