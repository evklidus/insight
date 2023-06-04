import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:insight/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:insight/features/categories/data/repositories/categories_repository_impl.dart';
import 'package:insight/features/categories/domain/repositories/categories_repository.dart';
import 'package:insight/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:insight/features/course_page/data/data_sources/course_page_remote_data_source.dart';
import 'package:insight/features/course_page/data/repositories/course_page_repository_impl.dart';
import 'package:insight/features/course_page/domain/repositories/course_page_repository.dart';
import 'package:insight/features/course_page/presentation/bloc/course_page_bloc.dart';
import 'package:insight/features/course_previews/data/data_sources/course_previews_remote_data_source.dart';
import 'package:insight/features/course_previews/data/repositories/courses_preview_repository_impl.dart';
import 'package:insight/features/course_previews/domain/repositories/courses_preview_repository.dart';
import 'package:insight/features/course_previews/presentation/bloc/course_previews_bloc.dart';
import 'package:insight/core/http/rest_client.dart';
import 'package:insight/core/navigation/app_router.dart';

final getIt = GetIt.instance;

void setup() {
  // Services
  getIt.registerSingleton<AppRouter>(
    AppRouter(),
  );

  // Bloc
  getIt.registerFactory(() => CategoriesBloc(getIt()));
  getIt.registerFactory(() => CoursePreviewsBloc(getIt()));
  getIt.registerFactory(() => CoursePageBloc(getIt()));

  // Repositories
  getIt.registerFactory<CategoriesRepository>(
    () => CategoriesRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );
  getIt.registerFactory<CoursesPreviewRepository>(
    () => CoursesPreviewRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );
  getIt.registerFactory<CoursePageRepository>(
    () => CoursePageRepositoryImpl(
      remoteDataSource: getIt(),
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

  final dio = Dio();
  final client = RestClient(dio);
  getIt.registerLazySingleton(() => client);
}
