import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/component/router/router.dart';
import '../../../i18n/i18n.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../../widget/enhancement/enhancement.dart';
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
        title: context.t.settings.account,
        subtitle: context.t.settings.profileAndIntegrations,
        icon: Icons.person_outline_rounded,
        route: const AccountSettingsRoute(),
      ),
      SettingsMenuItem(
        title: context.t.interface.settingsTitle,
        subtitle: context.t.settings.interfaceDescription,
        icon: Icons.tune_rounded,
        route: const InterfaceSettingsRoute(),
      ),
      SettingsMenuItem(
        title: context.t.fonts.settingsTitle,
        subtitle: context.t.settings.fontsDescription,
        icon: Icons.text_fields_rounded,
        route: const FontsSettingsRoute(),
      ),
      SettingsMenuItem(
        title: context.t.feed.settingsTitle,
        subtitle: context.t.settings.feedDescription,
        icon: Icons.view_agenda_outlined,
        route: const FeedSettingsRoute(),
      ),
      SettingsMenuItem(
        title: context.t.tracker.publications,
        subtitle: context.t.settings.elementVisibility,
        icon: Icons.article_outlined,
        route: const PublicationSettingsRoute(),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: AppInsets.screenPaddingExtended,
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

    return FlabrCard(
      margin: .zero,
      padding: .zero,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 76),
        child: Padding(
          padding: const .symmetric(horizontal: 14.0, vertical: 12.0),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colors.accentPrimary.withValues(alpha: .12),
                  borderRadius: .circular(8),
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
                Icons.chevron_right_rounded,
                color: theme.colors.iconTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
