import 'package:flutter/material.dart';

import '../../../extension/context.dart';
import '../../../widget/enhancement/card.dart';

class SettingsCardWidget extends StatelessWidget {
  const SettingsCardWidget({
    super.key,
    this.title,
    this.subtitle,
    this.padding = const EdgeInsets.all(12),
    required this.child,
  });

  final String? title;
  final String? subtitle;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      margin: EdgeInsets.zero,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Text(
              title!,
              style: context.theme.textTheme.titleLarge!.copyWith(
                fontVariations: [const FontVariation.weight(400)],
              ),
            ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          child,
        ],
      ),
    );
  }
}
