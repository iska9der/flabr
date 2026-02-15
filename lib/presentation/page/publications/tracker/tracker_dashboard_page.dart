import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/component/router/router.dart';
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
          appBar: AppBar(
            leading: const AutoLeadingButton(),
            title: const Text('Трекер'),
            toolbarHeight: AppDimensions.toolBarHeight,
            bottom: PreferredSize(
              preferredSize: const .fromHeight(AppDimensions.tabBarHeight),
              child: TabBar(
                controller: controller,
                isScrollable: true,
                padding: .zero,
                labelPadding: const .symmetric(horizontal: 12),
                dividerColor: Colors.transparent,
                tabs: const [
                  DashboardDrawerLinkWidget(title: 'Публикации'),
                  DashboardDrawerLinkWidget(title: 'Подписки'),
                  // DashboardDrawerLinkWidget(title: 'Уведомления'),
                ],
              ),
            ),
          ),
          body: SafeArea(child: child),
        );
      },
    );
  }
}
