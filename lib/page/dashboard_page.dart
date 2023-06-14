import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../component/router/app_router.dart';

@RoutePage(name: DashboardPage.routeName)
class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  static const String routeName = 'DashboardRoute';

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      lazyLoad: false,
      routes: const [
        MyArticlesRoute(),
        MyNewsRoute(),
        MyServicesRoute(),
        SettingsRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: (i) {
            /// при нажатию на таб, в котором
            /// мы уже находимся - выходим в корень
            if (tabsRouter.activeIndex == i) {
              var rootOfIndex = tabsRouter.stackRouterOfIndex(i);
              rootOfIndex?.popUntilRoot();
            } else {
              tabsRouter.setActiveIndex(i);
            }
          },
          destinations: const [
            NavigationDestination(
              label: 'Статьи',
              icon: Icon(Icons.article_outlined),
            ),
            NavigationDestination(
              label: 'Новости',
              icon: Icon(Icons.newspaper_outlined),
            ),
            NavigationDestination(
              label: 'Сервисы',
              icon: Icon(Icons.widgets_outlined),
            ),
            NavigationDestination(
              label: 'Настройки',
              icon: Icon(Icons.settings_outlined),
            ),
          ],
        );
      },
    );
  }
}
