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
    apiKey: 'AIzaSyB2LQ7F6-U5QK00Sn7B0tg_KdjSMnY2ACY',
    appId: '1:568623377007:web:96b514a987331de5c23b9a',
    messagingSenderId: '568623377007',
    projectId: 'notes-de434',
    authDomain: 'notes-de434.firebaseapp.com',
    storageBucket: 'notes-de434.appspot.com',
    measurementId: 'G-SF78G0PPV9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDALY_n4D2hFLZywCNyCVG6ik1YN1tOkuY',
    appId: '1:568623377007:android:b1db8f1763bfc4a6c23b9a',
    messagingSenderId: '568623377007',
    projectId: 'notes-de434',
    storageBucket: 'notes-de434.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDRxh5Ha_qJf-9GgToAI9qOFi-F9ABCr0',
    appId: '1:568623377007:ios:5ee268d968327f0cc23b9a',
    messagingSenderId: '568623377007',
    projectId: 'notes-de434',
    storageBucket: 'notes-de434.appspot.com',
    iosBundleId: 'com.example.notes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCDRxh5Ha_qJf-9GgToAI9qOFi-F9ABCr0',
    appId: '1:568623377007:ios:5ee268d968327f0cc23b9a',
    messagingSenderId: '568623377007',
    projectId: 'notes-de434',
    storageBucket: 'notes-de434.appspot.com',
    iosBundleId: 'com.example.notes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB2LQ7F6-U5QK00Sn7B0tg_KdjSMnY2ACY',
    appId: '1:568623377007:web:2bc956d871f5e7a0c23b9a',
    messagingSenderId: '568623377007',
    projectId: 'notes-de434',
    authDomain: 'notes-de434.firebaseapp.com',
    storageBucket: 'notes-de434.appspot.com',
    measurementId: 'G-MRVJYRJCXM',
  );
}
