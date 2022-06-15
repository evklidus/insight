import 'package:app_links/app_links.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:m_sport/features/programs/data/datasources/remote_datasource.dart';
import 'package:m_sport/features/programs/data/repositories/programs_repository_impl.dart';
import 'package:m_sport/features/programs/domain/repositories/programs_repository.dart';
import 'package:m_sport/features/programs/domain/usecases/get_programs.dart';
import 'package:m_sport/features/programs/presentation/store/programs_store.dart';
import 'package:m_sport/features/trainings/data/datasources/remote_datasource.dart';
import 'package:m_sport/features/trainings/data/repositories/program_page_repository_impl.dart';
import 'package:m_sport/features/trainings/domain/repositories/program_page_repository.dart';
import 'package:m_sport/features/trainings/domain/usecases/get_program_page.dart';
import 'package:m_sport/features/trainings/presentation/store/program_page_store.dart';
import 'package:m_sport/services/http/network_info.dart';
import 'package:m_sport/services/http/rest_client.dart';
import 'package:m_sport/services/links/applinks_provider_service.dart';
import 'package:m_sport/services/links/applinks_service.dart';
import 'package:m_sport/services/navigation/app_router.dart';
import 'package:m_sport/services/navigation/guards/internet_guard.dart';

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
  getIt.registerFactory(() => ProgramsStore(getIt()));
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
