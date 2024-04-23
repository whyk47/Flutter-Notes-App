import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String email;
  final String id;
  const AuthUser({
    required this.isEmailVerified,
    required this.email,
    required this.id,
  });
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        isEmailVerified: user.emailVerified,
        email: user.email!,
      );
}
