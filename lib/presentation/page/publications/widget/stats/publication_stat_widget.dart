import 'package:flutter/material.dart';

import '../../../../extension/context.dart';
import '../../../../extension/theme.dart';

class PublicationStat extends StatelessWidget {
  const PublicationStat({
    super.key,
    required this.text,
    required this.icon,
    this.color,
  });

  final String text;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final actualColor = color ?? context.theme.colors.shady;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: actualColor),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: actualColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
