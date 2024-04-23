import 'package:flutter/material.dart' show immutable;

typedef CloseLoadingScreen = bool Function();

typedef UpddateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpddateLoadingScreen update;

  const LoadingScreenController({
    required this.close,
    required this.update,
  });

  
}
