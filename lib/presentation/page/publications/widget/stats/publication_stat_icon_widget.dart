import 'package:flutter/material.dart';

import '../../../../extension/extension.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/enhancement/enhancement.dart';

class PublicationStatIconButton extends StatelessWidget {
  const PublicationStatIconButton({
    super.key,
    this.icon,
    this.value = '',
    this.color,
    this.highlightColor,
    this.isHighlighted = false,
    this.isLoading = false,
    this.onTap,
  });

  final IconData? icon;
  final String value;
  final Color? color;
  final Color? highlightColor;
  final bool isHighlighted;
  final bool isLoading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    const iconSize = 18.0;

    final colorResolved = switch (isHighlighted) {
      true => highlightColor ?? theme.colors.accentPrimary,
      false => color ?? theme.colors.iconColor,
    };

    final iconResolved = switch (isLoading) {
      true => const SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircleIndicator.small(),
      ),
      false when icon != null => Icon(
        icon,
        size: iconSize,
        color: colorResolved,
      ),
      _ => null,
    };

    final paddingResolved = switch (onTap == null) {
      true => EdgeInsets.zero,
      false => AppInsets.iconPadding,
    };

    return Material(
      type: .transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppStyles.cardBorderRadius,
        child: Padding(
          padding: paddingResolved,
          child: Row(
            children: [
              ?iconResolved,
              if (value.isNotEmpty) ...[
                if (iconResolved != null) const SizedBox(width: 6),
                Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorResolved,
                    fontWeight: .w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
