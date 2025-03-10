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
    apiKey: 'AIzaSyB7fsoW35YQKm4DpeK-unmlq15KhJ-MvjI',
    appId: '1:46344465241:web:e764ddb27cdc9f1af9ba48',
    messagingSenderId: '46344465241',
    projectId: 'dacnmusic',
    authDomain: 'dacnmusic.firebaseapp.com',
    storageBucket: 'dacnmusic.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8QGSINWKZstspI5fRQtJmOewPomctuGw',
    appId: '1:46344465241:android:37b8fd7f56c3894af9ba48',
    messagingSenderId: '46344465241',
    projectId: 'dacnmusic',
    storageBucket: 'dacnmusic.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDplqEl0-4QBX-nypMqF9kP4wSzGlm5flM',
    appId: '1:46344465241:ios:d06b2b15e10ae741f9ba48',
    messagingSenderId: '46344465241',
    projectId: 'dacnmusic',
    storageBucket: 'dacnmusic.appspot.com',
    iosBundleId: 'com.example.dacn',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDplqEl0-4QBX-nypMqF9kP4wSzGlm5flM',
    appId: '1:46344465241:ios:7c55e29e2db3f982f9ba48',
    messagingSenderId: '46344465241',
    projectId: 'dacnmusic',
    storageBucket: 'dacnmusic.appspot.com',
    iosBundleId: 'com.example.dacn.RunnerTests',
  );
}
