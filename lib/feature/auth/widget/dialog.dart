import 'package:flutter/material.dart';

import 'login_widget.dart';
import 'profile_widget.dart';

Future showProfileDialog(
  BuildContext context, {
  required DialogUserWidget child,
}) async {
  return await showDialog(
    context: context,
    builder: (context) => Padding(
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
  return await showProfileDialog(
    context,
    child: const LoginWidget(),
  );
}
