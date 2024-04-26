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
    apiKey: 'AIzaSyDlvXFncK1Jj8Cl9iu9DfsAIinmuoT5A2g',
    appId: '1:843758602441:web:0065889f4097e57bc2e518',
    messagingSenderId: '843758602441',
    projectId: 'taskmanager-d0cb3',
    authDomain: 'taskmanager-d0cb3.firebaseapp.com',
    storageBucket: 'taskmanager-d0cb3.appspot.com',
    measurementId: 'G-7PYE8WEEK5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKF-jisSAzPYT8wOPw5_hLdQ3RWNQolw4',
    appId: '1:843758602441:android:18235a4313996503c2e518',
    messagingSenderId: '843758602441',
    projectId: 'taskmanager-d0cb3',
    storageBucket: 'taskmanager-d0cb3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeVHkwQarwJJkmlM8gVLrepqKtUSmgRfM',
    appId: '1:843758602441:ios:6e134e5026569840c2e518',
    messagingSenderId: '843758602441',
    projectId: 'taskmanager-d0cb3',
    storageBucket: 'taskmanager-d0cb3.appspot.com',
    iosBundleId: 'com.example.taskmanager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDeVHkwQarwJJkmlM8gVLrepqKtUSmgRfM',
    appId: '1:843758602441:ios:6e134e5026569840c2e518',
    messagingSenderId: '843758602441',
    projectId: 'taskmanager-d0cb3',
    storageBucket: 'taskmanager-d0cb3.appspot.com',
    iosBundleId: 'com.example.taskmanager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDlvXFncK1Jj8Cl9iu9DfsAIinmuoT5A2g',
    appId: '1:843758602441:web:03ce2c33e21da525c2e518',
    messagingSenderId: '843758602441',
    projectId: 'taskmanager-d0cb3',
    authDomain: 'taskmanager-d0cb3.firebaseapp.com',
    storageBucket: 'taskmanager-d0cb3.appspot.com',
    measurementId: 'G-MY4FVNTG2P',
  );
}