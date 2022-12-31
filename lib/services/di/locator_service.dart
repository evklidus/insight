import 'package:app_links/app_links.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:insight/features/courses_preview/data/datasources/courses_preview_remote_datasource.dart';
import 'package:insight/features/courses_preview/data/repositories/courses_preview_repository_impl.dart';
import 'package:insight/features/courses_preview/domain/repositories/courses_preview_repository.dart';
import 'package:insight/features/courses_preview/domain/usecases/get_courses_preview_.dart';
import 'package:insight/features/courses_preview/presentation/store/courses_preview_store.dart';
import 'package:insight/features/courses_preview/data/datasources/program_page_remote_datasource.dart';
import 'package:insight/features/courses_preview/data/repositories/program_page_repository_impl.dart';
import 'package:insight/features/courses_preview/domain/repositories/program_page_repository.dart';
import 'package:insight/features/courses_preview/domain/usecases/get_program_page.dart';
import 'package:insight/features/courses_preview/presentation/store/program_page_store.dart';
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
  getIt.registerLazySingleton<AppLinksProviderService>(
    () => AppLinksProviderService(appRouter: getIt()),
  );
  getIt.registerSingleton<AppLinksService>(
    AppLinksService(
      appLinks: AppLinks(),
      appLinksProvider: getIt(),
    ),
  );

  // MobX
  getIt.registerFactory(() => CoursesPreviewStore(getIt()));
  getIt.registerFactory(() => ProgramPageStore(getIt()));

  // Use Cases
  getIt.registerLazySingleton(
    () => GetPrograms(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetProgramPage(getIt()),
  );

  // Repositories
  getIt.registerFactory<ProgramsRepository>(
    () => ProgramsRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerFactory<ProgramPageRepository>(
    () => ProgramPageRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Data Sources
  getIt.registerLazySingleton<ProgramsRemoteDataSource>(
    () => ProgramsRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ProgramPageRemoteDataSource>(
    () => ProgramPageRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImp(getIt()),
  );

  final dio = Dio();
  final client = RestClient(dio);
  getIt.registerLazySingleton(() => client);
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
