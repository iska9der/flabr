import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  const AppError({
    super.key,
    this.message = 'Произошла ошибка',
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      mainAxisAlignment: .center,
      children: [
        Text(
          message,
          textAlign: .center,
        ),
        if (onRetry != null)
          FilledButton(
            onPressed: onRetry,
            child: const Text('Попробовать снова'),
          ),
      ],
    );
  }
}
