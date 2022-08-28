import 'package:flutter/material.dart';

import '../../component/router/app_router.dart';
import 'image_utils_mixin.dart';

class Utils with ImageUtilsMixin {
  const Utils({required this.router});

  final AppRouter router;

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
