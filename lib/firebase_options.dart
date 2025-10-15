import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY_WEB']!,
    appId: dotenv.env['FIREBASE_APP_ID_WEB']!,
    messagingSenderId: dotenv.env['FIREBASE_MSG_SENDER_ID_WEB']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN']!,
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
    measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'],
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY_ANDROID']!,
    appId: dotenv.env['FIREBASE_APP_ID_ANDROID']!,
    messagingSenderId: dotenv.env['FIREBASE_MSG_SENDER_ID_ANDROID']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY_IOS']!,
    appId: dotenv.env['FIREBASE_APP_ID_IOS']!,
    messagingSenderId: dotenv.env['FIREBASE_MSG_SENDER_ID_IOS']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
    iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID']!,
  );

  static FirebaseOptions get windows => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY_WINDOWS']!,
    appId: dotenv.env['FIREBASE_APP_ID_WINDOWS']!,
    messagingSenderId: dotenv.env['FIREBASE_MSG_SENDER_ID_WINDOWS']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
  );
}
