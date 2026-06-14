import 'package:flutter/material.dart';

import '../../../extension/extension.dart';

class SettingsSectionWidget extends StatelessWidget {
  const SettingsSectionWidget({
    super.key,
    this.title,
    this.titleTopPadding = 28,
    this.children = const [],
  });

  final String? title;
  final double titleTopPadding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (title != null)
          Padding(
            padding: .only(top: titleTopPadding, bottom: 4),
            child: Text(title!, style: textTheme.headlineLarge),
          ),
        Wrap(runSpacing: 4, children: children),
      ],
    );
  }
}
