import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:flutter_application_3/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String loadingText;
  const AuthState({
    this.isLoading = false,
    this.loadingText = 'Loading...',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({super.isLoading});
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    this.exception,
    super.isLoading,
  });
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, super.isLoading});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({this.exception, super.isLoading, super.loadingText});

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateEmailNeedsVerification extends AuthState {
  final Exception? exception;
  const AuthStateEmailNeedsVerification({this.exception, super.isLoading});
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({
    this.exception,
    this.hasSentEmail = false,
    super.isLoading,
  });
}