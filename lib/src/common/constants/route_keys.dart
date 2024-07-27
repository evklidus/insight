typedef RouteKey = ({String name, String path});

class RouteKeys {
  const RouteKeys._();

  // Home Tab
  static const RouteKey categories = (
    name: 'categories',
    path: '/categories',
  );
  static const RouteKey courses = (
    name: 'courses',
    path: 'courses/:tag',
  );
  static const RouteKey coursePage = (
    name: 'course-page',
    path: ':coursePageId',
  );
  static const RouteKey video = (
    name: 'video',
    path: 'video/:coursePageTitle',
  );
  static const RouteKey create = (
    name: 'create',
    path: 'create',
  );

  // Settings Tab
  static const RouteKey settings = (
    name: 'settings',
    path: '/settings',
  );
  static const RouteKey login = (
    name: 'login',
    path: 'login',
  );
  static const RouteKey register = (
    name: 'register',
    path: 'register',
  );
  static const RouteKey profile = (
    name: 'profile',
    path: 'profile',
  );
  static const RouteKey about = (
    name: 'about',
    path: 'about',
  );
}
