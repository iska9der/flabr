import 'package:flutter/material.dart';

class SettingsSectionWidget extends StatelessWidget {
  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const paddingBetweenElements = 14.0;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 10),
          child: Text(
            title,
            style: textTheme.headlineMedium,
          ),
        ),
        ...children.map((child) {
          return Padding(
            padding: const EdgeInsets.only(bottom: paddingBetweenElements),
            child: child,
          );
        }),
      ],
    );
  }
}
