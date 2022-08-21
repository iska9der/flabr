import 'package:flutter/material.dart';

import '../../component/router/router.gr.dart';
import 'image_utils.dart';
import 'launch_utils.dart';

class Utils {
  const Utils({required this.router});

  final AppRouter router;

  ImageUtils get image => ImageUtils();
  LaunchUtils get launcher => LaunchUtils(router: router);

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
