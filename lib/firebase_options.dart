// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBFqe8aE2vAf5JetiE-4goa2hlbte_MP5w',
    appId: '1:966237282337:web:255abfa20ad84a0cea8360',
    messagingSenderId: '966237282337',
    projectId: 'cicdtest-e5722',
    authDomain: 'cicdtest-e5722.firebaseapp.com',
    databaseURL: 'https://cicdtest-e5722-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cicdtest-e5722.appspot.com',
    measurementId: 'G-9LE2JPVDRT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCkNuDVmxm0fyTTPZsazKBols-DNNOKpM',
    appId: '1:966237282337:android:6c1058dfd21d3f32ea8360',
    messagingSenderId: '966237282337',
    projectId: 'cicdtest-e5722',
    databaseURL: 'https://cicdtest-e5722-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cicdtest-e5722.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAt0R8cmrCz7mq85cNW4JSaYhcq7KSfpo',
    appId: '1:966237282337:ios:298070d39cabe6a6ea8360',
    messagingSenderId: '966237282337',
    projectId: 'cicdtest-e5722',
    databaseURL: 'https://cicdtest-e5722-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cicdtest-e5722.appspot.com',
    iosClientId: '966237282337-3s4ilh9o2q6295g7fgihsds5e43v145l.apps.googleusercontent.com',
    iosBundleId: 'com.example.m-insight',
  );
}