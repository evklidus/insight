import 'package:auth_client/auth_client.dart';
import 'package:database/insight_db.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:insight/src/features/auth/bloc/auth_bloc.dart';
import 'package:insight/src/features/auth/data/auth_network_data_provider.dart';
import 'package:insight/src/features/auth/data/auth_repository.dart';
import 'package:insight/src/features/auth/data/auth_storage_data_provider.dart';
import 'package:insight/src/features/categories/bloc/categories_bloc.dart';
import 'package:insight/src/features/categories/data/categories_network_data_provider.dart';
import 'package:insight/src/features/categories/data/categories_repository.dart';
import 'package:insight/src/features/course_page/bloc/course_page_bloc.dart';
import 'package:insight/src/features/course_page/data/course_page_network_data_provider.dart';
import 'package:insight/src/features/course_page/data/course_page_repository.dart';
import 'package:insight/src/features/course_previews/bloc/course_previews_bloc.dart';
import 'package:insight/src/features/course_previews/data/course_previews_network_data_provider.dart';
import 'package:insight/src/features/course_previews/data/courses_preview_repository.dart';
import 'package:insight/src/core/navigation/app_router.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight/src/features/profile/data/profile_network_data_provider.dart';
import 'package:insight/src/features/profile/data/profile_repository.dart';
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
    () => AuthRepositoryImpl(
      networkDataProvider: getIt(),
      storageDataProvider: getIt(),
    ),
  );
  getIt.registerFactory<CategoriesRepository>(
    () => CategoriesRepositoryImpl(
      networkDataProvider: getIt(),
    ),
  );
  getIt.registerFactory<CoursesPreviewRepository>(
    () => CoursesPreviewRepositoryImpl(
      networkDataProvider: getIt(),
    ),
  );
  getIt.registerFactory<CoursePageRepository>(
    () => CoursePageRepositoryImpl(
      networkDataProvider: getIt(),
    ),
  );
  getIt.registerFactory<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt()),
  );

  // Data Providers
  getIt.registerLazySingleton<AuthNetworkDataProvider>(
    () => AuthNetworkDataProviderImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthStorageDataProvider>(
    () => AuthStorageDataProviderImpl(getIt()),
  );
  getIt.registerLazySingleton<CategoriesNetworkDataProvider>(
    () => CategoriesNetworkDataProviderImpl(getIt()),
  );
  getIt.registerLazySingleton<CoursePreviewsNetworkDataProvider>(
    () => CoursePreviewsNetworkDataProviderImpl(getIt()),
  );
  getIt.registerLazySingleton<CoursePageNetworkDataProvider>(
    () => CoursePageNetworkDataProviderImpl(getIt()),
  );
  getIt.registerLazySingleton<ProfileNetworkDataProvider>(
    () => ProfileNetworkDataProviderImpl(getIt()),
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
