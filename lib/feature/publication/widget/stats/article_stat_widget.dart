import 'package:flutter/material.dart';

class ArticleStat extends StatelessWidget {
  const ArticleStat({
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
    final actualColor = color ?? Colors.grey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: actualColor,
        ),
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
