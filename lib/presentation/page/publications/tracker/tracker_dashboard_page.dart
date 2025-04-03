import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/component/router/app_router.dart';
import '../../../theme/theme.dart';
import '../../../widget/dashboard_drawer_link_widget.dart';

@RoutePage()
class TrackerDashboardPage extends StatelessWidget {
  const TrackerDashboardPage({super.key});

  static const String routePath = '';

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
                    leading: const AutoLeadingButton(),
                    title: const Text('Трекер'),
                    toolbarHeight: AppDimensions.toolBarHeight,
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
                      toolbarHeight: AppDimensions.tabBarHeight,
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
                  ),
                ];
              },
              body: child,
            ),
          ),
        );
      },
    );
  }
}
