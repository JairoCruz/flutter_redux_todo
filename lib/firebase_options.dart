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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCmA8f7KZpLOOn8_8Et52T7FjcqQLnZNTE',
    appId: '1:819584574397:web:7dd1f3900c53488e2768d4',
    messagingSenderId: '819584574397',
    projectId: 'todolistswitfui',
    authDomain: 'todolistswitfui.firebaseapp.com',
    databaseURL: 'https://todolistswitfui.firebaseio.com',
    storageBucket: 'todolistswitfui.appspot.com',
    measurementId: 'G-ZZ9DYT5QQG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwXQbCC_uYkVjjxk2BLJdS48UqQCxREo8',
    appId: '1:819584574397:android:b075b7c18fe545ce2768d4',
    messagingSenderId: '819584574397',
    projectId: 'todolistswitfui',
    databaseURL: 'https://todolistswitfui.firebaseio.com',
    storageBucket: 'todolistswitfui.appspot.com',
  );
}
