import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../i18n/i18n.dart';
import '../../theme/theme.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({super.key, required this.router});

  final TabsRouter router;

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: false,
      visibleConditions: const [
        .largerThan(name: ScreenType.mobile, value: true),
      ],
      child: _Drawer(router: router),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({required this.router});

  final TabsRouter router;

  @override
  Widget build(BuildContext context) {
    const EdgeInsets padding = .symmetric(vertical: 10);

    return NavigationRail(
      elevation: 5,
      labelType: .all,
      selectedIndex: router.activeIndex,
      onDestinationSelected: (i) {
        /// при нажатию на таб, в котором
        /// мы уже находимся - выходим в корень
        if (router.activeIndex == i) {
          var rootOfIndex = router.stackRouterOfIndex(i);
          rootOfIndex?.popUntilRoot();
        } else {
          router.setActiveIndex(i);
        }
      },
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.article_rounded),
          label: Text(context.t.navigation.publications),
          padding: padding,
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.widgets_rounded),
          label: Text(context.t.navigation.services),
          padding: padding,
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.settings_rounded),
          label: Text(context.t.navigation.settings),
          padding: padding,
        ),
      ],
    );
  }
}
