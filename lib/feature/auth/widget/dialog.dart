import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'connect_sid_widget.dart';
import 'login_widget.dart';
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
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: child,
            ),
          ),
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
                  ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                    child: ConnectSidWidget(),
                  )
                  : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const LoginWidget(),
                  ),
        ),
  );
}
