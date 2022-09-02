import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../../component/router/app_router.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../../user/widget/nav_link_widget.dart';
import '../cubit/hub_cubit.dart';
import '../service/hub_service.dart';
import 'hub_detail_page.dart';

class HubDashboardPage extends StatelessWidget {
  const HubDashboardPage({
    Key? key,
    @PathParam() required this.alias,
  }) : super(key: key);

  final String alias;

  static const String routePath = 'hubs/:alias';
  static const String routeName = 'HubDashboardRoute';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey('hub-$alias-dashboard'),
      lazy: false,
      create: (c) => HubCubit(
        alias,
        service: getIt.get<HubService>(),
        langUI: context.read<SettingsCubit>().state.langUI,
        langArticles: context.read<SettingsCubit>().state.langArticles,
      ),
      child: const HubDashboardPageView(),
    );
  }
}

class HubDashboardPageView extends StatelessWidget {
  const HubDashboardPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HubDetailRoute(),
      ],
      builder: (context, child, animation) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
            title: BlocBuilder<HubCubit, HubState>(
              builder: (context, state) {
                return Text(state.profile.titleHtml);
              },
            ),
          ),
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                children: const [
                  NavLinkWidget(
                    title: HubDetailPage.name,
                    route: HubDetailPage.routePath,
                  ),
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