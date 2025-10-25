import 'package:flutter/material.dart';

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
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(top: 28, bottom: 4),
            child: Text(title!, style: textTheme.headlineLarge),
          ),
        Wrap(runSpacing: 4, children: children),
      ],
    );
  }
}
