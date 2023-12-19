import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/widget/dashboard_drawer_link_widget.dart';
import '../../../component/router/app_router.dart';
import '../../../component/theme/constants.dart';

@RoutePage(name: PublicationDashboardPage.routeName)
class PublicationDashboardPage extends StatefulWidget {
  const PublicationDashboardPage({super.key});

  static const String routePath = '';
  static const String routeName = 'PublicationsDashboardRoute';

  @override
  State<PublicationDashboardPage> createState() =>
      _PublicationDashboardPageState();
}

class _PublicationDashboardPageState extends State<PublicationDashboardPage> {
  final _listRouteNames = const [
    ArticleListRoute.name,
    NewsListRoute.name,
    PostListRoute.name,
  ];

  final ValueNotifier<bool> hideTabs = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [
        ArticlesRouter(),
        PostsRouter(),
        NewsRouter(),
      ],
      builder: (context, child, controller) {
        final currentName = AutoRouter.of(context).topMatch.name;

        hideTabs.value = _listRouteNames.any((name) => name == currentName);

        return Column(
          children: [
            AnimatedBuilder(
              animation: hideTabs,
              builder: (context, child) {
                return AnimatedContainer(
                  height: hideTabs.value ? fDashboardTabHeight : 0,
                  duration: const Duration(milliseconds: 200),
                  child: child,
                );
              },
              child: ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    controller: controller,
                    isScrollable: true,
                    padding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      DashboardDrawerLinkWidget(
                        title: 'Статьи',
                        route: 'articles',
                      ),
                      DashboardDrawerLinkWidget(
                        title: 'Посты',
                        route: 'posts',
                      ),
                      DashboardDrawerLinkWidget(
                        title: 'Новости',
                        route: 'news',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
