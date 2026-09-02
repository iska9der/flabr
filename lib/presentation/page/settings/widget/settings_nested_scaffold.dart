import 'package:flutter/material.dart';

import '../../../extension/extension.dart';
import '../../../theme/theme.dart';

class SettingsNestedScaffold extends StatelessWidget {
  const SettingsNestedScaffold({
    super.key,
    required this.title,
    this.description,
    required this.children,
  });

  final String title;
  final String? description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(title),
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
          ),
          if (description != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const .fromLTRB(20, 12, 20, 4),
                child: Text(
                  description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: AppInsets.screenExtended.copyWith(
                left: 16,
                top: 8,
                right: 16,
              ),
              sliver: SliverList.list(children: children),
            ),
          ),
        ],
      ),
    );
  }
}
