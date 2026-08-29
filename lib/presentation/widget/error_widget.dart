import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';

class AppError extends StatelessWidget {
  const AppError({
    super.key,
    this.message,
    this.onRetry,
  });

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      mainAxisAlignment: .center,
      children: [
        Text(
          message ?? context.t.common.genericError,
          textAlign: .center,
        ),
        if (onRetry != null)
          FilledButton(
            onPressed: onRetry,
            child: Text(context.t.common.tryAgain),
          ),
      ],
    );
  }
}
