import 'package:insight/services/navigation/app_router.dart';

class AppLinksProviderService {
  final AppRouter appRouter;
  AppLinksProviderService({required this.appRouter});

  void pushUrlCoolBoot(Uri event) {
    final pathSegments = event.pathSegments;
    if (pathSegments.first == 'root') {
      appRouter.push(const RootRoute());
    }
    handleUrl(Uri(
        pathSegments: [pathSegments.last],
        queryParameters: event.queryParameters));
  }

  void handleUrl(Uri event) {
    final pathSegments = event.pathSegments;
    // final queryParameters = event.queryParameters;

    if (pathSegments.last == 'programs') {
      appRouter.navigate(
        const RootRoute(
          children: [
            ProgramsRoute(),
          ],
        ),
      );
    }
  }
}
