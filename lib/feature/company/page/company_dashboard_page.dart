import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/dashboard_drawer_link_widget.dart';
import '../../../component/di/dependencies.dart';
import '../../../component/router/app_router.dart';
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
    return BlocProvider(
      key: ValueKey('company-$alias-dashboard'),
      lazy: false,
      create: (_) => CompanyCubit(
        alias,
        repository: getIt.get<CompanyRepository>(),
        languageRepository: getIt.get<LanguageRepository>(),
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
            drawer: const NavigationDrawer(
              children: [
                DashboardDrawerLinkWidget(
                  title: CompanyDetailPage.title,
                  route: CompanyDetailPage.routePath,
                ),
              ],
            ),
            body: SafeArea(child: child),
          );
        },
      ),
    );
  }
}
