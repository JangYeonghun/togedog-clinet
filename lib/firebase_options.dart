// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC89VoX7w0kn5mgIFVkbpXYa6pbr8L4bFo',
    appId: '1:557224160415:web:f06a5c3739e026692306aa',
    messagingSenderId: '557224160415',
    projectId: 'togedog-cf1ca',
    authDomain: 'togedog-cf1ca.firebaseapp.com',
    storageBucket: 'togedog-cf1ca.appspot.com',
    measurementId: 'G-3KFSE4B3FN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAcS7LXtjRKX6-DEe70E7FYV4iC0cRM80s',
    appId: '1:557224160415:android:9d5d01e418d9bf722306aa',
    messagingSenderId: '557224160415',
    projectId: 'togedog-cf1ca',
    storageBucket: 'togedog-cf1ca.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDmnQ07wlemRUTEWEJ8ZbP2pUVcPJldmV8',
    appId: '1:557224160415:ios:3a522e5057dd19852306aa',
    messagingSenderId: '557224160415',
    projectId: 'togedog-cf1ca',
    storageBucket: 'togedog-cf1ca.appspot.com',
    iosBundleId: 'com.togedog.life',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDmnQ07wlemRUTEWEJ8ZbP2pUVcPJldmV8',
    appId: '1:557224160415:ios:3a522e5057dd19852306aa',
    messagingSenderId: '557224160415',
    projectId: 'togedog-cf1ca',
    storageBucket: 'togedog-cf1ca.appspot.com',
    iosBundleId: 'com.togedog.life',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC89VoX7w0kn5mgIFVkbpXYa6pbr8L4bFo',
    appId: '1:557224160415:web:e7bf1b0b31fefb6a2306aa',
    messagingSenderId: '557224160415',
    projectId: 'togedog-cf1ca',
    authDomain: 'togedog-cf1ca.firebaseapp.com',
    storageBucket: 'togedog-cf1ca.appspot.com',
    measurementId: 'G-MWS1BZW9E6',
  );
}