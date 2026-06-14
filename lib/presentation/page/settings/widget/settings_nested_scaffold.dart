import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import 'settings_section_widget.dart';

class SettingsNestedScaffold extends StatelessWidget {
  const SettingsNestedScaffold({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView(
          padding: AppInsets.screenPaddingExtended,
          children: children.indexed.map((entry) {
            final (index, child) = entry;

            if (index == 0 && child is SettingsSectionWidget) {
              return SettingsSectionWidget(
                title: child.title,
                titleTopPadding: 8,
                children: child.children,
              );
            }

            return child;
          }).toList(),
        ),
      ),
    );
  }
}
