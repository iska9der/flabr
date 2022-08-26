import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../component/router/app_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      lazyLoad: false,
      routes: const [
        ArticlesRoute(),
        NewsRoute(),
        ServicesRoute(),
        SettingsRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabsRouter.activeIndex,
          onTap: (i) {
            tabsRouter.setActiveIndex(i);

            /// todo: сделать так, чтобы при нажатию на таб, в котором
            /// мы уже находимся - выходила в корень
            /// upd: сделано ниже, но неуверенно

            /// если это статьи или новости
            /// то не нужно отлетать в корень,
            /// так как пользователь может находиться
            /// в процессе чтения статьи
            // if (i == 0 || i == 1) {
            //   return;
            // }

            // var rootOfIndex = tabsRouter.stackRouterOfIndex(i);
            // rootOfIndex?.popUntilRoot();
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
