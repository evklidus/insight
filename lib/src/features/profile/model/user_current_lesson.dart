class UserCurrentLesson {
  const UserCurrentLesson({
    required this.courseId,
    required this.courseName,
    required this.imageUrl,
    required this.lessonName,
    required this.lessonVideoUrl,
  });

  factory UserCurrentLesson.fromMap(Map<String, dynamic> map) =>
      UserCurrentLesson(
        courseId: map['course_id'],
        courseName: map['course_name'],
        imageUrl: map['image_url'],
        lessonName: map['lesson_name'],
        lessonVideoUrl: map['lesson_video_url'],
      );

  final String courseId;
  final String courseName;
  final String imageUrl;
  final String lessonName;
  final String lessonVideoUrl;

  Map<String, dynamic> toMap() => {
        'course_id': courseId,
        'course_name': courseName,
        'image_url': imageUrl,
        'lesson_name': lessonName,
        'lesson_video_url': lessonVideoUrl,
      };
}
