import 'package:flutter/material.dart';
import 'package:flutter_application_3/util/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note.',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
