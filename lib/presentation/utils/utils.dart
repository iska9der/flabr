import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../theme/theme.dart';

part 'image_utils_mixin.dart';

@Singleton()
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
    required List<Widget>? Function(BuildContext context)? actionsBuilder,
    bool isDismissible = true,
    bool compact = false,
  }) async {
    EdgeInsets? titlePadding;
    EdgeInsets? contentPadding;
    EdgeInsets? actionsPadding;

    if (compact) {
      titlePadding = EdgeInsets.fromLTRB(24, 12, 12, 12);
      contentPadding = EdgeInsets.fromLTRB(24, 0, 24, 12);
      actionsPadding = EdgeInsets.fromLTRB(0, 0, 12, 12);
    }

    return await showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (alertContext) {
        final actions = actionsBuilder?.call(alertContext);

        return PopScope(
          canPop: isDismissible,
          child: AlertDialog(
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            titlePadding: titlePadding,
            contentPadding: contentPadding,
            actionsPadding: actionsPadding,
            title: Row(
              children: [
                Expanded(child: title ?? const Text('Внимание')),
                if (isDismissible)
                  IconButton(
                    onPressed: () => Navigator.of(alertContext).pop(),
                    visualDensity: VisualDensity.compact,
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
