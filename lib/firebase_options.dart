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
    apiKey: '',
    appId: '1:675536928491:web:1be0977092a58f37a108ae',
    messagingSenderId: '675536928491',
    projectId: 'rksh-user-app',
    authDomain: 'rksh-user-app.firebaseapp.com',
    storageBucket: 'rksh-user-app.appspot.com',
    measurementId: 'G-TJD63Z57W3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',
    appId: '1:675536928491:android:e9792cb0c73f900ca108ae',
    messagingSenderId: '675536928491',
    projectId: 'rksh-user-app',
    storageBucket: 'rksh-user-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '',
    appId: '1:675536928491:ios:9c7fed9fda85202ca108ae',
    messagingSenderId: '675536928491',
    projectId: 'rksh-user-app',
    storageBucket: 'rksh-user-app.appspot.com',
    iosClientId: '675536928491-hreb8m1rdeoqtrqtu1pttrbieoeki6rs.apps.googleusercontent.com',
    iosBundleId: 'com.example.userapp',
  );
}
