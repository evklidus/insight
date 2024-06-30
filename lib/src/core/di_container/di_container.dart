import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/features/auth/data/auth_network_data_provider.dart';
import 'package:auth_client/auth_client.dart';
import 'package:dio/dio.dart';
import 'package:insight/src/features/auth/data/auth_repository.dart';
import 'package:insight/src/features/auth/data/auth_storage_data_provider.dart';
import 'package:insight/src/features/categories/data/categories_network_data_provider.dart';
import 'package:insight/src/features/categories/data/categories_repository.dart';
import 'package:insight/src/features/course_page/data/course_page_network_data_provider.dart';
import 'package:insight/src/features/course_page/data/course_page_repository.dart';
import 'package:insight/src/features/course/data/course_network_data_provider.dart';
import 'package:insight/src/features/course/data/course_repository.dart';
import 'package:insight/src/features/profile/data/profile_network_data_provider.dart';
import 'package:insight/src/features/profile/data/profile_repository.dart';
import 'package:insight/src/features/settings/data/theme_datasource.dart';
import 'package:insight/src/features/settings/data/theme_mode_codec.dart';
import 'package:insight/src/features/settings/data/theme_repository.dart';
import 'package:insight/src/features/app/model/app_theme.dart';
import 'package:rest_client/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DIContainer {
  DIContainer._();

  static DIContainer get instance => _instance ??= DIContainer._();

  static DIContainer? _instance;

  // DB
  late final SharedPreferences sharedPreferences;

  // Network
  late final AuthClient authClient;
  late final RestClient restClient;

  // Firebase
  late final FirebaseAuth firebaseAuth;
  late final FirebaseFirestore firebaseFirestore;
  late final FirebaseStorage firebaseStorage;

  // Data Providers
  late final AuthNetworkDataProvider authNetworkDataProvider;
  late final AuthStorageDataProvider authStorageDataProvider;
  late final CategoriesNetworkDataProvider categoriesNetworkDataProvider;
  late final CourseNetworkDataProvider courseNetworkDataProvider;
  late final CoursePageNetworkDataProvider coursePageNetworkDataProvider;
  late final ProfileNetworkDataProvider profileNetworkDataProvider;
  late final ThemeDataSource themeDataSource;

  // Repositories
  late final AuthRepository authRepository;
  late final CategoriesRepository categoriesRepository;
  late final CourseRepository coursesRepository;
  late final CoursePageRepository coursePageRepository;
  late final ProfileRepository profileRepository;
  late final ThemeRepository themeRepository;

  late final AppTheme? theme;

  Future<void> initDeps() async {
    // DB
    sharedPreferences = await SharedPreferences.getInstance();

    // Network
    authClient = AuthClient(Dio());

    // Возможно странноватое решение, но рабочее
    final isAuthenticatedController = StreamController<bool>();
    Stream<bool> isAuthenticatedStream =
        isAuthenticatedController.stream.asBroadcastStream(
      onListen: (subscription) => isAuthenticatedController.add(
        sharedPreferences.getString('auth.accessToken').isNotNull,
      ),
    );

    final dioForRestClient = Dio()
      ..interceptors.add(
        AuthInterceptor(
          getTokenFromDB: () async =>
              sharedPreferences.getString('auth.accessToken'),
          signOut: () => isAuthenticatedController.add(false),
        ),
      );

    restClient = RestClient(dioForRestClient);

    // Firebase
    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;
    firebaseStorage = FirebaseStorage.instance;

    // Data Providers
    authNetworkDataProvider = AuthFirebaseDataProviderImpl(firebaseAuth);
    authStorageDataProvider =
        AuthStorageDataProviderImpl(sharedPreferences: sharedPreferences);
    categoriesNetworkDataProvider = CategoriesFirestoreDataProviderImpl(
      firebaseFirestore,
    );
    courseNetworkDataProvider = CourseFirestoreDataProviderImpl(
      firebaseAuth,
      firebaseFirestore,
      firebaseStorage,
    );
    coursePageNetworkDataProvider = CoursePageFirestoreDataProviderImpl(
      firebaseAuth,
      firebaseFirestore,
      firebaseStorage,
    );
    profileNetworkDataProvider = ProfileFirestoreDataProviderImpl(
      firestore: firebaseFirestore,
      firebaseAuth: firebaseAuth,
      firebaseStorage: firebaseStorage,
    );
    themeDataSource = ThemeDataSourceLocal(
      codec: const ThemeModeCodec(),
      sharedPreferences: sharedPreferences,
    );

    // Repositories
    authRepository = AuthRepositoryImpl(
      networkDataProvider: authNetworkDataProvider,
      storageDataProvider: authStorageDataProvider,
      isAuthenticatedStream: isAuthenticatedStream,
    );
    categoriesRepository = CategoriesRepositoryImpl(
      networkDataProvider: categoriesNetworkDataProvider,
    );
    coursesRepository = CourseRepositoryImpl(
      networkDataProvider: courseNetworkDataProvider,
    );
    coursePageRepository = CoursePageRepositoryImpl(
      networkDataProvider: coursePageNetworkDataProvider,
    );
    profileRepository = ProfileRepositoryImpl(
      profileNetworkDataProvider,
    );
    themeRepository = ThemeRepositoryImpl(
      themeDataSource: themeDataSource,
    );

    theme = await themeRepository.getTheme();
  }
}
