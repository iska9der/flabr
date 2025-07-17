import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../presentation/extension/extension.dart';
import '../../../presentation/theme/theme.dart';
import 'connect_sid_widget.dart';
import 'login_webview.dart';
import 'profile_widget.dart';

Future showProfileDialog(
  BuildContext context, {
  required DialogUserWidget child,
}) async {
  return await showDialog(
    context: context,
    builder:
        (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Center(
            child: SizedBox(
              width: Device.getWidth(context) * .8,
              child: child,
            ),
          ),
        ),
  );
}

void showLoginSnackBar(BuildContext context) async {
  return context.showSnack(
    content: const Text('Необходимо войти в аккаунт'),
    action: SnackBarAction(
      label: 'Вход',
      onPressed: () => showLoginDialog(context),
    ),
  );
}

Future showLoginDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder:
        (context) => AlertDialog.adaptive(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Авторизация'),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          content:
              /// в вебе не работает webview_flutter
              kIsWeb
                  ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                    child: ConnectSidWidget(),
                  )
                  : SizedBox(
                    width: Device.getWidth(context),
                    child: const LoginWebView(),
                  ),
        ),
  );
}
