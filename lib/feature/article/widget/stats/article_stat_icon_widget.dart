import 'package:flutter/material.dart';

import '../../../../common/widget/enhancement/progress_indicator.dart';
import '../../../../config/constants.dart';

class StatIconButton extends StatelessWidget {
  const StatIconButton({
    super.key,
    required this.icon,
    required this.text,
    this.padding,
    this.color,
    this.isHighlighted = false,
    this.isLoading = false,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool isHighlighted;
  final bool isLoading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    const iconSize = 18.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kBorderRadiusDefault),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(kScreenHPadding),
          child: Row(
            children: [
              isLoading
                  ? const SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: CircleIndicator.small(),
                    )
                  : Icon(
                      icon,
                      size: iconSize,
                      color: color?.withOpacity(isHighlighted ? 1 : .3) ??
                          Theme.of(context)
                              .iconTheme
                              .color
                              ?.withOpacity(isHighlighted ? 1 : .3),
                    ),
              const SizedBox(width: 6),
              Text(
                text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
