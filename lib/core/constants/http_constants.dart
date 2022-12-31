class HttpConstants {
  static const baseUrl =
      'https://cicdtest-e5722-default-rtdb.europe-west1.firebasedatabase.app/';

  static const getCategories = '/categories.json';

  static const getCoursesPreviewByCategoryTagPath = 'categoryTag';
  static const getCoursesPreviewByCategoryTag =
      '/course_preview.json?orderBy="tag"&equalTo="{$getCoursesPreviewByCategoryTagPath}"';

  static const getCoursePath = 'getCoursePath';
  static const getCourse = '/courses/{$getCoursePath}/.json';
}
