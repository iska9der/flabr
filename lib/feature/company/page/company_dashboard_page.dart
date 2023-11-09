import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/dashboard_drawer_link_widget.dart';
import '../../../component/di/dependencies.dart';
import '../../../component/router/app_router.dart';
import '../../../component/theme.dart';
import '../../enhancement/scaffold/cubit/scaffold_cubit.dart';
import '../../settings/repository/language_repository.dart';
import '../cubit/company_cubit.dart';
import '../repository/company_repository.dart';
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
            repository: getIt.get<CompanyRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
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
      routes: const [
        CompanyDetailRoute(),
      ],
      builder: (context, child, controller) {
        return Scaffold(
          key: context.read<ScaffoldCubit>().key,
          appBar: AppBar(
            toolbarHeight: fToolBarDashboardHeight,
            title: Text(companyCubit.state.alias),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ColoredBox(
                  color: Theme.of(context).colorScheme.surface,
                  child: TabBar(
                    controller: controller,
                    isScrollable: true,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      DashboardDrawerLinkWidget(
                        title: CompanyDetailPage.title,
                        route: CompanyDetailPage.routePath,
                      )
                    ],
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}
