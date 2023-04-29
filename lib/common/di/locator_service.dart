import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:insight/common/http/network_info.dart';
import 'package:insight/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:insight/features/categories/data/repositories/categories_repository_impl.dart';
import 'package:insight/features/categories/domain/repositories/categories_repository.dart';
import 'package:insight/features/categories/domain/usecases/get_categories.dart';
import 'package:insight/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:insight/features/course_page/data/datasources/course_page_remote_datasource.dart';
import 'package:insight/features/course_page/data/repositories/course_page_repository_impl.dart';
import 'package:insight/features/course_page/domain/repositories/course_page_repository.dart';
import 'package:insight/features/course_page/domain/usecases/get_course_page.dart';
import 'package:insight/features/course_page/presentation/bloc/course_page_bloc.dart';
import 'package:insight/features/course_previews/data/datasources/course_previews_remote_datasource.dart';
import 'package:insight/features/course_previews/data/repositories/courses_preview_repository_impl.dart';
import 'package:insight/features/course_previews/domain/repositories/courses_preview_repository.dart';
import 'package:insight/features/course_previews/domain/usecases/get_course_previews.dart';
import 'package:insight/features/course_previews/presentation/bloc/course_previews_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:insight/common/http/rest_client.dart';
import 'package:insight/common/navigation/app_router.dart';
import 'package:insight/common/navigation/guards/internet_guard.dart';

final getIt = GetIt.instance;

void setup() {
  // Services
  getIt.registerSingleton<AppRouter>(
    AppRouter(internetGuard: InternetGuard()),
  );

  // Bloc
  getIt.registerFactory(() => CategoriesBloc(getIt()));
  getIt.registerFactory(() => CoursePreviewsBloc(getIt()));
  getIt.registerFactory(() => CoursePageBloc(getIt()));

  // Use Cases
  getIt.registerLazySingleton(
    () => GetCategories(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetCoursePreviews(getIt()),
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
  getIt.registerLazySingleton<CoursePreviewsRemoteDataSource>(
    () => CoursePreviewsRemoteDataSourceImpl(getIt()),
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
