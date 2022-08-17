import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../components/router/router.gr.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        ArticlesRoute(),
        NewsRoute(),
        SettingsRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: const [
            BottomNavigationBarItem(
              label: 'Статьи',
              icon: Icon(Icons.article_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Новости',
              icon: Icon(Icons.newspaper_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Настройки',
              icon: Icon(Icons.settings_outlined),
            ),
          ],
        );
      },
    );
  }
}
