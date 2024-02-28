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
    apiKey: 'AIzaSyDqkCTGOsuWETy0y4ansNOy15GlF7kvZDM',
    appId: '1:629814471287:web:89077e42e0a08d8c097472',
    messagingSenderId: '629814471287',
    projectId: 'datn-flutter',
    authDomain: 'datn-flutter.firebaseapp.com',
    storageBucket: 'datn-flutter.appspot.com',
    measurementId: 'G-6R85LJ0565',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYzpmWcZSVJkbPxY9iBKh1fcrBZpRWH5k',
    appId: '1:629814471287:android:ab96242898078458097472',
    messagingSenderId: '629814471287',
    projectId: 'datn-flutter',
    storageBucket: 'datn-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDnfFrUR_Zyn8YiMLqTdwWxQEOXTwj31Y4',
    appId: '1:629814471287:ios:dbbebd89b402426c097472',
    messagingSenderId: '629814471287',
    projectId: 'datn-flutter',
    storageBucket: 'datn-flutter.appspot.com',
    iosBundleId: 'com.example.datn',
  );
}
