import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Provides authentication services for the app using Firebase Auth.
///
/// This service initializes with a specific [FirebaseApp] instance and offers
/// methods for user authentication.
class AuthService {
  AuthService({required FirebaseApp app, FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instanceFor(app: app);

  final FirebaseAuth _auth;

  Future<void> signInAnonymously() async {
    final UserCredential credential = await _auth.signInAnonymously();
    if (kDebugMode) {
      log('User signed in anonymously: ${credential.user!.uid}');
    }
  }
}
