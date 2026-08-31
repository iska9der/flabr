import 'package:flutter/material.dart';

import '../../extension/extension.dart';
import '../../theme/theme.dart';

class AppActionTile extends StatelessWidget {
  const AppActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onPressed,
    this.trailing,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onPressed;
  final Widget? trailing;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final foregroundColor = destructive && onPressed != null
        ? theme.colorScheme.error
        : null;

    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: AppStyles.buttonBorderRadius,
      ),
      clipBehavior: .antiAlias,
      child: ListTile(
        enabled: onPressed != null,
        onTap: onPressed,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppStyles.buttonBorderRadius,
        ),
        leading: Icon(icon),
        title: Text(
          title,
          key: ValueKey(('title', title)),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                key: ValueKey(('subtitle', subtitle)),
              ),
        trailing: trailing == null
            ? null
            : SizedBox.square(
                dimension: 24,
                child: trailing,
              ),
        iconColor: foregroundColor,
        textColor: foregroundColor,
      ),
    );
  }
}
