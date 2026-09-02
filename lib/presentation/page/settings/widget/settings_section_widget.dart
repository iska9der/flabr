import 'package:flutter/material.dart';

import '../../../extension/extension.dart';

class SettingsSectionWidget extends StatelessWidget {
  const SettingsSectionWidget({
    super.key,
    this.title,
    this.titleTopPadding = 32,
    this.children = const [],
  });

  final String? title;
  final double titleTopPadding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (title != null)
          Padding(
            padding: .only(
              left: 4,
              top: titleTopPadding,
              bottom: 12,
            ),
            child: Text(
              title!,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: .w600,
                letterSpacing: .2,
              ),
            ),
          ),
        Column(spacing: 12, children: children),
      ],
    );
  }
}
