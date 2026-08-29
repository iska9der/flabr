import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/component/router/router.dart';
import '../../../../i18n/i18n.dart';
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
            title: Text(context.t.tracker.title),
            toolbarHeight: AppDimensions.toolBarHeight,
            bottom: PreferredSize(
              preferredSize: const .fromHeight(AppDimensions.tabBarHeight),
              child: TabBar(
                controller: controller,
                isScrollable: true,
                padding: .zero,
                labelPadding: const .symmetric(horizontal: 12),
                dividerColor: Colors.transparent,
                tabs: [
                  DashboardDrawerLinkWidget(
                    title: context.t.tracker.publications,
                  ),
                  DashboardDrawerLinkWidget(
                    title: context.t.tracker.subscriptions,
                  ),
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
