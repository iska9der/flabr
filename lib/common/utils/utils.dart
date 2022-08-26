import 'package:flutter/material.dart';

import '../../component/router/app_router.dart';
import 'image_utils.dart';

class Utils {
  const Utils({required this.router});

  final AppRouter router;

  ImageUtils get image => ImageUtils();

  void showNotification({
    required BuildContext context,
    required Widget content,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: content),
    );
  }
}
