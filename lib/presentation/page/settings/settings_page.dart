import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../../widget/enhancement/enhancement.dart';
import 'account_settings_page.dart';
import 'feed_settings_page.dart';
import 'interface_settings_page.dart';
import 'publication_settings_page.dart';
import 'widget/settings_section_widget.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String routePath = 'settings';

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
      subtitle: 'Профиль, авторизация и YandexGPT',
      icon: Icons.person_outline_rounded,
      page: AccountSettingsView(),
    ),
    SettingsMenuItem(
      title: 'Интерфейс',
      subtitle: 'Тема, язык интерфейса и язык публикаций',
      icon: Icons.tune_rounded,
      page: InterfaceSettingsView(),
    ),
    SettingsMenuItem(
      title: 'Лента',
      subtitle: 'Карточки, заголовки, навигация и скролл',
      icon: Icons.view_agenda_outlined,
      page: FeedSettingsView(),
    ),
    SettingsMenuItem(
      title: 'Публикации',
      subtitle: 'Чтение статей, изображения и WebView',
      icon: Icons.article_outlined,
      page: PublicationSettingsView(),
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
                      onTap: () => _pushSettingsPage(context, item.page),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _pushSettingsPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => page,
      ),
    );
  }
}

class SettingsMenuItem {
  const SettingsMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;
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
      margin: const .symmetric(vertical: 4.0),
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
