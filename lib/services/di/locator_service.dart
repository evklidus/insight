import 'package:app_links/app_links.dart';
import 'package:get_it/get_it.dart';
import 'package:m_sport/services/links/applinks_provider_service.dart';
import 'package:m_sport/services/links/applinks_service.dart';
import 'package:m_sport/services/navigation/app_router.dart';
import 'package:m_sport/services/navigation/guards/internet_guard.dart';

final getIt = GetIt.instance;

void setup() {
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
}
