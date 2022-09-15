import 'package:flutter/material.dart';

class FlabrCard extends StatelessWidget {
  const FlabrCard({
    Key? key,
    required this.child,
    this.onTap,
    this.elevation,
    this.margin,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  /// если не указано, берется из темы
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
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
