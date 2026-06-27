import 'package:flutter/material.dart';

import '../../../extension/context.dart';
import '../../../widget/enhancement/card.dart';

class SettingsCardWidget extends StatelessWidget {
  const SettingsCardWidget({
    super.key,
    this.title,
    this.subtitle,
    this.actions = const [],
    this.padding = const .all(12),
    required this.child,
  });

  final String? title;
  final String? subtitle;
  final List<Widget> actions;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final needFirstRow = title != null || actions.isNotEmpty;

    return FlabrCard(
      margin: .zero,
      padding: padding,
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          if (needFirstRow)
            Row(
              children: [
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: .w400,
                      ),
                    ),
                  )
                else
                  const Spacer(),
                ...actions,
              ],
            ),
          if (subtitle != null)
            Text(subtitle!, style: theme.textTheme.bodyMedium),
          child,
        ],
      ),
    );
  }
}
