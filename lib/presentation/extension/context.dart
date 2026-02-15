import 'package:flutter/material.dart';

import '../../core/component/router/router.dart';
import '../../di/di.dart';
import '../theme/theme.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  CardThemeData get cardTheme => CardTheme.of(this);

  void showSnack({
    required Widget content,
    SnackBarAction? action,
    Duration duration = const .new(seconds: 3),
  }) {
    final ctx = getIt<AppRouter>().navigatorKey.currentContext ?? this;
    final messenger = ScaffoldMessenger.of(ctx);
    final snackbar = SnackBar(
      content: content,
      action: action,
      duration: duration,
    );

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  Future<T?> showAlert<T>({
    Text? title,
    required Widget content,
    required List<Widget>? Function(BuildContext context)? actionsBuilder,
    bool isDismissible = true,
    bool compact = false,
  }) async {
    final ctx = getIt<AppRouter>().navigatorKey.currentContext ?? this;

    EdgeInsets? titlePadding;
    EdgeInsets? contentPadding;
    EdgeInsets? actionsPadding;

    if (compact) {
      titlePadding = const .fromLTRB(24, 12, 12, 12);
      contentPadding = const .fromLTRB(24, 0, 24, 12);
      actionsPadding = const .fromLTRB(0, 0, 12, 12);
    }

    return await showDialog<T>(
      context: ctx,
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
                    visualDensity: .compact,
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

extension ModalExtension on BuildContext {
  Future<T?> buildModalRoute<T>({
    bool rootNavigator = false,
    required Widget child,
  }) {
    Widget body = Center(
      child: BackdropFilter(
        filter: .blur(sigmaX: 6, sigmaY: 6),
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
