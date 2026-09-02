import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/component/router/router.dart';
import '../../../i18n/i18n.dart';
import '../../extension/extension.dart';
import '../../theme/constants.dart';
import '../../widget/enhancement/enhancement.dart';
import 'widget/settings_nested_scaffold.dart';
import 'widget/settings_section_widget.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String routePath = '';

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      SettingsMenuItem(
        title: context.t.settings.account.title,
        subtitle: context.t.settings.account.description,
        icon: Icons.person_outline_rounded,
        route: const AccountSettingsRoute(),
      ),
      SettingsMenuItem(
        title: context.t.settings.interface.title,
        subtitle: context.t.settings.interface.description,
        icon: Icons.tune_rounded,
        route: const InterfaceSettingsRoute(),
      ),
      SettingsMenuItem(
        title: context.t.settings.fonts.title,
        subtitle: context.t.settings.fonts.description,
        icon: Icons.text_fields_rounded,
        route: const FontsSettingsRoute(),
      ),
      SettingsMenuItem(
        title: context.t.settings.feed.title,
        subtitle: context.t.settings.feed.description,
        icon: Icons.view_agenda_outlined,
        route: const FeedSettingsRoute(),
      ),
      SettingsMenuItem(
        title: context.t.settings.publication.title,
        subtitle: context.t.settings.publication.visibility.title,
        icon: Icons.article_outlined,
        route: const PublicationSettingsRoute(),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SettingsNestedScaffold(
          title: context.t.settings.title,
          children: [
            SettingsSectionWidget(
              children: menuItems
                  .map(
                    (item) => SettingsMenuTile(
                      item: item,
                      onTap: () => context.router.push(item.route),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsMenuItem {
  const SettingsMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final PageRouteInfo route;
}

class SettingsMenuTile extends StatelessWidget {
  const SettingsMenuTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  final SettingsMenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 76),
      child: FlabrCard(
        margin: .zero,
        padding: const .symmetric(horizontal: 14.0, vertical: 12.0),
        radius: AppRadius.md,
        onTap: onTap,
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colors.accentPrimary.withValues(alpha: .12),
                borderRadius: AppRadius.md,
              ),
              child: SizedBox.square(
                dimension: 44,
                child: Icon(
                  item.icon,
                  color: theme.colors.accentPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,
                mainAxisSize: .min,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              AppIcons.chevronRight,
              color: theme.colors.iconTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
