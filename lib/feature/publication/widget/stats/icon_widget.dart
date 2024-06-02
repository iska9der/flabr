import 'package:flutter/material.dart';

import '../../../../common/widget/enhancement/progress_indicator.dart';
import '../../../../component/theme/theme_part.dart';

class StatIconButton extends StatelessWidget {
  const StatIconButton({
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
              if (value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
