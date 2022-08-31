import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../../component/router/app_router.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/user_cubit.dart';
import '../service/user_service.dart';
import '../widget/nav_link_widget.dart';
import 'user_article_page.dart';
import 'user_detail_page.dart';

class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({
    Key? key,
    @PathParam() required this.login,
  }) : super(key: key);

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
        service: getIt.get<UserService>(),
        langUI: context.read<SettingsCubit>().state.langUI,
        langArticles: context.read<SettingsCubit>().state.langArticles,
      ),
      child: AutoTabsRouter(
        routes: const [
          UserDetailRoute(),
          UserArticleRoute(),
        ],
        builder: (context, child, animation) {
          return Scaffold(
            appBar: AppBar(
              title: Text(login),
            ),
            drawer: Drawer(
              child: SafeArea(
                child: Column(
                  children: const [
                    NavLinkWidget(
                      title: UserDetailPage.title,
                      route: UserDetailPage.routePath,
                    ),
                    NavLinkWidget(
                      title: UserArticlePage.title,
                      route: UserArticlePage.routePath,
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
