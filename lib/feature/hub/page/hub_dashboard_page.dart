import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../../component/router/app_router.dart';
import '../../../widget/dashboard_drawer_link_widget.dart';
import '../../enhancement/scaffold/cubit/scaffold_cubit.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/hub_cubit.dart';
import '../repository/hub_repository.dart';
import 'hub_detail_page.dart';

@RoutePage(name: HubDashboardPage.routeName)
class HubDashboardPage extends StatelessWidget {
  const HubDashboardPage({
    super.key,
    @PathParam() required this.alias,
  });

  final String alias;

  static const String routePath = 'hubs/:alias';
  static const String routeName = 'HubDashboardRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          key: ValueKey('hub-$alias-dashboard'),
          lazy: false,
          create: (c) => HubCubit(
            alias,
            repository: getIt.get<HubRepository>(),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => ScaffoldCubit(),
        ),
      ],
      child: const HubDashboardPageView(),
    );
  }
}

class HubDashboardPageView extends StatelessWidget {
  const HubDashboardPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HubDetailRoute(),
      ],
      builder: (context, child) {
        return Scaffold(
          key: context.read<ScaffoldCubit>().key,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
            title: BlocBuilder<HubCubit, HubState>(
              builder: (context, state) {
                return Text(state.profile.titleHtml);
              },
            ),
          ),
          drawer: const NavigationDrawer(
            children: [
              DashboardDrawerLinkWidget(
                title: HubDetailPage.name,
                route: HubDetailPage.routePath,
              ),
            ],
          ),
          body: SafeArea(child: child),
        );
      },
    );
  }
}
