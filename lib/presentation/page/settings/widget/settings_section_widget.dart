import 'package:flutter/material.dart';

import '../../../extension/extension.dart';

class SettingsSectionWidget extends StatelessWidget {
  const SettingsSectionWidget({
    super.key,
    this.title,
    this.children = const [],
  });

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (title != null)
          Padding(
            padding: const .only(top: 28, bottom: 4),
            child: Text(title!, style: textTheme.headlineLarge),
          ),
        Wrap(runSpacing: 4, children: children),
      ],
    );
  }
}
