import 'package:flutter/material.dart';
import 'package:flutter_application_3/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_application_3/services/auth/bloc/auth_events.dart';
import 'package:flutter_application_3/services/auth/bloc/auth_state.dart';
import 'package:flutter_application_3/util/dialogs/error_dialog.dart';
import 'package:flutter_application_3/util/dialogs/password_reset_email_sent_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateForgotPassword) {
            if (state.hasSentEmail) {
              _controller.clear();
              showPasswordResetSentDialog(context);
            } else if (state.exception != null) {
              await showErrorDialog(context, 'We could not process your request. Please make sure you are a registered user.');
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Forgot Password',
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
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    )
                  ),
                  TextButton(
                    onPressed: () {
                      final email = _controller.text;
                      context.read<AuthBloc>().add(
                        AuthEventForgotPassword(email: email),
                      );
                    },
                    child: const Text('Send email'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                    },
                    child: const Text('Back to login'),
                  )
                ],
              ),
            ),
          )
        ));
  }
}
