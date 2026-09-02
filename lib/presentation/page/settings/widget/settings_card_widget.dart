import 'package:flutter/material.dart';

import '../../../extension/context.dart';
import '../../../extension/theme.dart';
import '../../../theme/theme.dart';

class SettingsCardWidget extends StatelessWidget {
  const SettingsCardWidget({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.actions = const [],
    this.padding = const .all(16),
    required this.child,
  });

  final String? title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> actions;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final hasHeader = title != null || subtitle != null || icon != null;

    return Material(
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.xxl,
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: .55),
        ),
      ),
      clipBehavior: .antiAlias,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          children: [
            if (hasHeader || actions.isNotEmpty)
              Row(
                children: [
                  if (icon != null) ...[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: AppRadius.md,
                      ),
                      child: SizedBox.square(
                        dimension: 44,
                        child: Icon(
                          icon,
                          color: colorScheme.onPrimaryContainer,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisSize: .min,
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: .w600,
                            ),
                          ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  ...actions,
                ],
              ),
            if (hasHeader || actions.isNotEmpty) const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
