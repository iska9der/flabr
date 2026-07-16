import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/component/router/router.dart';
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

  static const _menuItems = [
    SettingsMenuItem(
      title: 'Аккаунт',
      subtitle: 'Профиль и интеграции',
      icon: Icons.person_outline_rounded,
      route: AccountSettingsRoute(),
    ),
    SettingsMenuItem(
      title: 'Интерфейс',
      subtitle: 'Внешний вид, скролл и языки',
      icon: Icons.tune_rounded,
      route: InterfaceSettingsRoute(),
    ),
    SettingsMenuItem(
      title: 'Шрифты',
      subtitle: 'Масштаб и типографика публикаций',
      icon: Icons.text_fields_rounded,
      route: FontsSettingsRoute(),
    ),
    SettingsMenuItem(
      title: 'Лента',
      subtitle: 'Карточки и навигация',
      icon: Icons.view_agenda_outlined,
      route: FeedSettingsRoute(),
    ),
    SettingsMenuItem(
      title: 'Публикации',
      subtitle: 'Видимость элементов',
      icon: Icons.article_outlined,
      route: PublicationSettingsRoute(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: AppInsets.screenPaddingExtended,
          children: [
            SettingsSectionWidget(
              children: _menuItems
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
