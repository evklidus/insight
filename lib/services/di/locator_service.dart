import 'package:app_links/app_links.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:insight/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:insight/features/categories/data/repositories/categories_repository_impl.dart';
import 'package:insight/features/categories/domain/repositories/categories_repository.dart';
import 'package:insight/features/categories/domain/usecases/get_categories.dart';
import 'package:insight/features/categories/presentation/stores/categories_store.dart';
import 'package:insight/features/course_page/data/datasources/course_page_remote_datasource.dart';
import 'package:insight/features/course_page/data/repositories/course_page_repository_impl.dart';
import 'package:insight/features/course_page/domain/repositories/course_page_repository.dart';
import 'package:insight/features/course_page/domain/usecases/get_course_page.dart';
import 'package:insight/features/course_page/presentation/store/course_page_store.dart';
import 'package:insight/features/courses_previews/data/datasources/courses_preview_remote_datasource.dart';
import 'package:insight/features/courses_previews/data/repositories/courses_preview_repository_impl.dart';
import 'package:insight/features/courses_previews/domain/repositories/courses_preview_repository.dart';
import 'package:insight/features/courses_previews/domain/usecases/get_courses_preview_.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:insight/features/courses_previews/presentation/store/courses_preview_store.dart';
import 'package:insight/services/http/network_info.dart';
import 'package:insight/services/http/rest_client.dart';
import 'package:insight/services/links/applinks_provider_service.dart';
import 'package:insight/services/links/applinks_service.dart';
import 'package:insight/services/navigation/app_router.dart';
import 'package:insight/services/navigation/guards/internet_guard.dart';

final getIt = GetIt.instance;

void setup() {
  // Services
  getIt.registerSingleton<AppRouter>(
    AppRouter(internetGuard: InternetGuard()),
  );
  // getIt.registerLazySingleton<AppLinksProviderService>(
  //   () => AppLinksProviderService(appRouter: getIt()),
  // );
  // getIt.registerSingleton<AppLinksService>(
  //   AppLinksService(
  //     appLinks: AppLinks(),
  //     appLinksProvider: getIt(),
  //   ),
  // );

  // MobX
  getIt.registerFactory(() => CategoriesStore(getIt()));
  getIt.registerFactory(() => CoursesPreviewStore(getIt()));
  getIt.registerFactory(() => CoursePageStore(getIt()));

  // Use Cases
  getIt.registerLazySingleton(
    () => GetCategories(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetCoursesPreview(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetCoursePage(getIt()),
  );

  // Repositories
  getIt.registerFactory<CategoriesRepository>(
    () => CategoriesRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerFactory<CoursesPreviewRepository>(
    () => CoursesPreviewRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerFactory<CoursePageRepository>(
    () => CoursePageRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Data Sources
  getIt.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CoursesPreviewRemoteDataSource>(
    () => CoursesPreviewRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CoursePageRemoteDataSource>(
    () => CoursePageRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImp(getIt()),
  );

  final dio = Dio();
  final client = RestClient(dio);
  getIt.registerLazySingleton(() => client);
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
