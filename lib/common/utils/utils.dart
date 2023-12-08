import 'package:flutter/material.dart';

import 'image_utils_mixin.dart';

class Utils with ImageUtilsMixin {
  const Utils();

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
    Text? title,
    required Widget content,
    required List<Widget>? Function(BuildContext context) actionsBuilder,
    bool isDismissible = true,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: isDismissible,
      useSafeArea: true,
      useRootNavigator: true,
      builder: (alertContext) {
        final actions = actionsBuilder(alertContext);

        return PopScope(
          canPop: isDismissible,
          child: AlertDialog.adaptive(
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: title ?? const Text('Внимание')),
                if (isDismissible)
                  IconButton(
                    onPressed: () => Navigator.of(alertContext).pop(),
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            content: content,
            actions: actions,
          ),
        );
      },
    );
  }
}
