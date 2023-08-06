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
    apiKey: 'AIzaSyCYifgblNoq-cYEAXpUFyzMlpfuXFtNtYc',
    appId: '1:21784424587:web:182e43a8fad5997cbc648e',
    messagingSenderId: '21784424587',
    projectId: 'mosaic-bluenco',
    authDomain: 'mosaic-bluenco.firebaseapp.com',
    storageBucket: 'mosaic-bluenco.appspot.com',
    measurementId: 'G-XQB6FE3Z74',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB62Fw5AAmaQMNs-d75VQVAZf3JIv8afFM',
    appId: '1:21784424587:android:ee848e76e268e13fbc648e',
    messagingSenderId: '21784424587',
    projectId: 'mosaic-bluenco',
    storageBucket: 'mosaic-bluenco.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3OfBITz4-ic1LGNvri0cXlLPe4pPDRaQ',
    appId: '1:21784424587:ios:6cc7eb6898fa5263bc648e',
    messagingSenderId: '21784424587',
    projectId: 'mosaic-bluenco',
    storageBucket: 'mosaic-bluenco.appspot.com',
    iosClientId: '21784424587-6grtdeai3ir21gd5m3ocg3obi2q21qdb.apps.googleusercontent.com',
    iosBundleId: 'com.bluenco.mosaicbluenco',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD3OfBITz4-ic1LGNvri0cXlLPe4pPDRaQ',
    appId: '1:21784424587:ios:cbc73152ebda6d81bc648e',
    messagingSenderId: '21784424587',
    projectId: 'mosaic-bluenco',
    storageBucket: 'mosaic-bluenco.appspot.com',
    iosClientId: '21784424587-pofios9qe6va8394qlhs0vpb6lell7de.apps.googleusercontent.com',
    iosBundleId: 'com.bluenco.mosaicbluenco.RunnerTests',
  );
}
