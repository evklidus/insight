import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/utils/interceptors/auth_interceptor.dart';
import 'package:insight/src/features/auth/data/auth_network_data_provider.dart';
import 'package:insight/src/features/auth/data/auth_repository.dart';
import 'package:insight/src/features/auth/data/auth_storage_data_provider.dart';
import 'package:insight/src/features/auth/model/token.dart';
import 'package:insight/src/features/categories/data/categories_network_data_provider.dart';
import 'package:insight/src/features/categories/data/categories_repository.dart';
import 'package:insight/src/features/course/data/course_network_data_provider.dart';
import 'package:insight/src/features/course/data/course_repository.dart';
import 'package:insight/src/features/learning/data/learning_network_data_provider.dart';
import 'package:insight/src/features/learning/data/learning_repository.dart';
import 'package:insight/src/features/course_page/data/course_page_network_data_provider.dart';
import 'package:insight/src/features/course_page/data/course_page_repository.dart';
import 'package:insight/src/features/invitations/data/invitations_firestore_data_provider.dart';
import 'package:insight/src/features/invitations/data/invitations_network_data_provider.dart';
import 'package:insight/src/features/invitations/data/invitations_repository.dart';
import 'package:insight/src/features/profile/data/profile_network_data_provider.dart';
import 'package:insight/src/features/profile/data/profile_repository.dart';
import 'package:insight/src/features/settings/data/theme_datasource.dart';
import 'package:insight/src/features/settings/data/theme_mode_codec.dart';
import 'package:insight/src/features/settings/data/theme_repository.dart';
import 'package:insight/src/features/app/model/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DIContainer {
  DIContainer._();

  static DIContainer get instance => _instance ??= DIContainer._();

  static DIContainer? _instance;

  // DB
  late final SharedPreferences sharedPreferences;

  // Network
  late final Dio authClient;
  late final Dio restClient;

  // Firebase
  late final FirebaseAuth firebaseAuth;
  late final FirebaseFirestore firebaseFirestore;
  late final FirebaseStorage firebaseStorage;

  // Data Providers
  late final AuthNetworkDataProvider authNetworkDataProvider;
  late final AuthStorageDataProvider authStorageDataProvider;
  late final CategoriesNetworkDataProvider categoriesNetworkDataProvider;
  late final CourseNetworkDataProvider courseNetworkDataProvider;
  late final LearningNetworkDataProvider learningNetworkDataProvider;
  late final CoursePageNetworkDataProvider coursePageNetworkDataProvider;
  late final InvitationsNetworkDataProvider invitationsNetworkDataProvider;
  late final ProfileNetworkDataProvider profileNetworkDataProvider;
  late final ThemeDataSource themeDataSource;

  // Repositories
  late final AuthRepository authRepository;
  late final CategoriesRepository categoriesRepository;
  late final CourseRepository coursesRepository;
  late final LearningRepository learningRepository;
  late final CoursePageRepository coursePageRepository;
  late final InvitationsRepository invitationsRepository;
  late final ProfileRepository profileRepository;
  late final ThemeRepository themeRepository;

  late final AppTheme? theme;

  Future<void> initDeps() async {
    // DB
    sharedPreferences = await SharedPreferences.getInstance();
    authStorageDataProvider =
        AuthStorageDataProviderImpl(sharedPreferences: sharedPreferences);

    // Network
    authClient = Dio(BaseOptions(baseUrl: kBaseUrl));

    final isAuthenticatedController = StreamController<bool>();
    Stream<bool> isAuthenticatedStream =
        isAuthenticatedController.stream.asBroadcastStream(
      onListen: (_) => isAuthenticatedController.add(
        sharedPreferences.getString('auth.accessToken').isNotNull,
      ),
    );

    restClient = Dio(BaseOptions(baseUrl: kBaseUrl));
    restClient.interceptors.add(
      AuthInterceptor(
        getTokenFromDB: () async =>
            sharedPreferences.getString('auth.accessToken'),
        refreshToken: () {
          authStorageDataProvider.setLogout();
          isAuthenticatedController.add(false);
        },
        tryRefreshToken: () async {
          final refreshToken =
              await authStorageDataProvider.getRefreshToken();
          if (refreshToken == null || refreshToken.isEmpty) return false;
          try {
            final response = await authClient.post(
              '/refresh',
              data: {'refresh_token': refreshToken},
            );
            final data = response.data;
            if (data case Map<String, dynamic> json) {
              final token = Token.fromJson(json);
              await authStorageDataProvider.setLoginData(
                accessToken: token.accessToken,
                refreshToken: token.refreshToken,
              );
              return true;
            }
          } catch (_) {}
          return false;
        },
        retryDio: restClient,
      ),
    );

    // Firebase
    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;
    firebaseStorage = FirebaseStorage.instance;

    // Data Providers — Backend для dev и prod (USE_FIREBASE=true для Firebase)
    const useBackend =
        !bool.fromEnvironment('USE_FIREBASE', defaultValue: false);
    if (useBackend) {
      authNetworkDataProvider =
          AuthNetworkDataProviderImpl(authClient, restClient);
      categoriesNetworkDataProvider =
          CategoriesNetworkDataProviderImpl(restClient);
      courseNetworkDataProvider = CourseNetworkDataProviderImpl(restClient);
      learningNetworkDataProvider =
          LearningNetworkDataProviderImpl(restClient);
      coursePageNetworkDataProvider =
          CoursePageNetworkDataProviderImpl(restClient);
      invitationsNetworkDataProvider =
          InvitationsNetworkDataProviderImpl(restClient);
      profileNetworkDataProvider = ProfileNetworkDataProviderImpl(restClient);
    } else {
      authNetworkDataProvider = AuthFirebaseDataProviderImpl(
        firebaseAuth,
        firebaseFirestore,
      );
      categoriesNetworkDataProvider = CategoriesFirestoreDataProviderImpl(
        firebaseFirestore,
      );
      courseNetworkDataProvider = CourseFirestoreDataProviderImpl(
        firebaseAuth,
        firebaseFirestore,
        firebaseStorage,
      );
      learningNetworkDataProvider =
          const LearningFirestoreDataProviderImpl();
      coursePageNetworkDataProvider = CoursePageFirestoreDataProviderImpl(
        firebaseAuth,
        firebaseFirestore,
        firebaseStorage,
      );
      invitationsNetworkDataProvider =
          const InvitationsFirestoreDataProviderImpl();
      profileNetworkDataProvider = ProfileFirestoreDataProviderImpl(
        firestore: firebaseFirestore,
        firebaseAuth: firebaseAuth,
        firebaseStorage: firebaseStorage,
      );
    }
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
    learningRepository = LearningRepositoryImpl(
      networkDataProvider: learningNetworkDataProvider,
    );
    coursePageRepository = CoursePageRepositoryImpl(
      networkDataProvider: coursePageNetworkDataProvider,
    );
    invitationsRepository = InvitationsRepositoryImpl(
      networkDataProvider: invitationsNetworkDataProvider,
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
