// import 'package:flutter/widgets.dart';
// import 'package:go_router/go_router.dart';

// extension GoRelativeNamed on BuildContext {
//   void goRelativeNamed(
//     String name, {
//     Map<String, String> pathParameters = const <String, String>{},
//     Map<String, dynamic> queryParams = const <String, dynamic>{},
//     Object? extra,
//   }) {
//     final router = GoRouter.of(this);
//     final cachedParams =
//         router.routerDelegate.currentConfiguration.pathParameters;
//     final newLocation = namedLocation(
//       name,
//       pathParameters: {
//         ...cachedParams,
//         ...pathParameters,
//       },
//       queryParameters: queryParams,
//     );
//     go(newLocation, extra: extra);
//   }
// }
