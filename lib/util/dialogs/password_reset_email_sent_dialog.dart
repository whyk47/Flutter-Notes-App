import 'package:flutter/material.dart';
import 'package:flutter_application_3/util/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password reset',
    content:
        'We have sent you a password reset link. Please check your email.',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}