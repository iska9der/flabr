import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/dashboard_drawer_link_widget.dart';
import '../../../component/di/injector.dart';
import '../../../component/router/app_router.dart';
import '../../../component/theme.dart';
import '../../enhancement/scaffold/cubit/scaffold_cubit.dart';
import '../../settings/repository/language_repository.dart';
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
          create: (_) => HubCubit(
            alias,
            repository: getIt.get<HubRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => ScaffoldCubit(),
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
    return AutoTabsRouter.tabBar(
      routes: const [
        HubDetailRoute(),
      ],
      builder: (context, child, controller) {
        return Scaffold(
          key: context.read<ScaffoldCubit>().key,
          appBar: AppBar(
            title: BlocBuilder<HubCubit, HubState>(
              builder: (context, state) {
                return Text(state.profile.titleHtml);
              },
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(fDashboardTabHeight),
              child: SizedBox(
                height: fDashboardTabHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    controller: controller,
                    isScrollable: true,
                    padding: EdgeInsets.zero,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      DashboardDrawerLinkWidget(
                        title: HubDetailPage.name,
                        route: HubDetailPage.routePath,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(child: child),
        );
      },
    );
  }
}
