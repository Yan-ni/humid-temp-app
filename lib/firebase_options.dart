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
    apiKey: 'AIzaSyDSoCGgpVO81Fpe83jTUSVFMW9isGNlfNQ',
    appId: '1:267876585847:web:a3f5e4256562f811a49172',
    messagingSenderId: '267876585847',
    projectId: 'humidtemp-1dc76',
    authDomain: 'humidtemp-1dc76.firebaseapp.com',
    databaseURL: 'https://humidtemp-1dc76-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'humidtemp-1dc76.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUzYwBl4dfBZO5KJfrAOTn36GHRGENdgQ',
    appId: '1:267876585847:android:2373c9df08333bcaa49172',
    messagingSenderId: '267876585847',
    projectId: 'humidtemp-1dc76',
    databaseURL: 'https://humidtemp-1dc76-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'humidtemp-1dc76.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCj3Jftp7W9nY-uNGbI2Es7yYu4hjkALTM',
    appId: '1:267876585847:ios:d92cc9adccfe72f0a49172',
    messagingSenderId: '267876585847',
    projectId: 'humidtemp-1dc76',
    databaseURL: 'https://humidtemp-1dc76-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'humidtemp-1dc76.appspot.com',
    iosBundleId: 'com.example.humidtemp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCj3Jftp7W9nY-uNGbI2Es7yYu4hjkALTM',
    appId: '1:267876585847:ios:dfba6b79a861c705a49172',
    messagingSenderId: '267876585847',
    projectId: 'humidtemp-1dc76',
    databaseURL: 'https://humidtemp-1dc76-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'humidtemp-1dc76.appspot.com',
    iosBundleId: 'com.example.humidtemp.RunnerTests',
  );
}
