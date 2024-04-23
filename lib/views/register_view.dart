import 'package:flutter/material.dart';
import 'package:flutter_application_3/services/auth/auth_exceptions.dart';
import 'package:flutter_application_3/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_application_3/services/auth/bloc/auth_events.dart';
import 'package:flutter_application_3/services/auth/bloc/auth_state.dart';
import 'package:flutter_application_3/util/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              'The password provided is too weak.',
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              'An account already exists for that email.',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              'The email provided is not valid.',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Registration error.',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    decoration: const InputDecoration(hintText: 'Email')),
                TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    autofocus: true,
                    controller: _password,
                    decoration: const InputDecoration(hintText: 'Password')),
                TextButton(
                  onPressed: () {
                    final email = _email.text;
                    final password = _password.text;
                    context.read<AuthBloc>().add(
                          AuthEventRegister(email, password),
                        );
                  },
                  child: const Text('Register'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
                  },
                  child: const Text('Already have an account? Login here!'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
