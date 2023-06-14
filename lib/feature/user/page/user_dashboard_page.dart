import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../../component/router/app_router.dart';
import '../../../widget/dashboard_drawer_link_widget.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/user_cubit.dart';
import '../repository/user_repository.dart';
import 'user_article_list_page.dart';
import 'user_bookmark_list_page.dart';
import 'user_detail_page.dart';

@RoutePage(name: UserDashboardPage.routeName)
class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({
    super.key,
    @PathParam() required this.login,
  });

  final String login;

  static const String routePath = 'users/:login';
  static const String routeName = 'UserDashboardRoute';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey('user-$login-dashboard'),
      lazy: false,
      create: (c) => UserCubit(
        login,
        repository: getIt.get<UserRepository>(),
        langUI: context.read<SettingsCubit>().state.langUI,
        langArticles: context.read<SettingsCubit>().state.langArticles,
      ),
      child: AutoTabsRouter(
        routes: const [
          UserDetailRoute(),
          UserArticleListRoute(),
          UserBookmarkListRoute(),
        ],
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(login),
            ),
            drawer: const NavigationDrawer(
              children: [
                DashboardDrawerLinkWidget(
                  title: UserDetailPage.title,
                  route: UserDetailPage.routePath,
                ),
                DashboardDrawerLinkWidget(
                  title: UserArticleListPage.title,
                  route: UserArticleListPage.routePath,
                ),
                DashboardDrawerLinkWidget(
                  title: UserBookmarkListPage.title,
                  route: UserBookmarkListPage.routePath,
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
