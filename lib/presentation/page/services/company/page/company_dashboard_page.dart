import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../../core/component/router/app_router.dart';
import '../../../../feature/scaffold/part.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/dashboard_drawer_link_widget.dart';
import '../cubit/company_cubit.dart';
import 'company_detail_page.dart';

@RoutePage(name: CompanyDashboardPage.routeName)
class CompanyDashboardPage extends StatelessWidget {
  const CompanyDashboardPage({
    super.key,
    @PathParam() required this.alias,
  });

  final String alias;

  static const String routePath = 'companies/:alias';
  static const String routeName = 'CompanyDashboardRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          key: ValueKey('company-$alias-dashboard'),
          lazy: false,
          create: (_) => CompanyCubit(
            alias,
            repository: getIt(),
            languageRepository: getIt(),
          ),
        ),
        BlocProvider(
          create: (_) => ScaffoldCubit(),
        ),
      ],
      child: const CompanyDashboardPageView(),
    );
  }
}

class CompanyDashboardPageView extends StatelessWidget {
  const CompanyDashboardPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final companyCubit = context.read<CompanyCubit>();

    return AutoTabsRouter.tabBar(
      routes: [
        CompanyDetailRoute(),
      ],
      builder: (context, child, controller) {
        return Scaffold(
          key: context.read<ScaffoldCubit>().key,
          appBar: AppBar(
            title: Text(companyCubit.state.alias),
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
                        title: CompanyDetailPage.title,
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
