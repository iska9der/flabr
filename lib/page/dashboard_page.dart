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
      routes:  const [
        MyArticlesRoute(),
        MyNewsRoute(),
        MyServicesRoute(),
        SettingsRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabsRouter.activeIndex,
          onTap: (i) {
            /// при нажатию на таб, в котором
            /// мы уже находимся - выходим в корень
            if (tabsRouter.activeIndex == i) {
              var rootOfIndex = tabsRouter.stackRouterOfIndex(i);
              rootOfIndex?.popUntilRoot();
            } else {
              tabsRouter.setActiveIndex(i);
            }
          },
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
              label: 'Сервисы',
              icon: Icon(Icons.widgets_outlined),
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
