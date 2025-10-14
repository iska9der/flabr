import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/theme.dart';

extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  CardThemeData get cardTheme => CardTheme.of(this);

  void showSnack({
    required Widget content,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(this);
    final snackbar = SnackBar(
      content: content,
      action: action,
      duration: duration,
    );

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
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
      titlePadding = const EdgeInsets.fromLTRB(24, 12, 12, 12);
      contentPadding = const EdgeInsets.fromLTRB(24, 0, 24, 12);
      actionsPadding = const EdgeInsets.fromLTRB(0, 0, 12, 12);
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

extension ModalX on BuildContext {
  Future<T?> buildModalRoute<T>({
    bool rootNavigator = false,
    required Widget child,
  }) {
    Widget body = Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Device.getWidth(this) * .9,
            maxHeight: Device.getHeight(this) * .5,
          ),
          child: child,
        ),
      ),
    );

    return Navigator.of(this, rootNavigator: rootNavigator).push<T>(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (_, _, _) => body,
      ),
    );
  }
}
