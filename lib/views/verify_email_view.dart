import 'package:flutter/material.dart';
import 'package:flutter_application_3/services/auth/auth_exceptions.dart';
import 'package:flutter_application_3/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_application_3/services/auth/bloc/auth_events.dart';
import 'package:flutter_application_3/services/auth/bloc/auth_state.dart';
import 'package:flutter_application_3/util/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateEmailNeedsVerification &&
            state.exception is TooManyRequestsAuthException) {
          showErrorDialog(context, 'Too many requests');
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Verify email',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "We've sent you an email verification. Please open it to verify your account."),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventSendEmailVerification(),
                          );
                    },
                    child: const Text('Resend email verification'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    },
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
