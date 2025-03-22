import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  void showSnack({
    required Widget content,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: content, action: action, duration: duration),
    );
  }

  Future showAlert({
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
      context: this,
      barrierDismissible: isDismissible,
      builder: (alertContext) {
        final actions = actionsBuilder?.call(alertContext);

        return PopScope(
          canPop: isDismissible,
          child: AlertDialog(
            titleTextStyle: theme.textTheme.titleLarge,
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
