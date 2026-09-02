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
    this.radius,
  });

  final Color? color;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? radius;
  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cardTheme = context.cardTheme;
    final cardRadius = switch (cardTheme.shape) {
      _ when radius != null => radius!,
      RoundedRectangleBorder(:final borderRadius) => borderRadius.resolve(
        Directionality.of(context),
      ),
      _ => AppRadius.zero,
    };
    final cardMargin = margin ?? cardTheme.margin ?? const EdgeInsets.all(4.0);
    final cardPadding = padding ?? AppInsets.md;
    final cardElevation = elevation ?? cardTheme.elevation ?? 1.0;
    final cardColor = color ?? theme.colors.card;

    return Padding(
      padding: cardMargin,
      child: Material(
        elevation: cardElevation,
        color: cardColor,
        shadowColor: theme.colorScheme.shadow,
        surfaceTintColor: cardColor,
        borderRadius: cardRadius,
        clipBehavior: .hardEdge,
        child: InkWell(
          onTap: onTap,
          borderRadius: cardRadius,
          child: Padding(padding: cardPadding, child: child),
        ),
      ),
    );
  }
}
