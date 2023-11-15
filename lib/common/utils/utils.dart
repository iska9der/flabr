import 'package:flutter/material.dart';

import '../../component/router/app_router.dart';
import 'image_utils_mixin.dart';

class Utils with ImageUtilsMixin {
  const Utils({required this.router});

  final AppRouter router;

  void showSnack({
    required BuildContext context,
    required Widget content,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        action: action,
        duration: duration,
      ),
    );
  }

  Future showAlert({
    required BuildContext context,
    required Widget content,
    required List<Widget>? Function(BuildContext context) actions,
    bool isDismissible = true,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: isDismissible,
      useSafeArea: true,
      useRootNavigator: true,
      builder: (context) {
        final localActions = actions(context);

        return WillPopScope(
          onWillPop: () async => isDismissible,
          child: AlertDialog.adaptive(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Внимание'),
                if (isDismissible)
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            content: content,
            actions: localActions,
          ),
        );
      },
    );
  }
}
