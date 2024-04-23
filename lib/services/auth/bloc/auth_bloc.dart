import 'package:bloc/bloc.dart';
import 'package:flutter_application_3/services/auth/auth_provider.dart';
import 'package:flutter_application_3/services/auth/bloc/auth_events.dart';
import 'package:flutter_application_3/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
        isLoading: true,
        loadingText: 'Logging in...',
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(const AuthStateLoggedOut());
        if (!user.isEmailVerified) {
          emit(const AuthStateEmailNeedsVerification(
            exception: null,
            isLoading: false,
          ));
        } else {
          emit(AuthStateLoggedIn(user: user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateLoggedOut(isLoading: true));
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut());
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
    });
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut());
      } else if (user.isEmailVerified) {
        emit(AuthStateLoggedIn(user: user));
      } else {
        emit(const AuthStateEmailNeedsVerification());
      }
    });
    on<AuthEventSendEmailVerification>((event, emit) async {
      try {
        await provider.sendEmailVerification();
        emit(state);
      } on Exception catch (e) {
        emit(AuthStateEmailNeedsVerification(exception: e));
      }
    });
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        try {
          await provider.sendEmailVerification();
          emit(state);
        } on Exception catch (e) {
          emit(AuthStateEmailNeedsVerification(exception: e));
        }
        emit(const AuthStateEmailNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e));
      }
    });
    on<AuthEventShouldRegister>((event, emit) async {
      emit(const AuthStateRegistering());
    });
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword());
      final email = event.email;
      if (email == null) {
        return;
      }
      emit(const AuthStateForgotPassword(isLoading: true));
      try {
        await provider.sendPasswordReset(toEmail: email);
        emit(const AuthStateForgotPassword(hasSentEmail: true));
      } on Exception catch (e) {
        emit(AuthStateForgotPassword(exception: e));
      }
    });
  }
}
