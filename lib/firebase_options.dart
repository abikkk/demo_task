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
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBF4p9hW6RGKV5x92PWGpB4cwOFkRbcKHA',
    appId: '1:687218226224:android:d7342e796d7704f3ef69f5',
    messagingSenderId: '687218226224',
    projectId: 'fir-task-d8717',
    storageBucket: 'fir-task-d8717.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDA2xFMgeb-h_JOZY35iJUy47t-TMMIGw0',
    appId: '1:687218226224:ios:0b403c3263e86be4ef69f5',
    messagingSenderId: '687218226224',
    projectId: 'fir-task-d8717',
    storageBucket: 'fir-task-d8717.appspot.com',
    iosClientId: '687218226224-46rjsarads9g0g9b5thcmc54qu1uvmi2.apps.googleusercontent.com',
    iosBundleId: 'com.example.demoTask',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAtmN9Rmiqb5epbYrkGW25_SMJirXyWYzs',
    appId: '1:687218226224:web:519e8dac60411bedef69f5',
    messagingSenderId: '687218226224',
    projectId: 'fir-task-d8717',
    authDomain: 'fir-task-d8717.firebaseapp.com',
    storageBucket: 'fir-task-d8717.appspot.com',
    measurementId: 'G-Q63Q3DX69Q',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDA2xFMgeb-h_JOZY35iJUy47t-TMMIGw0',
    appId: '1:687218226224:ios:0b403c3263e86be4ef69f5',
    messagingSenderId: '687218226224',
    projectId: 'fir-task-d8717',
    storageBucket: 'fir-task-d8717.appspot.com',
    iosClientId: '687218226224-46rjsarads9g0g9b5thcmc54qu1uvmi2.apps.googleusercontent.com',
    iosBundleId: 'com.example.demoTask',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAtmN9Rmiqb5epbYrkGW25_SMJirXyWYzs',
    appId: '1:687218226224:web:85145566d5318253ef69f5',
    messagingSenderId: '687218226224',
    projectId: 'fir-task-d8717',
    authDomain: 'fir-task-d8717.firebaseapp.com',
    storageBucket: 'fir-task-d8717.appspot.com',
    measurementId: 'G-MJWYCP1TER',
  );

}