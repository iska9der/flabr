import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class FlabrCard extends StatelessWidget {
  const FlabrCard({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.elevation,
    this.margin,
    this.padding = AppInsets.cardPadding,
  });

  final Color? color;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation,
      margin: margin,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
