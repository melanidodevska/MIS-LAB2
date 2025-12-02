import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web not supported');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS not supported');
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBjGvNj794Jwjk1KxSWMLr7JE20z_J_C8I",
    appId: "1:228223911838:android:a19781b2b2c614b76db88f",
    messagingSenderId: '228223911838',
    projectId: 'mealapp-f1328',
    storageBucket: 'mealapp-f1328.firebasestorage.app',
  );
}