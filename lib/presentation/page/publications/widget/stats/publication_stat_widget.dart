import 'package:flutter/material.dart';

import '../../../../extension/context.dart';
import '../../../../extension/theme.dart';

class PublicationStat extends StatelessWidget {
  const PublicationStat({
    super.key,
    required this.text,
    this.textColor,
    required this.icon,
    this.iconColor,
  });

  final String text;
  final Color? textColor;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final iconColorResolved = iconColor ?? theme.colors.iconColor;
    final textColorResolved = textColor ?? theme.colors.iconTextColor;

    return Row(
      mainAxisSize: .min,
      spacing: 4,
      children: [
        Icon(icon, color: iconColorResolved),
        Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            color: textColorResolved,
            fontWeight: .w700,
          ),
        ),
      ],
    );
  }
}
