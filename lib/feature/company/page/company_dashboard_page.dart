import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../../component/router/app_router.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../../user/widget/nav_link_widget.dart';
import '../cubit/company_cubit.dart';
import '../repository/company_repository.dart';
import 'company_detail_page.dart';

@RoutePage(name: CompanyDashboardPage.routeName)
class CompanyDashboardPage extends StatelessWidget {
  const CompanyDashboardPage({
    Key? key,
    @PathParam() required this.alias,
  }) : super(key: key);

  final String alias;

  static const String routePath = 'companies/:alias';
  static const String routeName = 'CompanyDashboardRoute';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey('company-$alias-dashboard'),
      lazy: false,
      create: (c) => CompanyCubit(
        alias,
        repository: getIt.get<CompanyRepository>(),
        langUI: context.read<SettingsCubit>().state.langUI,
        langArticles: context.read<SettingsCubit>().state.langArticles,
      ),
      child: AutoTabsRouter(
        routes: const [
          CompanyDetailRoute(),
        ],
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(alias),
            ),
            drawer: const Drawer(
              child: SafeArea(
                child: Column(
                  children: [
                    NavLinkWidget(
                      title: CompanyDetailPage.title,
                      route: CompanyDetailPage.routePath,
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(child: child),
          );
        },
      ),
    );
  }
}
