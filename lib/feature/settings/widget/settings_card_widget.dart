import 'package:flutter/material.dart';

import '../../../widget/card_widget.dart';

class SettingsCardWidget extends StatelessWidget {
  const SettingsCardWidget({
    super.key,
    this.title,
    this.subtitle,
    this.padding = const EdgeInsets.all(20),
    required this.child,
  });

  final String? title;
  final String? subtitle;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) Text(title!),
            if (subtitle != null)
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        FlabrCard(
          padding: padding,
          child: child,
        ),
      ],
    );
  }
}
