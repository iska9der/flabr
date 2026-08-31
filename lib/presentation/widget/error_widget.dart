import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../extension/error.dart';

class AppError extends StatelessWidget {
  const AppError({
    super.key,
    this.error,
    this.onRetry,
  });

  final Object? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      mainAxisAlignment: .center,
      children: [
        Text(
          context.t.errorMessage(error),
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
