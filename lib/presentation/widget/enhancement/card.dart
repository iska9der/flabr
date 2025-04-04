import 'package:flutter/material.dart';

import '../../extension/extension.dart';
import '../../theme/theme.dart';

class FlabrCard extends StatelessWidget {
  const FlabrCard({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.elevation,
    this.margin,
    this.padding,
  });

  final Color? color;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cardTheme = theme.cardTheme;
    final cardMargin = margin ?? cardTheme.margin ?? const EdgeInsets.all(4.0);
    final cardPadding = padding ?? AppInsets.cardPadding;
    final cardElevation = elevation ?? cardTheme.elevation ?? 1.0;
    final cardColor = color ?? theme.colors.card;

    return Padding(
      padding: cardMargin,
      child: Material(
        elevation: cardElevation,
        color: cardColor,
        shadowColor: theme.colorScheme.shadow,
        surfaceTintColor: cardColor,
        shape: cardTheme.shape,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: cardPadding, child: child),
        ),
      ),
    );
  }
}
