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
import 'package:insight/features/profile/bloc/profile_bloc.dart';
import 'package:insight/features/profile/data/data_provider/profile_data_provider.dart';
import 'package:insight/features/profile/data/repositories/profile_repository.dart';
import 'package:rest_client/rest_client.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // Services
  getIt.registerSingleton<AppRouter>(
    AppRouter(),
  );

  // Bloc
  getIt.registerLazySingleton(() => AuthBloc(getIt()));
  getIt.registerFactory(() => CategoriesBloc(getIt()));
  getIt.registerFactory(() => CoursePreviewsBloc(getIt()));
  getIt.registerFactory(() => CoursePageBloc(getIt()));
  getIt.registerFactory(() => ProfileBloc(getIt()));

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
  getIt.registerFactory<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt()),
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
  getIt.registerLazySingleton<ProfileDataProvider>(
    () => ProfileDataProviderImpl(getIt()),
  );

  // DB
  final insightDB = await InsightDB.getInstance();

  getIt.registerLazySingleton<InsightDB>(() => insightDB);

  // Network
  final dioForAuthClient = Dio();

  getIt.registerLazySingleton(() => AuthClient(dioForAuthClient));

  final dioForRestClient = Dio();

  dioForRestClient.interceptors.add(
    AuthInterceptor(
      isAuthorizedFromDB: getIt.get<InsightDB>().isAuthorized,
      getTokenFromDB: getIt.get<InsightDB>().getToken,
      signOut: () => getIt.get<AuthBloc>().add(const AuthEvent.logout()),
    ),
  );

  getIt.registerLazySingleton(() => RestClient(dioForRestClient));
}
