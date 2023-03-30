import 'package:auto_route/auto_route.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:insight/services/navigation/app_router.dart';

class InternetGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      resolver.next(true);
    } else {
      router.push(
        InternetWarningRoute(
          onResult: (success) {
            resolver.next(success);
          },
        ),
      );
    }
  }
}
