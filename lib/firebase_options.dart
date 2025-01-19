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
    apiKey: 'AIzaSyBx3NTx6D14FG3TyMy59v_un4K5Q4RmEu8',
    appId: '1:848661314767:web:422615085afa59b82a0bba',
    messagingSenderId: '848661314767',
    projectId: 'chatwoot-bf44e',
    authDomain: 'chatwoot-bf44e.firebaseapp.com',
    storageBucket: 'chatwoot-bf44e.firebasestorage.app',
    measurementId: 'G-LEVFV524CS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQ88572NiwkqbvzBwnVwHS8LIg9Iq53T0',
    appId: '1:848661314767:android:eb43d75b1734d8a72a0bba',
    messagingSenderId: '848661314767',
    projectId: 'chatwoot-bf44e',
    storageBucket: 'chatwoot-bf44e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxzOUj44inQ6jwsAF7HXmy_kLdcl4cTGk',
    appId: '1:848661314767:ios:f4aba5479357dd542a0bba',
    messagingSenderId: '848661314767',
    projectId: 'chatwoot-bf44e',
    storageBucket: 'chatwoot-bf44e.firebasestorage.app',
    iosBundleId: 'com.example.chatwoot',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBxzOUj44inQ6jwsAF7HXmy_kLdcl4cTGk',
    appId: '1:848661314767:ios:f4aba5479357dd542a0bba',
    messagingSenderId: '848661314767',
    projectId: 'chatwoot-bf44e',
    storageBucket: 'chatwoot-bf44e.firebasestorage.app',
    iosBundleId: 'com.example.chatwoot',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBx3NTx6D14FG3TyMy59v_un4K5Q4RmEu8',
    appId: '1:848661314767:web:5fcb9862a57703f22a0bba',
    messagingSenderId: '848661314767',
    projectId: 'chatwoot-bf44e',
    authDomain: 'chatwoot-bf44e.firebaseapp.com',
    storageBucket: 'chatwoot-bf44e.firebasestorage.app',
    measurementId: 'G-FTN8YNQBEM',
  );

}