import 'package:auth_client/auth_client.dart';
import 'package:database/insight_db.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:insight/features/auth/bloc/auth_bloc.dart';
import 'package:insight/features/auth/data/data_sources/auth_data_source.dart';
import 'package:insight/features/auth/data/repositories/auth_repository.dart';
import 'package:insight/features/categories/bloc/categories_bloc.dart';
import 'package:insight/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:insight/features/categories/data/repositories/categories_repository.dart';
import 'package:insight/features/course_page/bloc/course_page_bloc.dart';
import 'package:insight/features/course_page/data/data_sources/course_page_remote_data_source.dart';
import 'package:insight/features/course_page/data/repositories/course_page_repository.dart';
import 'package:insight/features/course_previews/bloc/course_previews_bloc.dart';
import 'package:insight/features/course_previews/data/data_sources/course_previews_remote_data_source.dart';
import 'package:insight/features/course_previews/data/repositories/courses_preview_repository.dart';
import 'package:insight/core/navigation/app_router.dart';
import 'package:rest_client/rest_client.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // DB
  final insightDB = InsightDB();

  await insightDB.init();

  getIt.registerLazySingleton<InsightDB>(() => insightDB);

  // Network
  final dio = Dio();

  getIt.registerLazySingleton(() => AuthClient(dio));

  dio.interceptors.add(
    AuthInterceptor(
      isAuthorizedFromDB: insightDB.isAuthorized,
      getTokenFromDB: insightDB.getToken,
    ),
  );

  getIt.registerLazySingleton(() => RestClient(dio));

  // Services
  getIt.registerSingleton<AppRouter>(
    AppRouter(),
  );

  // Bloc
  getIt.registerFactory(() => AuthBloc(getIt()));
  getIt.registerFactory(() => CategoriesBloc(getIt()));
  getIt.registerFactory(() => CoursePreviewsBloc(getIt()));
  getIt.registerFactory(() => CoursePageBloc(getIt()));

  // Repositories
  getIt.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
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
  getIt.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      authClient: getIt(),
      insightDB: getIt(),
    ),
  );
  getIt.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CoursePreviewsRemoteDataSource>(
    () => CoursePreviewsRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CoursePageRemoteDataSource>(
    () => CoursePageRemoteDataSourceImpl(getIt()),
  );
}
