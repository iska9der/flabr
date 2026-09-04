import 'package:flutter/material.dart';

import '../extension/extension.dart';
import 'stat_text_widget.dart';

class ProfileStatCardWidget extends StatelessWidget {
  const ProfileStatCardWidget({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
  });

  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Padding(
      padding: const .symmetric(horizontal: 4, vertical: 2),
      child: Column(
        mainAxisSize: .min,
        children: [
          SizedBox(
            width: double.infinity,
            child: FittedBox(
              fit: .scaleDown,
              child: StatTextWidget(
                value: value,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: valueColor,
                  fontWeight: .w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            title,
            maxLines: 2,
            overflow: .ellipsis,
            textAlign: .center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
