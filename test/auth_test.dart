import 'package:flutter_application_3/services/auth/auth_exceptions.dart';
import 'package:flutter_application_3/services/auth/auth_provider.dart';
import 'package:flutter_application_3/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isIntialised, false);
    });

    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotinitializedException>()),
      );
    });

    test('Should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isIntialised, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: '123456',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser = provider.createUser(
        email: 'abc@def.com',
        password: 'foobar',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<InvalidCredentialsAuthException>()));
      final user = await provider.createUser(
        email: 'abc@def.com',
        password: '123456',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'abc@def.com',
        password: '123456',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotinitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isinitialized = false;
  bool get isIntialised => _isinitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isIntialised) throw NotinitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isinitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isIntialised) throw NotinitializedException();
    if (email == 'foo@bar.com') {
      throw UserNotFoundAuthException();
    }
    if (password == 'foobar') {
      throw InvalidCredentialsAuthException();
    }
    const user = AuthUser(
      id: 'id',
      isEmailVerified: false,
      email: 'abc@def.com',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isIntialised) throw NotinitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isIntialised) throw NotinitializedException();
    final user = currentUser;
    if (user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = const AuthUser(
      id: 'id',
      isEmailVerified: true,
      email: 'abc@def.com',
    );
  }
  
  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    // TODO: implement sendPasswordReset
    throw UnimplementedError();
  }
}
