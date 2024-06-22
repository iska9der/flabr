import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/component/router/app_router.dart';
import '../../../theme/part.dart';
import '../../../widget/dashboard_drawer_link_widget.dart';

@RoutePage(name: TrackerDashboardPage.routeName)
class TrackerDashboardPage extends StatelessWidget {
  const TrackerDashboardPage({super.key});

  static const String routePath = '/tracker';
  static const String routeName = 'TrackerDashboardRoute';

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
        routes: const [
          TrackerPublicationsRoute(),
          TrackerSubscriptionRoute(),
          // TrackerSystemRoute(),
        ],
        builder: (context, child, controller) {
          return Scaffold(
            body: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      snap: true,
                      floating: true,
                      pinned: true,
                      title: const Text('Трекер'),
                      toolbarHeight: fToolBarHeight,
                      actions: const [
                        /// TODO блок для отметки раздела как прочитанный
                        /// Нужно отмечать прочитанным тот раздел, в котором
                        /// находится пользователь
                        // IconButton(
                        //   icon: const Icon(Icons.check_outlined),
                        //   tooltip: 'Отметить раздел прочитанным',
                        //   onPressed: () {
                        //   },
                        // ),
                      ],
                      bottom: AppBar(
                        automaticallyImplyLeading: false,
                        titleSpacing: 0,
                        toolbarHeight: fDashboardTabHeight,
                        title: TabBar(
                          controller: controller,
                          isScrollable: true,
                          padding: EdgeInsets.zero,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          dividerColor: Colors.transparent,
                          tabs: const [
                            DashboardDrawerLinkWidget(title: 'Публикации'),
                            DashboardDrawerLinkWidget(title: 'Подписки'),
                            // DashboardDrawerLinkWidget(title: 'Уведомления'),
                          ],
                        ),
                      ),
                    )
                  ];
                },
                body: child,
              ),
            ),
          );
        });
  }
}
