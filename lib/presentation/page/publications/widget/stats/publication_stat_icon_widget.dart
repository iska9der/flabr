import 'package:flutter/material.dart';

import '../../../../extension/extension.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/enhancement/enhancement.dart';

class PublicationStatIconButton extends StatelessWidget {
  const PublicationStatIconButton({
    super.key,
    required this.icon,
    this.value = '',
    this.padding,
    this.color,
    this.isHighlighted = false,
    this.isLoading = false,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool isHighlighted;
  final bool isLoading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    const iconSize = 18.0;

    var iconColor = switch (color) {
      == null => theme.iconTheme.color,
      _ => color,
    };

    iconColor = iconColor?.withValues(alpha: isHighlighted ? .7 : .3);

    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppStyles.cardBorderRadius,
        child: Padding(
          padding: padding ?? AppInsets.screenPadding,
          child: Row(
            children: [
              isLoading
                  ? const SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircleIndicator.small(),
                  )
                  : Icon(icon, size: iconSize, color: iconColor),
              if (value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    value,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
