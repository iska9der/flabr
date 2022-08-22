import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../component/router/router.gr.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !await AutoTabsRouter.of(context)
            .root
            .navigatorKey
            .currentState!
            .maybePop();
      },
      child: AutoTabsScaffold(
        routes: const [
          FlowsRoute(),
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
              print(tabsRouter.currentUrl);
              print(tabsRouter.current.path);
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
      ),
    );
  }
}
