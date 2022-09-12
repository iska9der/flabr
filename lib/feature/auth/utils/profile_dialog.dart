import 'package:flutter/material.dart';

Future showProfileDialog(BuildContext context, {required Widget child}) async {
  return await showDialog(
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width * .8,
          child: child,
        ),
      ),
    ),
  );
}
