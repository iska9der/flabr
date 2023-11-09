import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/dashboard_drawer_link_widget.dart';
import '../../../component/di/dependencies.dart';
import '../../../component/router/app_router.dart';
import '../../../component/theme/constants.dart';
import '../../enhancement/scaffold/cubit/scaffold_cubit.dart';
import '../../settings/repository/language_repository.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          key: ValueKey('user-$login-dashboard'),
          lazy: false,
          create: (_) => UserCubit(
            login,
            repository: getIt.get<UserRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => ScaffoldCubit(),
        ),
      ],
      child: const UserDashboardView(),
    );
  }
}

class UserDashboardView extends StatelessWidget {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();

    return AutoTabsRouter.tabBar(
      routes: const [
        UserDetailRoute(),
        UserArticleListRoute(),
        UserBookmarkListRoute(),
      ],
      builder: (context, child, controller) {
        return Scaffold(
          key: context.read<ScaffoldCubit>().key,
          appBar: AppBar(
            toolbarHeight: fToolBarDashboardHeight,
            title: Text(userCubit.state.login),
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
